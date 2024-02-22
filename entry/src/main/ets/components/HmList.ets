import { HmLoading } from './HmLoading'
import { ListDataSource } from '../models'
import vibrator from '@ohos.vibrator';
import { AVPlayerClass } from '../utils'

@Component
struct HmList {
  @State
  refreshIng: boolean = false // 控制下拉刷新
  @State
  loading: boolean = false // 控制上拉加载
  @State
  translateY: number = 0 // 列表偏移量
  @State
  refreshStatus: PullEnum = PullEnum.none
  @Prop
  finished: boolean // 是否结束
  @Link
  @Watch("updateDataSource")
  dataSource: object[] // 数据源
  @BuilderParam
  renderItem: (item: object) => void
  onLoad: () => void = () => {
  } // 上拉加载函数
  onRefresh: () => void = () => {
  } // 下拉刷新函数

  refreshLimit: number = 50 // 阈值
  startY: number = 0 // 实际偏移量

  loadingText: string = "加载数据中" // 加载中文本
  finishText: string = "没有内容啦" // 结束文本
  showLoadingIcon: boolean = true // 是否显示加载进度
  lazyDataSource: ListDataSource = new ListDataSource()
  // 更新数据
  updateDataSource() {
    this.lazyDataSource.reloadData(this.dataSource)
  }

  ease(distance: number) {
    const damp = 0.2 // 阻尼系数
    if (distance > this.refreshLimit) {
      return this.refreshLimit + (distance - this.refreshLimit) * damp
    }
    return distance
  }

  // 获取底部显示的文本
  @Builder
  getBottomDisplay() {
    Row({ space: 10 }) {
      if (this.finished) {
        Text(this.finishText)
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
      } else {
        if (this.loading) {
          Text(this.loadingText)
            .fontSize(14)
            .fontColor($r("app.color.text_secondary"))
          if(this.showLoadingIcon) {
            HmLoading({
              hWidth: 20
            })
          }
        }
      }
    }
    .height(50)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  getRefreshDisplay() {
    Row() {
      LoadingProgress().color($r('app.color.primary')).width(40).height(40).animation({
        duration: 100
      })
      Text(this.getRefreshText(this.refreshStatus))
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({
          left: 10
        })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
  }
  getRefreshText(status: PullEnum) {
    switch (status) {
      case PullEnum.none:
        return ""
      case PullEnum.show:
        return "继续下拉"
      case PullEnum.loading:
        return "松手加载"
      case PullEnum.waiting:
        return "加载中"
    }

  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.refreshStatus !== PullEnum.none) {
        this.getRefreshDisplay()
      }
      List() {
        LazyForEach(this.lazyDataSource, (item: object) => {
          ListItem() {
            if (this.renderItem) {
              this.renderItem(item)
            }
          }.width('100%')
        })
        ListItem() {
          this.getBottomDisplay()
        }
      }
      .translate({
        y: this.translateY // 记录偏移量
      })
      .onReachEnd(async () => {
        if (!this.finished && !this.loading) {
          this.loading = true
          await this.onLoad()
          this.loading = false
        }
      })
      .onTouch(async (event?: TouchEvent) => {
        if (!event) {
          return;
        }
        switch (event.type) {
          case TouchType.Down:
            this.startY = event.touches[0].y // 鼠标按下时 记录起始的y坐标
            break
          case TouchType.Move:
            const offset = this.ease(event.touches[0].y - this.startY) // 移动后的偏移量
            if(offset > 0) {
              // 只有大于0的情况下 才位移 否则不管
              this.translateY = this.ease(offset) // 设置阻尼
            }
          // 如果确认往下拉了 但是小于设定的阈值 状态为show
            if (this.translateY > 0 && this.translateY < this.refreshLimit) {
              this.refreshStatus = PullEnum.show;
            }
            // 如果超过阈值 就设置为加载状态
            else if (this.translateY > this.refreshLimit) {
              this.refreshStatus = PullEnum.loading;
            } else {
              // 否则就是往上拉了 往上拉是没有加载进度
              this.refreshStatus = PullEnum.none
            }
            break;
          case TouchType.Up:
          // 如果松手时 是加载状态 表示是去加载 就开始加载
            if (this.refreshStatus === PullEnum.loading) {
              // 将状态设置为等待 表示等待它加载完毕
              this.refreshStatus = PullEnum.waiting
              await this.onRefresh()
              vibrator.startVibration({ duration: 300, type: 'time' }, { id: 0, usage: 'touch' }) // 震动
              AVPlayerClass.playAudio("success.wav", getContext(this))
            }
          // 松手之后，一切应该恢复正常
          // 恢复正常
            animateTo({ duration: 300 }, () => {
              this.translateY = 0
              this.refreshStatus = PullEnum.none;
            })
            break;
          default:
            break;
        }
      })
    }
  }
}

// 加载的状态
export enum PullEnum {
  none = 0, // 正常状态
  show = 1, // 显示下拉状态
  loading = 2, // 下拉刷新中
  waiting = 3 // 等待下拉刷新完成
}

export { HmList }