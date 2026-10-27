-- 仅用于本地/测试环境的管理员引导账号，请勿用于生产环境。
-- 初始密码：admin；首次登录后请立即修改。
-- 密码哈希由 backend-rust/src/utils/password.rs 使用的 Argon2id 默认参数生成。
-- 幂等：用户名或邮箱已存在时保留现有账号，不覆盖密码。
INSERT INTO users (
    username,
    email,
    password_hash,
    role,
    email_verified_at
)
VALUES (
    'admin',
    'admin@theseus.local',
    '$argon2id$v=19$m=19456,t=2,p=1$qv8iaQgEgWUlvnaYPAw+Sg$r0Fm/Iq+kxR7CGJjHL+EvUrOsXuWL42U3Ntb+B1FdJg',
    'admin',
    CURRENT_TIMESTAMP
)
ON CONFLICT DO NOTHING;
