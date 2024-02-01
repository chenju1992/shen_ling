export class AdvertisementClass{

  isShowId : boolean = false
  adTimeInSecond : number = 5
  advertisementURL? :string = ''
  advertisementImage : ResourceStr = ""

  constructor(isShowId:boolean, adTimeInSecond:number, advertisementImage:ResourceStr,advertisementURL?:string) {
    this.isShowId = isShowId
    this.adTimeInSecond = adTimeInSecond
    this.advertisementImage = advertisementImage
    this.advertisementURL = advertisementURL
  }
  
}