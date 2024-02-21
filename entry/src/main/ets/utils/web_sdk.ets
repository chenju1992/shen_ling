import promptAction from '@ohos.promptAction'
import geoLocationManager from '@ohos.geoLocationManager';
import webview from '@ohos.web.webview';

export class WebSdkClass {
  static Controller: webview.WebviewController | null = null
  static Context: Context | null = null // 声明一个Context
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

  // 接收参数 触发事件
  receiveData(eventName: string, json: string) {
    WebSdkClass.Context?.eventHub?.emit(eventName, json)
  }
}