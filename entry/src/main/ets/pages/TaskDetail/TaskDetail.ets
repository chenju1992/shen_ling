import { HmNavBar } from '../../components'
import router from '@ohos.router'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
import { getTaskDetail } from '../../api'

@Entry
@Component
struct TaskDetail {
  @State
  taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
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
    Column() {
      HmNavBar({ title: '任务详情' })
      Text(JSON.stringify(this.taskDetailData))
    }.backgroundColor($r('app.color.background_page')).
    height('100%')
  }
}