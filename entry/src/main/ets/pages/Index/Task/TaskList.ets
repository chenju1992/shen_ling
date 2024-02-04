import { getTaskList } from '../../../api/task'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'
import { HmLoading } from '../../../components'
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
  allPage: number = 1 // 总页数先设置为1页 后续会更新

  @State
  loading: boolean = false // 是否正在加载中

  @State
  refreshing: boolean = false

  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    if(append) {
      this.taskListData = this.taskListData.concat(result.items) // 连接新的数组
    }else {
      this.taskListData = result.items
    }
    this.allPage = result.pages // 赋值总页数
    this.queryParams.page++ // 页码+1

  }
  // 获取底部显示的文本
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.loading) {
        Text(this.allPage < this.queryParams.page ? "已经没有内容拉" : "加载数据中")
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        if(this.allPage >= this.queryParams.page) {
          HmLoading({
            hWidth: 20
          })
        }
      }
    }
    .height(50)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
  async onRefresh () {
    this.allPage = 1
    this.queryParams.page = 1
    await this.getTaskList(false)
    this.loading = false // 这行代码必须加- 因为要考虑已经滑到底部的情况，此时loading 为true 如果不开放这个状态 无法进行上拉加载
    this.refreshing = false // 关闭下拉状态
    promptAction.showToast({
      message: '刷新成功'
    })
  }

  build() {
    Refresh({ refreshing: $$this.refreshing }) {
      List() {
        ForEach(this.taskListData, (item: TaskInfoItemModel) => {
          ListItem() {
            TaskItemCard({ taskItemData: item })
          }
        })
        ListItem () {
          this.getBottomDisplay() // 底部显示内容
        }
      }
      .onReachEnd(async () => {
        if(this.allPage >= this.queryParams.page) {
          if(!this.loading) {
            this.loading = true
            await this.getTaskList(true)
            this.loading = this.allPage < this.queryParams.page ? true : false
          }
        }
      })
    }
    .onStateChange((value: RefreshStatus) => {
      if(value === RefreshStatus.Refresh) {
        this.onRefresh()
      }
    })

  }
}

export default TaskList
