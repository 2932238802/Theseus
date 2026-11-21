#!/usr/bin/env node
/*
 * 从 mindmap-data.js 生成 theseus-mindmap.md（Mermaid mindmap + 纯文本大纲）。
 * 用法：node doc/map/build-md.mjs
 */
import fs from "node:fs";
import path from "node:path";
import vm from "node:vm";
import { fileURLToPath } from "node:url";

const dir = path.dirname(fileURLToPath(import.meta.url));
const dataPath = path.join(dir, "mindmap-data.js");
const outPath = path.join(dir, "theseus-mindmap.md");

const sandbox = {};
vm.createContext(sandbox);
vm.runInContext(fs.readFileSync(dataPath, "utf8"), sandbox, { filename: "mindmap-data.js" });
const DATA = sandbox.THESEUS_MINDMAP;

if (!DATA || !Array.isArray(DATA.branches)) {
  console.error("mindmap-data.js 未导出 THESEUS_MINDMAP");
  process.exit(1);
}

function esc(label) {
  return String(label)
    .replace(/\r?\n/g, " ")
    .replace(/\[/g, "［")
    .replace(/\]/g, "］")
    .replace(/\(/g, "（")
    .replace(/\)/g, "）")
    .replace(/\{/g, "｛")
    .replace(/\}/g, "｝")
    .replace(/\|/g, "｜")
    .replace(/`/g, "");
}

let seq = 0;
function emitMermaid(node, depth, out) {
  const id = "n" + (++seq);
  out.push("  ".repeat(depth + 1) + id + "[" + esc(node.label) + "]");
  (node.children || []).forEach((child) => emitMermaid(child, depth + 1, out));
}

function emitOutline(node, depth, out) {
  out.push("  ".repeat(depth) + "- " + node.label);
  (node.children || []).forEach((child) => emitOutline(child, depth + 1, out));
}

const mermaid = ["mindmap", "  root((" + esc(DATA.title) + "))"];
DATA.branches.forEach((branch) => emitMermaid(branch, 1, mermaid));

const outline = [];
DATA.branches.forEach((branch) => emitOutline(branch, 0, outline));

const md = [
  "# Theseus 项目全景思维导图",
  "",
  "> " + DATA.subtitle,
  ">",
  "> 交互版：[" + "theseus-mindmap.html](./theseus-mindmap.html)（离线可用）",
  "> 数据源：`mindmap-data.js`；Mermaid 与大纲由 `build-md.mjs` 生成，不要手改生成段落。",
  "> 维护：改 `mindmap-data.js` 后执行 `node doc/map/build-md.mjs`。",
  "",
  "## Mermaid 源图",
  "",
  "> GitHub、VS Code 与新版本 Mermaid 可直接渲染 mindmap；若渲染器版本较旧，打开 HTML 版。",
  "",
  "```mermaid",
  ...mermaid,
  "```",
  "",
  "## 纯文本大纲",
  "",
  ...outline,
  ""
].join("\n");

fs.writeFileSync(outPath, md, "utf8");
console.log("已生成 " + path.relative(process.cwd(), outPath) + "（" + mermaid.length + " 行 Mermaid）");
