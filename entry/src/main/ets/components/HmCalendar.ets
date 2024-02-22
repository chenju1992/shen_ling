import DayJs from 'dayjs'

class DayItem {
  public date: number = 0
  public month: number = 0
  public year: number = 0
  public isSelected?: boolean = true
}
class DateResult {
  year: string = ""
  month: string = ""
}
@Component
struct HmCalendar {
  @Prop
  @Watch('onCurrentDateUpdate')
  currentDate: string
  @State
  days: DayItem[] = []
  onClickItem: (date: string) => void = () => {}
  onChangeMonth: (item : DateResult) => void = () => {}
  // 内部属性
  private weeks: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
  private format: string = 'YYYY-MM-DD'

  onCurrentDateUpdate() {
    this.days = this.getDays(this.currentDate)
  }
  aboutToAppear() {
    this.days = this.getDays(this.currentDate)
  }
  // 获取每月天数 保证六行 每行7天
  getDays(originDate?: string) {
    const date = originDate ? DayJs(originDate) : DayJs()
    const days: DayItem[] = []
    const len = 42

    // 当前月
    const currDays = date.daysInMonth()
    for (let index = 1; index <= currDays; index++) {
      days.push({
        date: index,
        month: date.month() + 1,
        year: date.year(),
        isSelected: date.year() === new Date().getFullYear() && date.month() === new Date().getMonth() &&
        index === new Date().getDate()
      })
    }
    // 上个月
    const prevMonth = date.date(0)
    const prevMonthLastDate = prevMonth.date()
    const prevDays = prevMonth.day()
    if (prevDays < 6) {
      for (let index = 0; index <= prevDays; index++) {
        days.unshift({
          date: prevMonthLastDate - index,
          month: prevMonth.month() + 1,
          year: prevMonth.year()
        })
      }
    }
    // 下个月
    const nextMonth = date.date(currDays + 1)
    const start = days.length
    for (let index = 1; index <= len - start; index++) {
      days.push({
        date: index,
        month: nextMonth.month() + 1,
        year: nextMonth.year()
      })
    }

    return days
  }
  // 是否在当月
  isTheMonth(month: number) {
    return DayJs(this.currentDate).month() === month - 1
  }

  build() {
    Column() {
      Row() {
        // 上个月
        Column() {
          Image($r('app.media.ic_date_left')).width(30).height(30).rotate({ angle: 180 })
        }
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentDate = DayJs(this.currentDate).subtract(1, 'month').format(this.format)
          this.onChangeMonth && this.onChangeMonth({
            year: DayJs(this.currentDate).year() +"",
            month:  DayJs(this.currentDate).month() + 1 + ""
          })
        })

        Text(DayJs(this.currentDate).format('YYYY年MM月'))
          .fontColor($r('app.color.text_primary'))
          .margin({ right: 20, left: 20 })
          .width(110)
          .textAlign(TextAlign.Center)
          .fontSize(18)
        // 下个月
        Column() {
          Image($r('app.media.ic_date_right')).width(30).height(30)
        }
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentDate = DayJs(this.currentDate).add(1, 'month').format(this.format)
          this.onChangeMonth && this.onChangeMonth({
            year: DayJs(this.currentDate).year() +"",
            month:  DayJs(this.currentDate).month() + 1 + ""
          })
        })
      }
      .padding(15)

      GridRow({ columns: 7 }) {
        ForEach(this.weeks, (item) => {
          GridCol() {
            Column() {
              Text(item)
                .fontColor($r('app.color.text_secondary')).fontSize(12)
            }
          }.height(40)
        })
        ForEach(this.days, (item: DayItem) => {
          GridCol() {
            Column() {
              Text(item.date.toString())
                .width(32)
                .height(32)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .backgroundColor(item.isSelected ? $r('app.color.primary') : $r('app.color.white'))
                .borderRadius(item.isSelected ? 16 : 0)
                .fontColor(item.isSelected ? $r('app.color.white') : (this.isTheMonth(item.month) ? $r('app.color.text_primary') : $r('app.color.text_secondary')))

            }.onClick(() => {
              const date = `${item.year}-${item.month.toString().padStart(2, '0')}-${item.date.toString()
                .padStart(2, '0')}`
              this.onClickItem && this.onClickItem(date)
            })
          }.height(48)
        })
      }
      .padding({ top: 15 })
      .border({ width: { top: 0.5 }, color: '#f6f7f9' })
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
  }
}

export { HmCalendar }