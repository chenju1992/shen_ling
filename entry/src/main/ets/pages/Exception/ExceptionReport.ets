import { HmCard, HmCardItem, HmNavBar, HmUpload, HmUploadClass } from '../../components'
@Entry
@Component
struct ExceptionReport {
  @State exceptionImagesList: HmUploadClass = new HmUploadClass()
  build() {
    Column() {
      HmNavBar({ title: '上报异常' })
      HmCard() {
        HmCardItem({ leftTitle: '异常时间', rightText: '请选择' })
        HmCardItem({ leftTitle: '上报位置', rightText: '请选择' })
        HmCardItem({ leftTitle: '异常类型', rightText: '请选择' })
        HmCardItem({ leftTitle: '异常描述', rightText: '', showRightIcon: false, showBottomBorder: false })
        TextArea({
          placeholder: '请输入异常描述'
        }).height(130).borderRadius(8).placeholderColor($r('app.color.text_secondary')).fontSize(14)
        Text(`0/50`)
          .margin({
            top: -30
          })
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 15 })
          .fontColor($r('app.color.text_secondary'))
        Row().height(20)

      }
      HmCard() {
        HmUpload({ title: '上传图片(最多6张)',  upClass: this.exceptionImagesList, canUpload: true  })
        Row().height(20)
      }
      Row() {
        Button("提交").height(50).width(207).backgroundColor($r('app.color.primary_disabled'))
      }.position({
        y: '100%'
      }).height(70).translate({
        y: -70
      }).width('100%').justifyContent(FlexAlign.Center).backgroundColor($r('app.color.white'))
    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}