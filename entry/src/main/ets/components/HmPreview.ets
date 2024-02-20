@CustomDialog
@Component
struct HmPreview {
  // 图片列表
  urls: string[] = []
  // 当前激活下标
  selectIndex: number = -1
  controller: CustomDialogController
  build() {
    Column() {
      Row() {
        Swiper() {
          ForEach(this.urls, (url: string) => {
            Row() {
              Image(url).width('100%').objectFit(ImageFit.Cover)
            }.height('100%')
          })
        }
        .index(this.selectIndex)
        .indicator(false)
        .loop(false)
      }.backgroundColor($r('app.color.black'))
      .onClick(() => this.controller.close())
    }.height('100%').position({ y: 0 }).zIndex(11)
  }
}

export { HmPreview }