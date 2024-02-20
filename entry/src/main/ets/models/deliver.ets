import { ImageList } from './common'
export interface DeliverParamsType {
  /** 交付凭证列表 */
  certificatePictureList: ImageList[];
  /** 交付图片列表 */
  deliverPictureList: ImageList[];
  /** 司机作业id */
  id: string;
}
export class DeliverParamsTypeModel implements DeliverParamsType {
  certificatePictureList: ImageList[] = []
  deliverPictureList: ImageList[] = []
  id: string = ''

  constructor(model: DeliverParamsType) {
    this.certificatePictureList = model.certificatePictureList
    this.deliverPictureList = model.deliverPictureList
    this.id = model.id
  }
}
