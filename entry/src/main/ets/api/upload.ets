import request from '@ohos.request'
import { BASE_URL, TOKEN_KEY } from '../constants'

export const uploadImage =  async (context: Context, files: request.File[]) => {
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
  try {
    const UploadTask = await request.uploadFile(context, config)
    UploadTask.on('fail', (state) => {
      AlertDialog.show({
        message: '图片上传失败'
      })
    })
    UploadTask.on('complete', () => {
      AlertDialog.show({
        message: '图片上传完成'
      })
    })
  }catch(error) {
    AlertDialog.show({
      message: error.message
    })
  }
}