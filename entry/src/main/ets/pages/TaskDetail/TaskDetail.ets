import { HmNavBar } from '../../components'
@Entry
@Component
struct TaskDetail {
  build() {
    Column() {
      HmNavBar({ title: '任务详情' })
    }.backgroundColor($r('app.color.background_page')).
    height('100%')
  }
}