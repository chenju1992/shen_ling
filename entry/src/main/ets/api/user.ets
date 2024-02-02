import { Request } from '../utils'
import { LoginFormModel } from '../models'
// 登录接口实现
export const login = (data: LoginFormModel) => {
  return Request.post<string>("/login/account", data)
}