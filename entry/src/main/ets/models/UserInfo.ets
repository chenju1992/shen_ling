export interface UserInfo {
  /** 头像 */
  avatar: string;
  /** 姓名 */
  name: string;
  /** 司机编号 */
  number: string;
  /** 手机号 */
  phone: string;
}
export class UserInfoModel implements UserInfo {
  avatar: string = ''
  name: string = ''
  number: string = ''
  phone: string = ''

  constructor(model: UserInfo) {
    this.avatar = model.avatar
    this.name = model.name
    this.number = model.number
    this.phone = model.phone
  }
}
