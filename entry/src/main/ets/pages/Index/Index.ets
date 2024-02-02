import { TOKEN_KEY } from '../../constants'
import { TabClass } from '../../models'

PersistentStorage.PersistProp(TOKEN_KEY, "")

@Entry
@Component
struct Index {
  @State tabsData: TabClass[] = [{
    title: '任务',
    name: 'task',
    icon: $r("app.media.ic_tab_btn_task")
  },{
    title: '消息',
    name: 'message',
    icon: $r("app.media.ic_tab_btn_mess_nor")
  },{
    title: '我的',
    name: 'my',
    icon: $r("app.media.ic_tab_btn_mine_nor")
  }]

  build() {
    Tabs({ barPosition: BarPosition.End }){
      ForEach(this.tabsData, (item: TabClass) => {
        TabContent(){
          if(item.name === 'task') {
            Text("任务组件")
          }
          else if(item.name === 'message') {
            Text("消息组件")
          }
          else {
            Text("我的组件")
          }
        }.tabBar(this.getTabBar(item))
      })
    }
  }

  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Image(item.icon).width(22).height(22)
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
    }.alignItems(HorizontalAlign.Center)
  }

}