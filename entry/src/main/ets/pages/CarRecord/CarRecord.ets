import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { carRecord, getTaskDetail } from '../../api'
import { HmNavBar, HmCard, HmCardItem, HmCheckBox } from '../../components'
import { HmDateTimePicker } from '../../components/HmDateTimePicker'
import { CarRecordType, CarRecordTypeModel, CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
@Entry
@Component
struct CarRecord {
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State
  carRecord: CarRecordTypeModel = new CarRecordTypeModel({} as CarRecordType)

  dateTimePicker: CustomDialogController = new CustomDialogController({
    builder: HmDateTimePicker({
      onFinish: (value) => {
        this.carRecord.endTime = value
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false
  })

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      this.getTaskDetail(params.id)
    }
  }
  async getTaskDetail (id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  async btnCarRecord () {
    this.carRecord.id = this.taskDetailData.transportTaskId // 交车的id是任务id
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime //实际出发时间
    if(!this.carRecord.endTime) {
      promptAction.showToast({
        message: '回车时间不能为空'
      })
      return
    }
    await carRecord(this.carRecord)
    promptAction.showToast({
      message: '交车成功'
    })
    router.clear() // 销毁页面栈
    router.replaceUrl({
      url: 'pages/Index/Index'
    })
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
          leftTitle: '回车时间',
          rightText: this.carRecord.endTime||'请选择',
          showBottomBorder: false,
          onRightClick: () => {
            this.dateTimePicker.open()
          }
        })
        HmCheckBox({ value: !!this.carRecord.isBreakRules, title: '车辆违章',
          checkChange: (value) => {
            this.carRecord.isBreakRules = value
          } })
        HmCheckBox({ value: !!this.carRecord.isFault, title: '车辆故障',
          checkChange: (value) => {
            this.carRecord.isFault = value
          } })
        HmCheckBox({ value: !!this.carRecord.isAccident, title: '车辆事故',
          checkChange: (value) => {
            this.carRecord.isAccident = value
          }})
      }
      // 底部内容
      Row() {
        Button("交车")
          .height(50)
          .backgroundColor($r("app.color.primary"))
          .width(207)
          .onClick(() => {
            this.btnCarRecord()
          })
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