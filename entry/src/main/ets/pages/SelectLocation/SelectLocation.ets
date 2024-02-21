import router from '@ohos.router'
import { HmNavBar, HmCard, HmCardItem } from '../../components'

@Entry
@Component
struct SelectLocation {
  build() {
    Column() {
      HmNavBar({ title: '当前位置' })
      //  地图区域
      Text("地图")
      Column() {
        HmCard() {
          HmCardItem({ leftTitle: '回龙观街道', rightText: '100m以内' })
          HmCardItem({ leftTitle: '金燕龙科研楼', rightText: '100m以内' })
          HmCardItem({ leftTitle: '春野画室', rightText: '100m以内' })
          HmCardItem({ leftTitle: '光滑时代(金艳龙科研楼店)', rightText: '100m以内' })
          HmCardItem({ leftTitle: '上报位置', rightText:  '请选择', onRightClick: () => {
            router.pushUrl({
              url: 'pages/SelectLocation/SelectLocation'
            })
          }})
        }
      }.position({
        y: '100%'
      }).translate({
        y: -260
      })

    }
    .height('100%').backgroundColor($r('app.color.background_page'))
  }
}