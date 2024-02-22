import { HmNavBar } from '../../components'
import router from '@ohos.router';

@Entry
@Component
struct MessageSend {
  build() {

    Flex({ direction: FlexDirection.Column }) {
      // 导航条
      HmNavBar({ title: '消息通知设置' })

      // 消息通知
      Text('开启后，有新的任务通知你').margin({ top: 24, left: 20, bottom: 12 }).fontColor($r('app.color.text_secondary'))

      // 切换的 Toggle 框
      Row() {
        Text('允许给我推送任务通知')
        Toggle({ type: ToggleType.Switch, isOn: false }).selectedColor($r('app.color.primary')).width(60).height(36)
      }
      .width('100%')
      .height(60)
      .backgroundColor($r('app.color.white'))
      .padding({ left: 20, right: 10 })
      .justifyContent(FlexAlign.SpaceBetween)

    }.width('100%').height('100%').backgroundColor($r('app.color.background_page'))
  }
}
