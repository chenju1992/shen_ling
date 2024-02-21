import router from '@ohos.router'
import { HmNavBar, HmCard, HmCardItem } from '../../components'
import geoLocationManager from '@ohos.geoLocationManager';
import webview from '@ohos.web.webview';
import { WebSdkClass } from '../../utils';


@Entry
@Component
struct SelectLocation {

  webController: webview.WebviewController = new webview.WebviewController()
  webSdk: WebSdkClass = new WebSdkClass()



  aboutToAppear() {
    WebSdkClass.Controller = new webview.WebviewController()
    WebSdkClass.Context = getContext(this)
    WebSdkClass.Context
      .eventHub.on('search_list', (json: string) => {
      AlertDialog.show({ message: json })
    })
  }
  async getLocation () {
    try {
      const result = await geoLocationManager.getCurrentLocation()
      AlertDialog.show({
        message: JSON.stringify(result)
      })
    }catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }

  }
  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      Web({ src: $rawfile('location.html'), controller: WebSdkClass.Controller! }).height('100%')
        .javaScriptProxy({
          object: this.webSdk,
          name: "shenling",
          methodList: ["toast", "alert", 'getLocation'],
          controller: WebSdkClass.Controller!,
        })
      //  地图区域
      Text("地图")
      Column() {
        HmCard() {
          HmCardItem({ leftTitle: '回龙观街道', rightText: '100m以内' })
          HmCardItem({ leftTitle: '金燕龙科研楼', rightText: '100m以内' })
          HmCardItem({ leftTitle: '春野画室', rightText: '100m以内' })
          HmCardItem({ leftTitle: '光滑时代(金艳龙科研楼店)', rightText: '100m以内' })
          HmCardItem({ leftTitle: '上报位置', rightText:  '请选择', onRightClick: () => {
            router.pushUrl({
              url: 'pages/SelectLocation/SelectLocation'
            })
          }})
        }
      }.position({
        y: '100%'
      }).translate({
        y: -260
      })

    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}