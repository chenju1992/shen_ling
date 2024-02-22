import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { UserSettingClass } from '../utils/settings';
import promptAction from '@ohos.promptAction';

export default class EntryAbility extends UIAbility {
  async onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    let manager = abilityAccessCtrl.createAtManager()
    try {
      await manager.requestPermissionsFromUser(this.context,
        [
          'ohos.permission.MEDIA_LOCATION',
          'ohos.permission.LOCATION',
          'ohos.permission.APPROXIMATELY_LOCATION',
        ])
    } catch (err) {
      promptAction.showToast({ message: '获取位置失败' })
    }
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    const userSetting = new UserSettingClass(this.context)
    const advertisementSetting = await userSetting.getUserAdvertisement()
    this.publishMessage(userSetting)

    if(advertisementSetting.isShowId){
      windowStage.loadContent('pages/Start/Start')
    }else{
      const token = await userSetting.getUserToken()
      if(token){
        windowStage.loadContent('pages/Index/Index')
      }else{
        windowStage.loadContent('pages/Login/Login')
      }
    }



    // windowStage.loadContent('pages/Index', (err, data) => {
    //   if (err.code) {
    //     hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
    //     return;
    //   }
    //   hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    // });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  async publishMessage(setting: UserSettingClass) {
    setTimeout(async () => {
      if (await setting.getUserToken()) {
        const want = await wantAgent.getWantAgent({
          wants: [
            {
              bundleName: 'com.itheima.myapplication',
              abilityName: 'ListenAbility',
              parameters: {
                order_id: Date.now()
              }
            }
          ],
          operationType: wantAgent.OperationType.START_ABILITY,
          wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG],
          requestCode: 0
        })
        const notifyId = Date.now()
        AppStorage.SetOrCreate<number>("notifyId", notifyId)
        const request: notificationManager.NotificationRequest = {
          id: notifyId,
          content: {
            contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: "温馨提示",
              text: "您有一个新的订单提醒",
              additionalText: "物流提醒"
            },
          },
          wantAgent: want
        }
        notificationManager.publish(request)
        AVPlayerClass.playAudio("information.mp3", this.context) // 播放通知信息
      }
    }, 10000)

  }
}
