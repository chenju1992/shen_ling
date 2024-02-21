import { HmNavBar, HmCard, HmCardItem } from '../../components'
import { DelayParamsType, DelayParamsTypeModel } from '../../models'
@Entry
@Component
struct Delay {
  @State
  delayForm: DelayParamsTypeModel = new DelayParamsTypeModel({} as DelayParamsType)
  @State
  oldTime: string = ""
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
        HmCardItem({ leftTitle: '延迟时间', rightText: '' })
        TextArea({ placeholder: '请输入延迟提货原因' }).backgroundColor($r('app.color.background_page')).margin({
          top: 20
        }).borderRadius(8).height(130).placeholderColor($r('app.color.text_secondary')).fontSize(14)
        Text('0/50').margin({
          top: -30
        }).textAlign(TextAlign.End).width('100%').padding({ right: 15 }).fontColor($r('app.color.text_secondary'))
        Row() {
          Button("提交").height(50).width(207).
          backgroundColor($r('app.color.primary_disabled'))
        }.justifyContent(FlexAlign.Center).padding({
          top: 20,
          bottom: 20
        })

      }
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}