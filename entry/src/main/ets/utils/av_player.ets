import media from '@ohos.multimedia.media';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';

export class AVPlayerDemo {
  private count: number = 0;
  private isSeek: boolean = true; // 用于区分模式是否支持seek操作
  private fileSize: number = -1;
  private fd: number = 0;
  // 注册avplayer回调函数
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    // seek操作结果回调函数
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    })
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('AVPlayer state idle called.');
          avPlayer.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('AVPlayer state initialized called.');
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.');
          avPlayer.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('AVPlayer state playing called.');
          if (this.count !== 0) {
            if (this.isSeek) {
              console.info('AVPlayer start to seek.');
              avPlayer.seek(avPlayer.duration); //seek到音频末尾
            } else {
              // 当播放模式不支持seek操作时继续播放到结尾
              console.info('AVPlayer wait to play end.');
            }
          } else {
            avPlayer.pause(); // 调用暂停接口暂停播放
          }
          this.count++;
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.');
          avPlayer.play(); // 再次播放接口开始播放
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.');
          avPlayer.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    })
  }
  // 以下demo为使用资源管理接口获取打包在HAP内的媒体资源文件并通过fdSrc属性进行播放示例
  async avPlayerFdSrcDemo() {
    // 创建avPlayer实例对象
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数
    this.setAVPlayerCallback(avPlayer);
    // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址
    // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度
    let context = getContext(this) as common.UIAbilityContext;
    let fileDescriptor = await context.resourceManager.getRawFd('01.mp3');
    let avFileDescriptor: media.AVFileDescriptor =
      { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    this.isSeek = true; // 支持seek操作
    // 为fdSrc赋值触发initialized状态机上报
    avPlayer.fdSrc = avFileDescriptor;
  }

}
// 单例的播放类
export class AVPlayerClass {
  static avPlayer: media.AVPlayer | null = null // 初始值
  static audioName: string = "" // 存储当前的音频的名称
  static isSettingBack: boolean = false // 是否设置过回调  因为针对某一个avplayer只能设置一次回调
  // 提供一个静态方法 播放音乐
  static  async playAudio (audioName: string, context: Context) {
    if(!AVPlayerClass.avPlayer) {
      // 需要创建一个播放器
      AVPlayerClass.avPlayer = await media.createAVPlayer()
    }
    // 如果audio有值
    if(audioName) {
      // 将这个值对应的音频文件读取过来赋值给avplayer的fdSrc
      AVPlayerClass.audioName = audioName
      AVPlayerClass.setAvPlayerAudio(context)
    }

  }
  // 注册avplayer回调函数
  static setAVPlayerCallback() {
    // seek操作结果回调函数
    AVPlayerClass.avPlayer.on('seekDone', (seekDoneTime: number) => {
      //  console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
      AVPlayerClass.avPlayer!.play() // 回到零秒后 才播放
    })
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    // 状态机变化回调函数
    AVPlayerClass.avPlayer!.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
      // case 'idle': // 成功调用reset接口后触发该状态机上报
      //   console.info('AVPlayer state idle called.');
      //   AVPlayerClass.avPlayer.release(); // 调用release接口销毁实例对象
      //   break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('AVPlayer state initialized called.');
          AVPlayerClass.avPlayer!.prepare();  // 准备播放
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.');
          AVPlayerClass.avPlayer!.seek(0); // 调用播放接口开始播放 // 将音频的播放进度挪到0的位置
          break;
        case 'playing': // play成功调用后触发该状态机上报
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.');
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.');
          AVPlayerClass.avPlayer!.reset() // 重置
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.');
          break;
        case 'released':
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    })
  }
  static  async setAvPlayerAudio (context: Context) {
    // AVPlayerClass.audioName
    let fileDescriptor = await context.resourceManager.getRawFd(AVPlayerClass.audioName)
    let avFileDescriptor: media.AVFileDescriptor =
      { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    if(!AVPlayerClass.isSettingBack) {
      // 设置回调 回调只能设置一次
      AVPlayerClass.setAVPlayerCallback()
    }
    if(AVPlayerClass.avPlayer) {
      // 拿到了资源 赋值给播放器的src属性  会走回调
      AVPlayerClass.avPlayer.fdSrc = avFileDescriptor;
    }

  }
}