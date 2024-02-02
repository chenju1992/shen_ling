import {UserSettingClass} from '../../utils/settings'
import {AdvertisementClass} from '../../models/AdvertisementClass'
import router from '@ohos.router'
import { TOKEN_KEY } from '../../constants'

PersistentStorage.PersistProp(TOKEN_KEY, "")

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
        this.toNext()
        return
      }
      this.advertisementObject.adTimeInSecond--
    },1000)
  }
  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.advertisementObject.advertisementImage).objectFit(ImageFit.Cover)
      Text(`${this.advertisementObject.adTimeInSecond}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r('app.color.background_page'))
        .textAlign(TextAlign.Center)
        .onClick(()=>{this.toNext()})

    }.height('100%').width('100%')
  }

  toNext(){
    if(AppStorage.Get<string>(TOKEN_KEY)){
      router.replaceUrl({url:'pages/Index/Index'})
    }else{
      router.replaceUrl({url:'pages/Login/Login'})
    }
  }

  aboutToDisappear(){
    clearInterval(this.timer)
  }
}
