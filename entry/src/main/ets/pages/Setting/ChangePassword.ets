import { HmNavBar } from '../../components'
import router from '@ohos.router';

// 输入框通用样式
@Extend(TextInput) function inputStyle() {
  .backgroundColor($r('app.color.white')).height(36).borderRadius(0)
}

// 线通用样式
@Extend(Line) function lineStyle() {
  .width('100%').height(1).backgroundColor($r('app.color.background_page')).margin({ top: 8, bottom: 8 })
}


@Entry
@Component
struct ChangePassword {
  // 倒计时秒数
  @State timeSeconds: number = 60

  build() {
    Column() {
      // 导航条
      HmNavBar({ title: '修改密码' })

      Column() {
        // 手机号
        TextInput({ placeholder: '请输入已绑定手机号' }).inputStyle().width('100%').margin({ top: 15 })
        Line().lineStyle()

        Row() {
          // 验证码
          TextInput({ placeholder: '请输入验证码' }).inputStyle().layoutWeight(1).border({
            width: { right: 1 }, color: $r('app.color.background_page')
          })

          // 倒计时容器
          Column() {
            if (this.timeSeconds === 60) {
              Button('获取验证码').backgroundColor(Color.Transparent).fontColor($r('app.color.text_secondary'))
            }
            else {
              Text(`${this.timeSeconds}s后重新获取`).fontColor($r('app.color.text_secondary'))
            }
          }.width(130)
        }

        Line().lineStyle()

        TextInput({ placeholder: '请输入新密码' }).inputStyle().width('100%')
        Line().lineStyle()

        // 下一步按钮
        Button('确认修改')
          .height(50)
          .width('100%')
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .margin({ top: 50 })
          .onClick(() => {
            router.pushUrl({
              url: 'page/Setting/BindMobile'
            })
          })
      }.width('100%').height('100%').padding({ left: 28, right: 28 })

    }.width('100%').height('100%').backgroundColor($r('app.color.white'))
  }
}