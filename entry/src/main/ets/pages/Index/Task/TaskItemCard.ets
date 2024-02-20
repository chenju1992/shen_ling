import router from '@ohos.router'
import { CommonRouterParams, TaskInfoItem, TaskInfoItemModel, TaskTypeEnum } from '../../../models'
@Preview
@Component
struct TaskItemCard {
  taskItemData: TaskInfoItemModel = new TaskInfoItemModel({} as TaskInfoItem)

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      AlertDialog.show({
        message: params.id
      })
    }
  }


  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.taskItemData.transportTaskId}`)
          .fontSize(16)
          .fontColor($r("app.color.text_primary"))
          .fontWeight(500)
          .lineHeight(22)
      }.justifyContent(FlexAlign.SpaceBetween).width('100%')

      Row() {
        Text("起")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r("app.color.text_primary"))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text("北京市昌平区回龙观街道西三旗桥东金燕龙写字楼8877号")
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 21 }).width('100%')

      Row() {
        Text("止")
          .fontSize(12)
          .fontColor($r("app.color.white"))
          .backgroundColor($r('app.color.primary'))
          .width(22)
          .height(22)
          .borderRadius(11)
          .textAlign(TextAlign.Center)
        Text(this.taskItemData.endAddress)
          .margin({ left: 11.5 })
          .fontColor($r('app.color.text_secondary'))
          .fontSize(14)
      }.margin({ top: 14.5 }).width('100%')

      Divider()
        .vertical(true)
        .height(2)
        .color($r('app.color.background_divider'))
        .opacity(0.6)
        .margin({ left: 8, right: 8, top: 21 })
      Row() {
        Column() {
          Text('提货时间').fontSize(14).fontColor($r('app.color.text_secondary'))
          Text(this.taskItemData.planDepartureTime).fontSize(14).fontColor($r('app.color.text_secondary')).margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button(this.getBtnText(), { type: ButtonType.Capsule })
          .backgroundColor(this.getBtnEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .fontColor($r("app.color.white"))
          .fontSize(14)
          .height(32)
          .enabled(this.getBtnEnable())
          .onClick(()=>this.toPickUp())

      }.justifyContent(FlexAlign.SpaceBetween).width('100%')
    }
    .margin({ left: 15, right: 15, top: 15 })
    .padding({ left: 19.5, right: 19.5, bottom: 18.5, top: 18.5 })
    .borderRadius(10)
    .backgroundColor($r('app.color.white'))

  }

  // 获取按钮可用性
  getBtnEnable() {
    const value = this.taskItemData.status.toString()
    if (this.taskItemData.enablePickUp) {
      return true
    }
    switch (value) {
      case TaskTypeEnum.Line.toString():
      case TaskTypeEnum.Delivered.toString():
        return true
      default:
        return false
    }
  }

  // 获取按钮显示文本
  getBtnText() {
    const value = this.taskItemData.status.toString()
    switch (value) {
      case TaskTypeEnum.Waiting.toString():
        return "提货"
      case TaskTypeEnum.Line.toString():
        return "交货"
      case TaskTypeEnum.Delivered.toString():
        return "回车登记"
      default:
        return ""
    }
  }



  // 去提货
  toPickUp () {
    if(this.getBtnEnable()) {
      router.pushUrl({
        url: 'pages/TaskDetail/TaskDetail',
        params: {
          id: this.taskItemData.id
        }
      })
    }
  }



}

export default TaskItemCard