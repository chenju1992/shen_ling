import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs'
import util from '@ohos.util';
import request from '@ohos.request';
import { uploadImage } from '../api/upload';
import { ImageList } from '../models';
import { HmLoading } from '.';

@Component
struct HmUpload {

  title: string = ""
  loadingText: string = ""
  maxNumber : number = 3

  layer: CustomDialogController = new CustomDialogController({
    customStyle: true,
    alignment: DialogAlignment.Center,
    builder: HmLoading({ loadingText: '图片上传中' })
  })

  @ObjectLink
  upClass: HmUploadClass



  // 弹出相册选择器
  async selectImage() {
    let photoPicker = new picker.PhotoViewPicker();
    const result = await photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
      maxSelectNumber: this.maxNumber - this.upClass.images.length
    })
    if (result.photoUris?.length) {
      try {
        this.layer.open()
        // 循环处理
        let files: request.File[] = []
        const addFolderName = 'ju_chen'
        const defaultDir = getContext(this).cacheDir + '/' + addFolderName // 默认路径
        result.photoUris.forEach( async url => {
          const file = fs.openSync(url, fs.OpenMode.READ_ONLY) // 同步读取
          const tempFileName = util.generateRandomUUID() + '.jpg' // 生成一个唯一的文件名 后面有用
          if (!fs.listFileSync(getContext(this).cacheDir).includes(addFolderName)) {
            fs.mkdirSync(defaultDir)
          }
          const fileUri = defaultDir + '/' + tempFileName
          fs.copyFileSync(file.fd, fileUri) // 同步拷贝
          files.push({
            filename: tempFileName,
            name: 'file',
            uri: `internal://cache/${addFolderName}/${tempFileName}`,
            // 这里说明一下 internal协议会自动获取当前上下文协议的沙箱路径
            type: 'jpg'
          })
        })
        const  images =  await uploadImage(getContext(this),files)
        const urls = await uploadImage(getContext(this), files)
        AlertDialog.show({
          message: JSON.stringify(urls)
        })
        AlertDialog.show({
          message: JSON.stringify(files)
        })

      } catch (error) {
        AlertDialog.show({
          message: error.message
        })
      }finally{
        this.layer.close()
      }

    }
  }

  build() {
    Column() {
      Text(this.title).fontSize(14).fontColor($r("app.color.text_secondary")).margin({
        top: 16,
        bottom: 16
      })
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.upClass.images, (item: ImageList, index: number) => {
          Stack({ alignContent: Alignment.TopEnd }) {
            Image(item.url)
              .width(95)
              .height(95)
              .borderRadius(4)
            Image($r('app.media.ic_btn_delete')).width(30).height(30)
              .onClick(() => {
                this.upClass.images = this.upClass.images.filter((_,i) => i !== index)
              })
          }.margin({ right: 15, bottom: 10 })
        })
        if(this.maxNumber > this.upClass.images.length) {
          Row() {
            Image($r("app.media.ic_add_img")).width(30).height(30)
          }
          .width(95)
          .height(95)
          .backgroundColor('#F2F2F2')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.selectImage()
          })
        }
      }

    }.alignItems(HorizontalAlign.Start).width('100%')
  }
}


@Observed
class HmUploadClass {
  images: ImageList[] = []
}

export { HmUpload,HmUploadClass }