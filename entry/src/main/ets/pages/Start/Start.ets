import {UserSettingClass} from '../../utils/settings'
import {AdvertisementClass} from '../../models/AdvertisementClass'
import router from '@ohos.router'

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  advertisementObject: AdvertisementClass  = new AdvertisementClass(false,0,'')

  timer: number = -1

  async aboutToAppear() {
    this.advertisementObject = await this.userSetting.getUserAdvertisement()
    setInterval(()=>{
      if(this.advertisementObject.adTimeInSecond == 0){
        clearInterval(this.timer)
        router.replaceUrl({url:'pages/Index'})
        return
      }
      this.advertisementObject.adTimeInSecond--
    },1000)
  }
  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.advertisementObject.advertisementImage).objectFit(ImageFit.Cover)
      Text(`${this.advertisementObject.adTimeInSecond}秒后跳过`)
        .onClick(()=>{router.replaceUrl({url:'pages/Index'})})
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r('app.color.background_page'))
        .textAlign(TextAlign.Center)

    }.height('100%').width('100%')
  }

  aboutToDisappear(){
    clearInterval(this.timer)
  }
}
