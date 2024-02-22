import { HmNavBar, HmLoading, HmCalendar } from '../../components'
import { UserTaskInfoModel, UserTaskInfo, UserTaskInfoParamsModel } from '../../models'
import { getUserTaskInfo } from '../../api'
import DayJs from 'dayjs'
@Entry
@Component
struct UserTask {
  @State TaskInfo: UserTaskInfoModel = new UserTaskInfoModel({} as UserTaskInfo)
  @State list: string[] = []
  @State queryParams: UserTaskInfoParamsModel = new UserTaskInfoParamsModel({
    year: new Date().getFullYear()+"",
    month: new Date().getMonth() + 1 +""
  })
  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  async aboutToAppear() {
    this.getUserTask()
  }
  async getUserTask () {
    this.layer.open()
    this.TaskInfo = await getUserTaskInfo(this.queryParams)
    this.layer.close()
  }
  build() {
    Column() {
      HmNavBar({ title: '任务数据' })

      // 本月任务
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        Text("- 本月任务 -").fontSize(14).fontColor($r('app.color.text_secondary')).lineHeight(20)
        Row() {
          Column() {
            Text(this.TaskInfo.taskAmounts+ "").fontSize(18).fontColor($r('app.color.text_primary')).lineHeight(25).margin({
              bottom: 17
            })
            Text("任务总量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround)

          Column() {
            Text(this.TaskInfo.completedAmounts+"")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("完成任务量").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround)

          Column() {
            Text(this.TaskInfo.transportMileage+"")
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
              .margin({ bottom: 17 })
            Text("运输里程(km)").fontSize(12).fontColor($r('app.color.text_primary')).lineHeight(17)
          }.justifyContent(FlexAlign.SpaceAround)
        }.justifyContent(FlexAlign.SpaceEvenly).width('100%').flexGrow(1)
      }
      .backgroundColor($r('app.color.white'))
      .margin({ left: 14.5, right: 14.5 })
      .height(100).margin({
        top: 20,
        bottom: 20
      })
      HmCalendar({
        currentDate: DayJs().format("YYYY-MM-DD"),
        onChangeMonth: (value) => {
          this.queryParams.year = value.year
          this.queryParams.month = value.month
          this.getUserTask()
        }
      })
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}