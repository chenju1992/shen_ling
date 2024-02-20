import { getTaskList } from '../../../api/task'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'
import { HmLoading, HmList } from '../../../components'
import promptAction from '@ohos.promptAction'

@Preview
@Component
struct TaskList {
  @State
  queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5,

  } as TaskListParams)
  @State
  taskListData: TaskInfoItem[] = []
  @State
  allPage: number = 1 // 总页数先设置为1页 后续会更新
  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    if(append) {
      this.taskListData = this.taskListData.concat(result.items || []) // 连接新的数组
    }else {
      this.taskListData = result.items || []
    }
    this.allPage = result.pages // 赋值总页数
    this.queryParams.page++ // 页码+1
  }

  async onRefresh () {
    this.allPage = 1
    this.queryParams.page = 1
    await this.getTaskList(false)
    promptAction.showToast({
      message: '刷新成功'
    })
  }
  @Builder
  renderItem (item: object) {
    TaskItemCard({ taskItemData: item as TaskInfoItemModel })
  }

  build() {
    Column() {
      HmList({
        onLoad: async () => {
          await this.getTaskList(true)
        },
        onRefresh: async () => {
          await this.onRefresh()
        },
        dataSource: $taskListData,
        renderItem: this.renderItem,
        finished: this.allPage < this.queryParams.page,
        finishText: '没啦没啦',
        loadingText: '拼命加载中'
      })
    }.height('100%')
  }

}

export default TaskList
