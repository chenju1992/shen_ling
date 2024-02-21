import { TaskListData, TaskListParams, TaskDetailInfoModel, DeliverParamsTypeModel, CarRecordTypeModel, DelayParamsTypeModel } from '../models'
import { Request } from '../utils'
import { PickUpParamsModel } from '../models'
import { ExceptionParamsTypeModel } from '../models/Exception'


// 获取任务列表

export const getTaskList = (params: TaskListParams) => {
  return Request.get<TaskListData>("/tasks/list", params)
}


export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}

// 提货
export const pickUp = (data: PickUpParamsModel) => {
  return Request.post<null>("/tasks/takeDelivery", data)
}

// 交货
export const deliver = (data: DeliverParamsTypeModel) => {
  return Request.post<null>("/tasks/deliver", data)
}

//回车登记
export const carRecord = (data: CarRecordTypeModel) => {
  return Request.post<null>("/tasks/truckRegistration", data)
}

// 延迟收货
export const delay = (data: DelayParamsTypeModel) => {
  return Request.put<null>("/tasks/delay", data)
}

// 上报异常
export const exception = (data: ExceptionParamsTypeModel) => {
  return Request.post<null>("/tasks/reportException", data)
}