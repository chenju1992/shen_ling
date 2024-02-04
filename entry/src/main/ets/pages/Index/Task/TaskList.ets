import { getTaskList } from '../../../api/task'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import TaskItemCard from './TaskItemCard'

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
    List () {
      ForEach(this.taskListData, (item: TaskInfoItemModel) => {
        ListItem(){
          TaskItemCard()
        }
      })
    }
  }
}
export default  TaskList
