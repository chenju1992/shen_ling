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
}
