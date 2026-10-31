import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

const projectRoot = fileURLToPath(new URL('.', import.meta.url))

// Monaco 自托管：把 node_modules 里的静态资源同步到 public/monaco，
// 运行时由本站提供，不再依赖 jsDelivr。放在 vite 配置里执行，
// npm run dev、./dev.sh 直接调用 vite、以及 vite build 都能生效。
const syncMonacoAssets = (): void => {
  const packageJson = `${projectRoot}node_modules/monaco-editor/package.json`
  const source = `${projectRoot}node_modules/monaco-editor/min/vs`
  if (!existsSync(packageJson) || !existsSync(source)) {
    console.warn('[monaco] 未找到 monaco-editor，请先执行 npm install')
    return
  }
  const targetRoot = `${projectRoot}public/monaco`
  const target = `${targetRoot}/vs`
  const versionFile = `${targetRoot}/.version`
  const version = String(JSON.parse(readFileSync(packageJson, 'utf8')).version)
  if (existsSync(versionFile) && existsSync(target) && readFileSync(versionFile, 'utf8').trim() === version) {
    return
  }
  rmSync(target, { recursive: true, force: true })
  mkdirSync(targetRoot, { recursive: true })
  cpSync(source, target, { recursive: true })
  writeFileSync(versionFile, version)
}

syncMonacoAssets()

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:3000',
        changeOrigin: true,
        ws: true,
      },
      '/uploads': {
        target: 'http://127.0.0.1:3000',
        changeOrigin: true,
      },
    },
  },
})
