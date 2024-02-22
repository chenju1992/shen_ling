import { HmNavBar } from '../../components'
import WebView from '@ohos.web.webview'
import { WebSdkClass } from '../../utils';
import router from '@ohos.router';
import { CommonRouterParams } from '../../models';

@Entry
@Component
struct NavigationPage {
  aboutToAppear() {
    WebSdkClass.Controller = new WebView.WebviewController()
    WebSdkClass.Context = getContext(this)
  }
  aboutToDisappear() {
    WebSdkClass.Controller = null
    WebSdkClass.Context = null
  }
  build() {
    Column() {
      HmNavBar({ title: '导航' })
      //  地图区域
      Web({ src: $rawfile('navigation.html'), controller: WebSdkClass.Controller! }).height('100%').onPageEnd(() => {
        const params = router.getParams() as CommonRouterParams
        if(params && params.start && params.end) {
          WebSdkClass.Controller!.runJavaScript(`beginDriving('${params.start}','${params.end}')`)
        }
      })
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}