import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'
import router from './router'

const savedTheme = localStorage.getItem('theseus-theme')
document.documentElement.dataset.theme = savedTheme ?? (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')

createApp(App).use(createPinia()).use(router).mount('#app')
