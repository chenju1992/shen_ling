import { TOKEN_KEY } from '../../constants'
import { UserSettingClass } from '../../utils/settings'

PersistentStorage.PersistProp(TOKEN_KEY, "")


@Entry
@Component
struct Login {
  @State message: string = '登录页'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button("登录")
          .onClick(() => {
            AppStorage.Set<string>(TOKEN_KEY, '12345') // 写入本地缓存
            new UserSettingClass(getContext(this)).setUserToken('12345') // 写入首选项
            // 这里的this不给也可以-因为当前处于UIContext中，系统会自动分配Context
          })
      }
      .width('100%')
    }
    .height('100%')

  }
}