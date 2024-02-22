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
export * from './delay'
export * from './location'
export * from './message'
export * from './car'

export class ResponseData<T> {
  code: number = 0
  msg: string = ""
  data: T | null = null // 这里应该必须只能这么声明！！！！
}