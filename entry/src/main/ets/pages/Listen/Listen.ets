import notificationManager from '@ohos.notificationManager'

@Entry
@Component
struct Listen {
  @StorageProp("order_id")
  order_id: number = 0
  aboutToAppear() {
    const number = AppStorage.Get<number>("notifyId")
    notificationManager.cancel(number) // 通知已经收到 取消通知的消息
  }
  build() {
    Column({ space: 20 }) {
      Row() {
        Text(`单号: ${this.order_id}`)
          .fontSize(30)
      }
      Row() {
        Button("去接单")
          .height(50)
          .borderRadius(20)
          .fontSize(20)
          .width('100%')
          .backgroundColor($r("app.color.primary"))
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding({
      left: 20,
      right: 20
    })
  }
}