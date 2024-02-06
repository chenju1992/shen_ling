import { HmNavBar , HmToggleCard} from '../../components'
import router from '@ohos.router'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
import { getTaskDetail } from '../../api'

@Entry
@Component
struct TaskDetail {
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  scroller: Scroller = new Scroller() // 滚动
  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      this.getTaskDetail(params.id)
    }
  }
  async getTaskDetail(id: string) {
    this.taskDetailData = await getTaskDetail(id)
  }

  build() {
    Column () {
      HmNavBar({ title: '任务详情' })
      Scroll(this.scroller) {
        Column() {
          HmToggleCard({ title: '基本信息' }) {
            Text(JSON.stringify(this.TaskDetailData))
          }
          HmToggleCard({ title: '基本信息' }) {
            Text(JSON.stringify(this.TaskDetailData))
          }
          HmToggleCard({ title: '基本信息' }) {
            Text(JSON.stringify(this.TaskDetailData))
          }
        }.padding({
          bottom: 120
        })
      }
    }.backgroundColor($r('app.color.background_page')).height('100%')
  }
}