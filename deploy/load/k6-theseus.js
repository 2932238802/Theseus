// Theseus 只读压测脚本（k6）。
//
// 默认场景：
//   browse  题库列表、筛选、题目详情
//   read    首页概览、通知、论坛、榜单、个人提交记录
//
// 可选场景（默认关闭，会真实入队判题）：
//   submit  提交代码，每个 VU 使用独立账号
//
// 快速开始（在仓库根目录）：
//   K6_USERNAME=loadtest K6_PASSWORD='...' \
//     k6 run deploy/load/k6-theseus.js
//
// 详细说明见 deploy/load/README.md。脚本不会打印账号、密码或 token。

import http from 'k6/http';
import { check, fail, sleep } from 'k6';

const BASE_URL = (__ENV.BASE_URL || 'http://127.0.0.1:8080').replace(/\/+$/, '');
const API = `${BASE_URL}/api`;
const USERNAME = __ENV.K6_USERNAME || '';
const PASSWORD = __ENV.K6_PASSWORD || '';

const DURATION = __ENV.K6_DURATION || '3m';
const RAMP_UP = __ENV.K6_RAMP_UP || '30s';
const RAMP_DOWN = __ENV.K6_RAMP_DOWN || '30s';
const BROWSE_VUS = positiveInt(__ENV.K6_BROWSE_VUS, 10);
const READ_VUS = positiveInt(__ENV.K6_READ_VUS, 8);

const SUBMIT_ENABLED = __ENV.K6_ENABLE_SUBMIT === '1';
const SUBMIT_VUS = positiveInt(__ENV.K6_SUBMIT_VUS, 1);
const SUBMIT_PROBLEM_ID = Number(__ENV.K6_SUBMIT_PROBLEM_ID || 0);
const SUBMIT_LANGUAGE = __ENV.K6_SUBMIT_LANGUAGE || 'python';
const SUBMIT_CODE = __ENV.K6_SUBMIT_CODE || 'print(0)\n';
const SUBMIT_ACCOUNTS = parseAccounts(__ENV.K6_SUBMIT_ACCOUNTS || '');

const JSON_HEADERS = { 'Content-Type': 'application/json' };

const stages = (target) => [
  { duration: RAMP_UP, target },
  { duration: DURATION, target },
  { duration: RAMP_DOWN, target: 0 },
];

const scenarios = {
  browse: {
    executor: 'ramping-vus',
    exec: 'browse',
    startVUs: 0,
    stages: stages(BROWSE_VUS),
    gracefulStop: '30s',
  },
  read: {
    executor: 'ramping-vus',
    exec: 'read',
    startVUs: 0,
    stages: stages(READ_VUS),
    gracefulStop: '30s',
  },
};

if (SUBMIT_ENABLED) {
  if (SUBMIT_ACCOUNTS.length === 0) {
    throw new Error('K6_ENABLE_SUBMIT=1 时必须设置 K6_SUBMIT_ACCOUNTS（user:pass,user:pass）');
  }
  scenarios.submit = {
    executor: 'constant-vus',
    exec: 'submit',
    vus: SUBMIT_VUS,
    duration: DURATION,
    gracefulStop: '60s',
  };
}

export const options = {
  scenarios,
  // 单机 2 核部署的保守阈值；按目标环境调整后再作为回归基线。
  thresholds: {
    http_req_failed: ['rate<0.01'],
    checks: ['rate>0.99'],
    http_req_duration: ['p(95)<800', 'p(99)<2000'],
    'http_req_duration{name:problems-list}': ['p(95)<500'],
    'http_req_duration{name:problem-detail}': ['p(95)<500'],
    'http_req_duration{name:forum-posts}': ['p(95)<500'],
    'http_req_duration{name:forum-post-detail}': ['p(95)<500'],
    'http_req_duration{name:submissions-list}': ['p(95)<500'],
    'http_req_duration{name:notifications-list}': ['p(95)<500'],
    'http_req_duration{name:rankings-list}': ['p(95)<500'],
  },
  insecureSkipTLSVerify: __ENV.K6_INSECURE === '1',
  discardResponseBodies: false,
};

export function setup() {
  if (!USERNAME || !PASSWORD) {
    fail('缺少 K6_USERNAME / K6_PASSWORD；请使用专用压测账号，详细说明见 deploy/load/README.md');
  }

  const token = login(USERNAME, PASSWORD);
  const headers = authHeaders(token);

  const problemIds = pickIds(fetchData('/problems?page=1&size=50', headers), 'problems');
  const generalPostIds = pickIds(
    fetchData('/forum/posts?board=general&page=1&size=20&sort=latest', headers),
    'posts',
  );
  // 面经板块只对 Plus、管理员与作者开放；普通压测账号返回 403 时跳过该板块。
  const interviewData = fetchDataAllowForbidden(
    '/forum/posts?board=interview&page=1&size=20&sort=latest',
    headers,
  );
  const interviewPostIds = interviewData ? pickIds(interviewData, 'posts') : [];
  const interviewAccess = interviewData !== null;
  const submitTokens = [];
  if (SUBMIT_ENABLED) {
    for (const account of SUBMIT_ACCOUNTS) {
      submitTokens.push(login(account.username, account.password));
    }
    if (SUBMIT_PROBLEM_ID <= 0 && problemIds.length === 0) {
      fail('题库没有可提交的题目，无法开启 submit 场景');
    }
  }

  // 只输出数量，不输出账号、密码或 token。
  console.log(
    `数据准备完成：题目 ${problemIds.length}、普通帖 ${generalPostIds.length}、` +
      `面经帖 ${interviewPostIds.length}` +
      (interviewAccess ? '' : '（无面经权限）') +
      (SUBMIT_ENABLED ? `、提交账号 ${submitTokens.length}` : ''),
  );

  return {
    token,
    problemIds,
    generalPostIds,
    interviewPostIds,
    interviewAccess,
    submitTokens,
    submitProblemId: SUBMIT_PROBLEM_ID,
  };
}

// 题库浏览：对应首页/题库页的主要请求。
export function browse(data) {
  const headers = authHeaders(data.token);
  const roll = Math.random();

  if (roll < 0.7 || data.problemIds.length === 0) {
    const page = Math.random() < 0.8 ? 1 : 2 + Math.floor(Math.random() * 4);
    const response = get(`/problems?page=${page}&size=20`, headers, 'problems-list');
    check(response, { '题库列表 200': (r) => r.status === 200 });
  } else if (roll < 0.85) {
    const difficulty = ['easy', 'medium', 'hard'][Math.floor(Math.random() * 3)];
    const response = get(
      `/problems?page=1&size=20&difficulty=${difficulty}`,
      headers,
      'problems-list',
    );
    check(response, { '题库筛选 200': (r) => r.status === 200 });
  } else {
    const id = randomItem(data.problemIds);
    const response = get(`/problems/${id}`, headers, 'problem-detail');
    check(response, { '题目详情 200': (r) => r.status === 200 });
  }

  sleep(1 + Math.random() * 2);
}

// 登录态阅读：首页、通知、论坛、榜单与个人提交记录。
export function read(data) {
  const headers = authHeaders(data.token);
  const roll = Math.random();

  if (roll < 0.18) {
    const response = get('/home/overview', headers, 'home-overview');
    check(response, { '首页概览 200': (r) => r.status === 200 });
  } else if (roll < 0.32) {
    const response = get('/auth/me', headers, 'auth-me');
    check(response, { '当前用户 200': (r) => r.status === 200 });
  } else if (roll < 0.44) {
    const response = get('/notifications/unread-count', headers, 'notifications-unread');
    check(response, { '未读数 200': (r) => r.status === 200 });
  } else if (roll < 0.54) {
    const response = get('/notifications?page=1&size=20', headers, 'notifications-list');
    check(response, { '通知列表 200': (r) => r.status === 200 });
  } else if (roll < 0.72) {
    const board = data.interviewAccess && Math.random() < 0.15 ? 'interview' : 'general';
    const sort = Math.random() < 0.8 ? 'latest' : 'hot';
    const response = get(
      `/forum/posts?board=${board}&page=1&size=20&sort=${sort}`,
      headers,
      'forum-posts',
    );
    check(response, { '帖子列表 200': (r) => r.status === 200 });
  } else if (roll < 0.84) {
    const ids = Math.random() < 0.8 ? data.generalPostIds : data.interviewPostIds;
    if (ids.length === 0) {
      const response = get('/forum/posts?board=general&page=1&size=20', headers, 'forum-posts');
      check(response, { '帖子列表 200': (r) => r.status === 200 });
    } else {
      const response = get(`/forum/posts/${randomItem(ids)}`, headers, 'forum-post-detail');
      check(response, { '帖子详情 200': (r) => r.status === 200 });
    }
  } else if (roll < 0.93) {
    const response = get('/submissions?page=1&size=20', headers, 'submissions-list');
    check(response, { '提交记录 200': (r) => r.status === 200 });
  } else {
    const response = get('/rankings?page=1&size=20', headers, 'rankings-list');
    check(response, { '榜单 200': (r) => r.status === 200 });
  }

  sleep(1 + Math.random() * 3);
}

// 真实提交：只用于评估判题队列吞吐，默认关闭。
// 每个 VU 固定使用一个独立账号，避免连续登录使彼此的 JWT 失效。
export function submit(data) {
  const tokens = data.submitTokens;
  if (tokens.length === 0) {
    return;
  }
  const token = tokens[(__VU - 1) % tokens.length];
  const problemId = data.submitProblemId > 0 ? data.submitProblemId : randomItem(data.problemIds);
  if (!problemId) {
    fail('submit 场景没有可用题目');
  }

  const response = http.post(
    `${API}/submissions`,
    JSON.stringify({ problem_id: problemId, language: SUBMIT_LANGUAGE, code: SUBMIT_CODE }),
    {
      headers: { ...JSON_HEADERS, Authorization: `Bearer ${token}` },
      tags: { name: 'submission-create' },
    },
  );
  check(response, {
    '提交成功 201': (r) => r.status === 201,
    '提交响应 success': (r) => r.status === 201 && r.json('success') === true,
  });

  // 给判题 Worker 留出处理时间，避免把队列塞满后测出的只是积压。
  sleep(10);
}

function login(username, password) {
  const response = http.post(
    `${API}/auth/login`,
    JSON.stringify({ username, password }),
    { headers: JSON_HEADERS, tags: { name: 'auth-login' } },
  );
  if (response.status !== 200) {
    fail(`压测账号登录失败：HTTP ${response.status}（请检查账号、密码与锁定状态）`);
  }
  const token = response.json('data.token');
  if (typeof token !== 'string' || token.length === 0) {
    fail('登录响应中没有 token');
  }
  return token;
}

function authHeaders(token) {
  return { Authorization: `Bearer ${token}` };
}

function get(path, headers, name) {
  return http.get(`${API}${path}`, { headers, tags: { name } });
}

// setup 中拉取列表；失败直接终止，避免在数据为空的情况下得到误导性结论。
function fetchData(path, headers) {
  const response = get(path, headers, `setup ${path}`);
  if (response.status !== 200) {
    fail(`准备数据失败：GET ${path} 返回 ${response.status}`);
  }
  const body = response.json();
  if (!body || body.success !== true || !body.data) {
    fail(`准备数据失败：GET ${path} 返回结构不符合预期`);
  }
  return body.data;
}

// 403 表示账号没有该板块权限，返回 null 让调用方跳过；其它错误仍然中止。
function fetchDataAllowForbidden(path, headers) {
  const response = get(path, headers, `setup ${path}`);
  if (response.status === 403) {
    return null;
  }
  if (response.status !== 200) {
    fail(`准备数据失败：GET ${path} 返回 ${response.status}`);
  }
  const body = response.json();
  if (!body || body.success !== true || !body.data) {
    fail(`准备数据失败：GET ${path} 返回结构不符合预期`);
  }
  return body.data;
}

function pickIds(data, key) {
  const items = data && Array.isArray(data[key]) ? data[key] : [];
  return items.map((item) => item && item.id).filter((id) => Number.isInteger(id) && id > 0);
}

function parseAccounts(value) {
  return value
    .split(',')
    .map((entry) => entry.trim())
    .filter(Boolean)
    .map((entry) => {
      const separator = entry.indexOf(':');
      if (separator <= 0) {
        throw new Error('K6_SUBMIT_ACCOUNTS 格式应为 user:pass,user:pass');
      }
      return { username: entry.slice(0, separator), password: entry.slice(separator + 1) };
    });
}

function positiveInt(value, fallback) {
  const parsed = Number(value);
  return Number.isInteger(parsed) && parsed > 0 ? parsed : fallback;
}

function randomItem(items) {
  return items[Math.floor(Math.random() * items.length)];
}

// 保留默认摘要的关键指标，避免依赖外部 jslib；设置 K6_SUMMARY_OUT 时另存原始 JSON。
export function handleSummary(data) {
  const metrics = data.metrics;
  const value = (name, key) => (metrics[name] && metrics[name].values[key] !== undefined
    ? metrics[name].values[key]
    : 0);
  const fixed = (number, digits = 2) => Number(number).toFixed(digits);

  const lines = [
    '',
    `请求数          ${value('http_reqs', 'count')}`,
    `请求速率        ${fixed(value('http_reqs', 'rate'))} req/s`,
    `失败率          ${fixed(value('http_req_failed', 'rate') * 100)} %`,
    `P95 延迟        ${fixed(value('http_req_duration', 'p(95)'))} ms`,
    `P99 延迟        ${fixed(value('http_req_duration', 'p(99)'))} ms`,
    `检查通过率      ${fixed(value('checks', 'rate') * 100)} %`,
    '',
  ];
  const output = { stdout: lines.join('\n') };
  const path = __ENV.K6_SUMMARY_OUT;
  if (path) {
    output[path] = JSON.stringify(data, null, 2);
  }
  return output;
}
