export * from './AdvertisementClass'
export * from './user'
export * from './tab'
export * from './task'
export * from  './router'
export * from './task_detail'
export * from './pick_up'
export * from './common'
export * from './deliver'
export * from './car_record'

export class ResponseData<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null // 这里应该必须只能这么声明！！！！
}