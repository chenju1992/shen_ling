import { TaskListData, TaskListParams, TaskDetailInfoModel } from '../models'
import { Request } from '../utils'

// 获取任务列表

export const getTaskList = (params: TaskListParams) => {
  return Request.get<TaskListData>("/tasks/list", params)
}


export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}