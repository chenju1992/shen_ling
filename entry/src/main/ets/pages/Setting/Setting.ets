import router from '@ohos.router'
import { HmCard, HmCardItem } from '../../components'

@Entry
@Component
struct Setting {

  build() {
    Column() {
      HmCard() {
        HmCardItem({ leftTitle: '换绑手机', rightText: '' })
        HmCardItem({ leftTitle: '修改密码', rightText: '' })
        HmCardItem({ leftTitle: '消息通知设置', rightText: '' })
        HmCardItem({ leftTitle: '清理缓存', rightText: '', showBottomBorder: false })
        HmCardItem({ leftTitle: '系统设置', rightText: '', onRightClick: () => {
          router.pushUrl({
            url: 'pages/Setting/Setting'
          })
        }})
      }
      Row() {
        Button("退出", { type: ButtonType.Normal })
          .backgroundColor($r('app.color.white'))
          .fontColor($r("app.color.text_primary"))
          .width('100%')
          .borderRadius(8)
          .height(60)
      }.width('100%').margin({
        top: 20
      }).padding({
        left: 15,
        right: 15
      })
      .justifyContent(FlexAlign.Center)
    }.width('100%')
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}