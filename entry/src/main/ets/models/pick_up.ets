import { ImageList } from './common'
export interface PickUpParams {
  /** 提货凭证照片数组 */
  cargoPickUpPictureList: ImageList[];
  /** 提货照片数组 */
  cargoPictureList: ImageList[];
  /** 司机作业id */
  id: string;
}


export class PickUpParamsModel implements PickUpParams {
  cargoPickUpPictureList: ImageList[] = []
  cargoPictureList: ImageList[] = []
  id: string = ''

  constructor(model: PickUpParams) {
    this.cargoPickUpPictureList = model.cargoPickUpPictureList
    this.cargoPictureList = model.cargoPictureList
    this.id = model.id
  }
}
