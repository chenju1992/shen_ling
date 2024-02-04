import { getTaskList } from '../../../api/task'
import { TaskInfoItem, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'

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

  aboutToAppear() {
    this.getTaskList()
  }
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    this.taskListData = result.items
  }
  build() {
    Text(JSON.stringify(this.taskListData))
  }
}
export default  TaskList
