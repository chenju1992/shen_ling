import request from '@ohos.request'
import { BASE_URL, TOKEN_KEY } from '../constants'
import promptAction from '@ohos.promptAction'
import { Request as RequestClass } from '../utils'
import { ImageList, ImageListModel } from '../models'

export const uploadImage = async (context: Context, files: request.File[]) => {
  const config: request.UploadConfig = {
    url: `${BASE_URL}/files/imageUpload`,
    method: 'POST',
    header: {
      'Accept': '*/*',
      'Authorization': `${AppStorage.Get(TOKEN_KEY)}`,
      'Content-Type': 'multipart/form-data'
    },
    files,
    data: []
  }
  return new Promise<ImageList[]>(async (resolve, reject) => {
    try {
      const UploadTask = await request.uploadFile(context, config)
      UploadTask.on('fail', (state) => {
        promptAction.showToast({
          message: '上传失败'
        })
        reject(new Error("图片上传失败"))
      })
      UploadTask.on('complete', async (data) => {
        const result = await Promise.all<string>(files.map(item => RequestClass.get<string>("/files/imageUrl", {
          imageName: item.filename.slice(0, item.filename.indexOf('.'))
        } as FileParams)))
        resolve(result.map(url => new ImageListModel({ url })))
      })
    } catch (error) {
      AlertDialog.show({
        message: error.message
      })
    }
  })

}

class FileParams {
  imageName: string = ""
}