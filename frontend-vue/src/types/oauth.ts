export interface OAuthProvider {
  provider: string
  enabled: boolean
}

export interface OAuthBinding {
  provider: string
  loginName: string
  displayName?: string
  email?: string
  createdAt: string
  lastLoginAt?: string
}
