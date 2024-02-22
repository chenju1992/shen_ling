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
  @State
  reset: boolean = false // 用于控制重置状态

  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading(),
    customStyle: true,
    autoCancel: false,
    alignment: DialogAlignment.Center
  })

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
  // 控制筛选按钮可点
  getSearchEnable() {
    return !!(this.queryParams.startTime && this.queryParams.endTime)
  }
  @Builder
  renderItem (item: object) {
    TaskItemCard({ taskItemData: item as TaskInfoItemModel })
  }

  @Builder
  getSearchForm() {
    Column() {
      Row() {
        Search({ placeholder: '请输入任务编号' }).backgroundColor($r('app.color.background_page')).height(32)
      }
      .justifyContent(FlexAlign.Center)
      .padding({ left: 15, right: 15, bottom: 5 })

      Row() {
        // 完成搜索页需要测试点击之后键盘和弹层同时弹出的情况
        Button(this.queryParams.startTime || '开始时间')
          .fontSize(14)
          .width(106)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
          .onClick(() => {
            DatePickerDialog.show({
              selected: new Date(),
              onAccept: (value: DatePickerResult) => {
                this.queryParams.startTime = `${value.year}-${this.addZero(value.month! + 1)}-${this.addZero(value.day)}`
              }
            })
          })

        Text("至")
        Button(this.queryParams.endTime || '结束时间')
          .fontSize(14)
          .width(110)
          .height(32)
          .padding({ left: 0, right: 0 })
          .fontColor('#999')
          .backgroundColor($r('app.color.background_page'))
          .onClick(() => {
            DatePickerDialog.show({
              selected: new Date(),
              onAccept: (value: DatePickerResult) => {
                this.queryParams.endTime = `${value.year}-${this.addZero(value.month! + 1)}-${this.addZero(value.day)}`
              }
            })
          })
        Button(this.reset ? "重置" : "筛选")
          .backgroundColor(this.getSearchEnable() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .height(32)
          .width(60)
          .enabled(this.getSearchEnable())
          .onClick(async() => {
            if(this.reset) {
              this.queryParams.startTime = ''
              this.queryParams.endTime = ''
              this.reset = false
            }else {
              this.reset = true
            }
            this.layer.open()
            this.allPage = 1
            this.queryParams.page = 1
            await this.getTaskList(false)
            this.layer.close()
          })
      }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor($r('app.color.white'))
    .padding(15)
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  // 日期补零
  addZero(value: number) {
    return value.toString().padStart(2,"0")
  }

  build() {
    Column() {
      if(this.queryParams.status === TaskTypeEnum.Finish) {
        this.getSearchForm()
      }
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
