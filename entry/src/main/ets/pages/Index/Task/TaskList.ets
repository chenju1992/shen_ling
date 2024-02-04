import { getTaskList } from '../../../api/task'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'


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
  loading: boolean = false // 是否正在加载中

  allPage: number = 1 // 总页数先设置为1页 后续会更新

  aboutToAppear() {
    this.getTaskList()
  }

  build() {
    List() {
      ForEach(this.taskListData, (item) => {
        ListItem() {
          TaskItemCard({ taskItemData: item })
        }
        ListItem()
      })
    }.onReachEnd(async () => {
      if(this.allPage >= this.queryParams.page) {
        if(!this.loading) {
          this.loading = true
          await this.getTaskList(true)
          this.loading =  false
        }
      }
    })
  }

  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    this.taskListData = this.taskListData.concat(result.items) // 连接新的数组
    this.allPage = result.pages // 赋值总页数
    this.queryParams.page++ // 页码+1
  }

}
export default  TaskList
