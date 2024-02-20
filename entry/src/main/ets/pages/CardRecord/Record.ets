import router from '@ohos.router'
import { getTaskDetail } from '../../api'
import { HmNavBar, HmCard, HmCardItem, HmCheckBox } from '../../components'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
@Entry
@Component
struct CarRecord {
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      this.getTaskDetail(params.id)
    }
  }
  async getTaskDetail (id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  build() {
    Column() {
      HmNavBar({ title: '回车登记' })
      HmCard(){
        HmCardItem({
          leftTitle: '出车时间',
          rightText: '2022.05.04 13:00'
        })
        HmCardItem({
          leftTitle: '出车时间',
          rightText: this.taskDetailData.actualDepartureTime
        })
        HmCheckBox({ value: false, title: '车辆违章' })
        HmCheckBox({ value: false, title: '车辆故障' })
        HmCheckBox({ value: false, title: '车辆事故' })
      }
      // 底部内容
      Row() {
        Button("交车",{ type: ButtonType.Capsule })
          .backgroundColor($r('app.color.primary'))
          .width(207)
          .height(50)
      }
      .backgroundColor($r('app.color.white'))
      .position({
        y: '100%'
      })
      .translate({
        y: -70
      })
      .height(70)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor($r('app.color.background_page'))
    .height('100%')
  }
}