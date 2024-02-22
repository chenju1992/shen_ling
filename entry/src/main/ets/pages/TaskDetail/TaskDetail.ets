import { HmLoading, HmNavBar , HmToggleCard, HmUpload, HmUploadClass} from '../../components'
import router from '@ohos.router'
import { CommonRouterParams, DeliverParamsTypeModel, PickUpParamsModel, TaskDetailInfo, TaskDetailInfoModel, TaskTypeEnum } from '../../models'
import { deliver, getTaskDetail, pickUp } from '../../api'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct TaskDetail {

  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)

  @State @Watch('updateCargoPickUp') cargoPickUpClass: HmUploadClass = new HmUploadClass() // 提货凭证

  @State @Watch('updateCargo') cargoClass: HmUploadClass = new HmUploadClass() // 提货图片

  @State
  @Watch('updateDeliverPics')
  deliverClass: HmUploadClass = new HmUploadClass() // 交货照片
  @State
  @Watch('updateCertificatePics')
  certificateClass: HmUploadClass = new HmUploadClass() // 交货回单




  scroller: Scroller = new Scroller() // 滚动

  layer: CustomDialogController = new CustomDialogController({
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmLoading({ loadingText: '详情加载中' })
  })

  updateCargoPickUp () {
    this.taskDetailData.cargoPickUpPictureList = this.cargoPickUpClass.images
  }
  updateCargo() {
    this.taskDetailData.cargoPictureList = this.cargoClass.images
  }
  updateDeliverPics () {
    this.taskDetailData.deliverPictureList = this.deliverClass.images
  }
  updateCertificatePics() {
    this.taskDetailData.certificatePictureList = this.certificateClass.images
  }

  // 获取提货状态
  getPickUpState () {
    return this.taskDetailData.cargoPickUpPictureList?.length > 0 &&
    this.taskDetailData.cargoPictureList?.length > 0
    && this.taskDetailData.cargoPickUpPictureList.every(item => !!item.url)
    && this.taskDetailData.cargoPictureList.every(item => !!item.url)
  }



  async getTaskDetail(id: string) {
    this.layer.open()
    this.taskDetailData = await getTaskDetail(id)
    // 赋值提货数据
    this.cargoPickUpClass.images = this.taskDetailData.cargoPickUpPictureList || []
    this.cargoClass.images = this.taskDetailData.cargoPictureList || []

    this.certificateClass.images = this.taskDetailData.certificatePictureList || []
    this.deliverClass.images = this.taskDetailData.deliverPictureList || []

    this.layer.close()
  }

  // 提货
  async btnPickUp () {
    await pickUp(new PickUpParamsModel({
      id: this.taskDetailData.id,
      cargoPickUpPictureList: this.taskDetailData.cargoPickUpPictureList,
      cargoPictureList: this.taskDetailData.cargoPictureList
    }))
    promptAction.showToast({
      message: '提货成功',
      duration: 3000
    })
    this.getTaskDetail(this.taskDetailData.id) // 重新加载数据
  }

  // 获取交货状态
  getDeliverState () {
    return this.taskDetailData.deliverPictureList?.length > 0 &&
    this.taskDetailData.certificatePictureList?.length > 0
    && this.taskDetailData.deliverPictureList.every(item => !!item.url)
    && this.taskDetailData.certificatePictureList.every(item => !!item.url)
  }

  // 交货
  async btnDeliver () {
    await deliver(new DeliverParamsTypeModel({
      id: this.taskDetailData.id,
      certificatePictureList: this.taskDetailData.certificatePictureList,
      deliverPictureList: this.taskDetailData.deliverPictureList
    }))
    promptAction.showToast({
      message: '交货成功'
    })
    this.getTaskDetail(this.taskDetailData.id) // 重新加载数据
  }



  @Builder
  getBaseContentItem(item: BaseBuilderClass) {
    Row() {
      Text(item.title).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Row() {
        Text(item.value).fontSize(14).fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon).width(24).height(24)
        }
      }
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }
  // 获取基础信息
  @Builder
  getBaseContent() {
    Row() {
      Column() {
        Row() {
          Text("起").baseTextOneStyle()
          Text("北京市昌平区回龙观街道西三旗桥东金燕龙写字楼8877号").baseTextTwoStyle()
        }.margin({ top: 21 })
        Row() {
          Text("止").baseTextOneStyle().backgroundColor($r('app.color.primary'))
          Text("河南省郑州市路北区北清路99号").baseTextTwoStyle()
        }.margin({ top: 14.5 })
      }.alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({
        right: 20
      })

      Column() {
        Image($r("app.media.ic_navigation")).width(22).height(22)
        Text("开始导航").fontSize(14).margin({ top: 10, bottom: 10 })
      }.justifyContent(FlexAlign.SpaceBetween)
      .margin({
        top: 20
      })

    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%')

    Divider().vertical(false).height(2).color($r('app.color.background_divider')).margin({ left: 8, right: 8, top: 21 })
    this.getBaseContentItem({
      title: '任务编号',
      value: '2132324324343434'
    })
    this.getBaseContentItem({
      title: '联系人',
      value: '2132324324343434'
    })
    this.getBaseContentItem({
      title: '联系电话',
      value: '2132324324343434',
      icon: $r('app.media.ic_phone')
    })
    this.getBaseContentItem({
      title: '提货时间',
      value: '2132324324343434'
    })
    this.getBaseContentItem({
      title: '预计送达时间',
      value: '2132324324343434'
    })

    this.getBaseContentItem({
      title: '任务编号',
      value:  this.taskDetailData.transportTaskId
    })
    this.getBaseContentItem({
      title: '联系人',
      value: this.taskDetailData.startHandoverName
    })
    this.getBaseContentItem({
      title: '联系电话',
      value: this.taskDetailData.startHandoverPhone,
      icon: $r('app.media.ic_phone')
    })
    this.getBaseContentItem({
      title: '提货时间',
      value: this.taskDetailData.planDepartureTime
    })
    this.getBaseContentItem({
      title: '预计送达时间',
      value: this.taskDetailData.planArrivalTime
    })
  }




  // 司机信息
  @Builder
  getDriverContent() {
    Row() {
      Text(`车牌号`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.taskDetailData.licensePlate).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })

    Row() {
      Text(`司机姓名`).fontSize(14).fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
      Text(this.taskDetailData.driverName).fontSize(14).fontColor($r('app.color.text_secondary'))
    }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({
      top: 14
    })
  }
  // 运输路线
  @Builder
  getTransLineContent() {
    Row() {
      Column() {
        Text(this.taskDetailData.startProvince).fontSize(16).fontColor($r('app.color.text_primary')).lineHeight(22).fontWeight(600)
        Text(this.taskDetailData.startCity).fontSize(14).lineHeight(22)
      }.width(50)

      Image($r("app.media.ic_right_arrow")).width(36).height(16)
      Column() {
        Text(this.taskDetailData.endProvince).fontSize(16).fontColor($r('app.color.text_primary')).lineHeight(22).fontWeight(600)
        Text(this.taskDetailData.endCity).fontSize(14).lineHeight(22)
      }.width(50)
    }.justifyContent(FlexAlign.SpaceBetween).alignItems(VerticalAlign.Center).width('100%').padding({
      left: 60,
      right: 60
    })
  }

  // 交货信息内容
  @Builder
  getDeliverContent() {
    HmUpload({
      title: '请拍照上传交货凭证', upClass: this.certificateClass,
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line
    })
    HmUpload({
      title: '请拍照上传交货货品照片', upClass: this.deliverClass,
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line
    })
  }

  // 获取异常信息
  @Builder
  getExceptionContent() {
    ForEach(this.taskDetailData.exceptionList, (item: ExceptionList) => {
      Row() {
        Column() {
          Row() {
            Text("上报时间").fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionTime).margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')

          Row() {
            Text("异常类型").fontSize(14).fontColor($r('app.color.text_primary'))
            Text(item.exceptionType).margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')

          Row() {
            Text("处理结果").fontSize(14).fontColor($r('app.color.text_primary'))
            Text("继续运输").margin({ left: 20 }).fontColor($r('app.color.text_secondary'))
          }.height(50).alignItems(VerticalAlign.Center).width('100%')
        }
        // 跳转到详情
        Image($r("app.media.ic_btn_more")).width(24).height(24)
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

    })
  }





  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if(params && params.id) {
      this.getTaskDetail(params.id)
    }
  }

  // 提货信息内容
  @Builder
  getPickUpContent() {
    HmUpload({
      title: '请拍照上传回单凭证', upClass: this.cargoPickUpClass,
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting
    })
    HmUpload({
      title: '请拍照上传货品照片', upClass: this.cargoClass,
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting
    })
  }

  // 底部按钮结构
  @Builder
  getBottomBtn() {
    //已完成不显示任何按钮
    Row() {
      if(this.taskDetailData.status === TaskTypeEnum.Waiting) {
        Button("延迟收货", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Delay/Delay',
              params: {
                id: this.taskDetailData.id,
                oldTime: this.taskDetailData.planDepartureTime
              }
            })
          })
        Button("提货", { type: ButtonType.Capsule })
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .margin({ left: 13 })
          .backgroundColor(this.getPickUpState() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .enabled(this.getPickUpState())
          .onClick(() => {
            this.btnPickUp()
          })
      }else if (this.taskDetailData.status === TaskTypeEnum.Line) {
        Button("上报异常", { type: ButtonType.Capsule })
          .backgroundColor($r('app.color.btn_gray'))
          .fontColor($r('app.color.text_primary'))
          .fontSize(16)
          .height(50)
          .width(125).onClick(() => {
          router.pushUrl({
            url: 'pages/Exception/ExceptionReport',
            params: {
              id: this.taskDetailData.transportTaskId
            }
          })
        })
        Button("交付", { type: ButtonType.Capsule })
          .backgroundColor(this.getDeliverState() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
          .fontColor($r('app.color.white'))
          .height(50)
          .flexGrow(1)
          .enabled(this.getDeliverState())
          .margin({ left: 13 }).onClick(() => {
          this.btnDeliver()
        })
      }

    }
    .width('100%')
    .padding({ left: 15, right: 15 })
    .height(70).
    justifyContent(FlexAlign.SpaceBetween).
    alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.white'))
    .position({ y: '100%' })
    .translate({ y: -70 })
  }







  build() {
    Column () {
      HmNavBar({ title: '任务详情' })
      Scroll(this.scroller) {
        Column() {
          HmToggleCard({ title: '基本信息' }) {
            this.getBaseContent()
          }
          HmToggleCard({ title: '车辆司机信息' }) {
            this.getDriverContent()
          }
          HmToggleCard({ title: '运输路线' }) {
            this.getTransLineContent()
          }
          if (this.taskDetailData.exceptionList?.length > 0) {
            HmToggleCard({ title: '异常信息' }) {
              this.getExceptionContent()
            }
          }
          // 提货时显示提货照片
          if(this.taskDetailData.status === TaskTypeEnum.Waiting || this.taskDetailData.status === TaskTypeEnum.Delivered) {
            HmToggleCard({ title: '提货信息' }) {
              this.getPickUpContent()
            }
          }
          // 交货时显示交货照片
          if(this.taskDetailData.status === TaskTypeEnum.Line || this.taskDetailData.status === TaskTypeEnum.Delivered) {
            HmToggleCard({ title: '交货信息' }) {
              this.getDeliverContent()
            }
          }
          else if(this.taskDetailData.status === TaskTypeEnum.Delivered) {
            Row() {
              // 已交付显示回车登记
              Button("回车登记", { type: ButtonType.Capsule })
                .backgroundColor($r('app.color.primary'))
                .fontColor($r('app.color.white'))
                .height(50)
                .width('80%')
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/CarRecord/CarRecord',
                    params: {
                      id: this.taskDetailData.id
                    }
                  })
                })
            }.width('100%').justifyContent(FlexAlign.Center)
          }



        }.padding({
          bottom: 120
        })
      }
      this.getBottomBtn()
    }.backgroundColor($r('app.color.background_page')).height('100%')
  }
}

@Extend(Text) function baseTextOneStyle() {
  .fontSize(12)
  .fontColor($r('app.color.white'))
  .backgroundColor($r('app.color.text_primary'))
  .width(22)
  .height(22)
  .borderRadius(11)
  .textAlign(TextAlign.Center)
}

@Extend(Text) function baseTextTwoStyle() {
  .margin({ left: 11.5 }).fontColor($r('app.color.text_secondary')).fontSize(14).lineHeight(20)
}



class BaseBuilderClass {
  title: string = ""
  value: string = ""
  icon?: ResourceStr = ""
}