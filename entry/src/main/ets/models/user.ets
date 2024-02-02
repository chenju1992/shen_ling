export interface LoginForm {
  /** 登录账号 */
  account: string;
  /** 登录密码 */
  password: string;
}

export class LoginFormModel implements LoginForm {
  account: string = ''
  password: string = ''

  constructor(model: LoginForm) {
    this.account = model.account
    this.password = model.password
  }
}
