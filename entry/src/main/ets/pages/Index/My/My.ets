import { HmCard, HmCardItem } from '../../../components'
import { UserInfo, UserInfoModel, UserTaskInfo, UserTaskInfoModel, UserTaskInfoParamsModel } from '../../../models'
import { getUserInfo, getUserTaskInfo } from '../../../api'
import router from '@ohos.router'

@Preview
@Component
struct My {

  @State
  userInfo: UserInfoModel = new UserInfoModel({} as UserInfo)

  @State
  userTaskInfo: UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)

  queryTaskParams: UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear().toString(),
    month: (new Date().getMonth() + 1).toString()
  })

  build() {
    Column(){
      // 基本信息
      Column() {
        Image(this.userInfo.avatar || $r("app.media.ic_avatar_driver"))
          .width(67)
          .height(67)
          .borderRadius(34.5)
          .backgroundColor($r('app.color.white'))
        Text(this.userInfo.name)
          .fontSize(18)
          .fontWeight(600)
          .lineHeight(25)
          .margin({
            top: 9,
            bottom: 9
          })
          .fontColor($r('app.color.white'))
        Text(`司机编号: ${this.userInfo.number}`).fontSize(14).fontWeight(400).lineHeight(20).fontColor($r('app.color.white'))
        Text(`手机号: ${this.userInfo.phone }`)
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .margin({
            top: 10
          })
          .fontColor($r('app.color.white'))
      }
      .backgroundImage($r("app.media.bg_page_my"))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height(292)
      .margin({
        top: -2
      })

      // 本月任务
      Column() {
        Text(this.userTaskInfo.taskAmounts?.toString() || '').fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
        Row() {
          Column() {
            Text("1000").fontSize(18).fontColor($r('app.color.text_primary')).lineHeight(25).margin({
              bottom: 17
            })
            Text(this.userTaskInfo.completedAmounts?.toString()).fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text("1000")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text(this.userTaskInfo.transportMileage?.toString() || '').fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)

          Column() {
            Text("1000")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround).layoutWeight(1)
        }.justifyContent(FlexAlign.SpaceBetween).width('100%').layoutWeight(1)
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .margin({ left: 14.5, right: 14.5, top: -55, bottom: 15 })
      .height(134)
      .padding({ top: 13.5, bottom: 13.5 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 信息列表
      HmCard() {
        HmCardItem({ leftTitle: '车辆信息', rightText: '', onRightClick: () => {
          router.pushUrl({
            url: 'pages/Car/Car'
          })
        } })
        HmCardItem({ leftTitle: '任务设置', rightText: '', onRightClick: () => {
          router.pushUrl({
            url: 'pages/UserTask/UserTask'
          })
        } })
        HmCardItem({ leftTitle: '系统设置', rightText: '', showBottomBorder: false })
      }

    }.width('100%').height('100%').backgroundColor($r('app.color.background_page')).borderRadius(8)
  }

  aboutToAppear() {
    this.getUserInfo()
    this.getUserTaskInfo()
  }



  async getUserInfo() {
    this.userInfo = await getUserInfo()
  }

  async getUserTaskInfo() {
    this.userTaskInfo = await getUserTaskInfo(this.queryTaskParams)
  }
}

export default My