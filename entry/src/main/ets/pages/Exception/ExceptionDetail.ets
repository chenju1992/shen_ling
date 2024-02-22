import { HmNavBar, HmCardItem, HmCard, HmPreview } from '../../components'
import router from '@ohos.router'
import { CommonRouterParams, ExceptionListModel, ExceptionList, ImageList } from '../../models'

@Entry
@Component
struct ExceptDetail {
  @State submitForm: ExceptionListModel = new ExceptionListModel({} as ExceptionList)
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.formData) {
      // 检查formData
      this.submitForm = params.formData
    }
  }
  @Builder
  getCardChildren() {
    HmCardItem({ leftTitle: '异常时间', rightText: this.submitForm.exceptionTime, showRightIcon: false, })
    HmCardItem({ leftTitle: '上报位置', rightText: this.submitForm.exceptionPlace, showRightIcon: false, })
    HmCardItem({ leftTitle: '异常类型', rightText: this.submitForm.exceptionType, showRightIcon: false })
    HmCardItem({ leftTitle: '异常描述', showBottomBorder: false, showRightIcon: false, rightText: '' })
    Row() {
      Text(this.submitForm.exceptionDescribe).fontSize(14).fontColor($r('app.color.text_primary'))
    }.padding(15).justifyContent(FlexAlign.Start).width('100%')
  }
  @Builder
  getUpload() {
    if (this.submitForm.exceptionImagesList?.length) {
      Text("异常图片").width('100%').padding(10)
      Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
        ForEach(this.submitForm.exceptionImagesList, (item: ImageList) => {
          Image(item.url)
            .width(95)
            .height(95)
            .borderRadius(4)
            .margin({ right: 15 })
        })
      }
      .width('100%').margin({ top: 16.5, bottom: 16.5 })
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '异常详情' })
      HmCard() {
        this.getCardChildren()
      }
      HmCard() {
        this.getUpload()
      }
    }.height('100%').backgroundColor($r('app.color.background_page'))
  }
}

export default ExceptDetail