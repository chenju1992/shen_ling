@Preview
@CustomDialog
@Component
struct HmSelectCard {

  title: string = "请选择" // 显示标题
  showClose: boolean = true // 显示关闭按钮
  showButton: boolean = true // 显示底部按钮
  buttonText: string = "确定" // 底部按钮文本
  confirm: () => void = () => {}
  @BuilderParam
  cardContent: () => void

  controller: CustomDialogController
  build() {
    Column() {
      Row() {
        Text("请选择").fontSize(16).fontColor($r('app.color.text_primary'))
        Image($r("app.media.ic_btn_close")).width(13).height(13)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(60)
      .borderRadius({
        topLeft: 16,
        topRight: 16
      })
      // 渲染内容
      if(this.cardContent){
        this.cardContent()
      }

      if(this.showButton){
        Row() {
          Button('确定', { type: ButtonType.Capsule }).width(200).backgroundColor($r('app.color.primary')).height(45)
        }.width('100%').justifyContent(FlexAlign.Center).height(45).onClick(
          ()=>{this.confirm()}
        )
      }

    }.backgroundColor($r('app.color.white')).justifyContent(FlexAlign.SpaceBetween).padding({
      left: 21.36,
      right: 21.36
    })
  }
}

export { HmSelectCard }