import preferences from '@ohos.data.preferences'
import { AdvertisementClass } from '../models/AdvertisementClass'
import {USER_SETTING,USER_SETTING_AD} from '../constants'

const defaultAdvertisement = new AdvertisementClass(true,5,$r('app.media.start'))

export class UserSettingClass{
  context: Context

  constructor(context:Context) {
    this.context = context
  }

  //获取存储用户信息的首选项仓库（异步操作）
  getStore(){
    return preferences.getPreferences(this.context,USER_SETTING)
  }

  async setUserAdvertisement(advertisement:AdvertisementClass){
    const advertisementStore = await this.getStore()
    await advertisementStore.put(USER_SETTING_AD,JSON.stringify(advertisement))
    await advertisementStore.flush()
  }

  async getUserAdvertisement():Promise<AdvertisementClass>{
    const advertisementStore = await this.getStore()
    return JSON.parse(await advertisementStore.get(USER_SETTING_AD,JSON.stringify(defaultAdvertisement)) as string) as AdvertisementClass
  }

}

