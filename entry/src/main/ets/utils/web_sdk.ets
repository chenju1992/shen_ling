import promptAction from '@ohos.promptAction'
import geoLocationManager from '@ohos.geoLocationManager';
import webview from '@ohos.web.webview';

export class WebSdkClass {
  static Controller: webview.WebviewController | null = null
  // 弹出
  alert(message: string) {
    AlertDialog.show({ message })
  }
  toast(message: string) {
    promptAction.showToast({ message })
  }
  async getLocation (funcName: string) {
    try {
      const result = await geoLocationManager.getCurrentLocation()
      WebSdkClass.Controller!.runJavaScript(`${funcName}(${result.longitude},${result.latitude} )`)
    }catch (error) {

    }
  }
}