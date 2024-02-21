import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { delay } from '../../api'
import { HmNavBar, HmCard, HmCardItem } from '../../components'
import { HmDateTimePicker } from '../../components/HmDateTimePicker'
import { CommonRouterParams, DelayParamsType, DelayParamsTypeModel } from '../../models'
@Entry
@Component
struct Delay {
  @State
  delayForm: DelayParamsTypeModel = new DelayParamsTypeModel({} as DelayParamsType)
  @State
  oldTime: string = ""
  @State
  maxSizeNumber:number = 50


  dateTimePicker: CustomDialogController = new CustomDialogController({
    builder: HmDateTimePicker({
      onFinish: (value) => {
        this.delayForm.delayTime = value // 赋值时间
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false
  })

  getBtnEnable() {
    return !!(this.delayForm.id && this.delayForm.delayReason && this.delayForm.delayTime)
  }

  async delay() {
    await delay(this.delayForm)
    promptAction.showToast({
      message: '延迟收货成功'
    })
    router.back()
  }

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id && params.oldTime) {
      this.delayForm.id = params.id
      this.oldTime = params.oldTime
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '延迟提货' })
      HmCard(){
        HmCardItem({ leftTitle: '原定时间', rightText: this.oldTime, showRightIcon: false })
        HmCardItem({ leftTitle: '延迟时间', rightText: this.delayForm.delayTime, onRightClick : ()=>{
          this.dateTimePicker.open()} })
        TextArea({ placeholder: '请输入延迟提货原因', text: this.delayForm.delayReason}).backgroundColor($r('app.color.background_page')).margin({
          top: 20
        }).borderRadius(8).height(130).placeholderColor($r('app.color.text_secondary')).fontSize(14).onChange((value) => {
          if (value.length <= this.maxSizeNumber) {
            this.delayForm.delayReason = value
          }
        })
        Text(`${this.delayForm.delayReason?.length || 0}/${this.maxSizeNumber}`).margin({
          top: -30
        }).textAlign(TextAlign.End).width('100%').padding({ right: 15 }).fontColor($r('app.color.text_secondary'))
        Row() {
          Button("提交").height(50).width(207).backgroundColor(
            this.getBtnEnable() ?  $r('app.color.primary') :
            $r('app.color.primary_disabled')
          ).enabled(this.getBtnEnable()).onClick(() => {

          })
        }.justifyContent(FlexAlign.Center).padding({
          top: 20,
          bottom: 20
        })

      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}