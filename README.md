# Flutter Umeng Plugin
Language:  | [中文简体](https://gitee.com/sanrixue/UMeng/blob/master/umeng_plugin/README.md)

> 一个基于友盟IOS/Android 开发的一款分享 埋点插件 

## 分享支持平台
> 微信 微信朋友圈 QQ 微博 

## 分享配置

- 友盟平台
```dart
  注册应用信息 得到 
  UMkey
```
- 第三方开放平台
```dart
  登录所需的第三方开放平台,添加各自的应用信息得到
   wxAppKey 
   wxAppSecret
```
- IOS配置 
```dart
  在Xcode端 添加URL Types
```
- 友盟share配置问题
  - https://developer.umeng.com/docs/66632/detail/66825



## 版本更新历史
> 按时间顺序,展示重要的提交更新内容。


## 运行方式

- 查看一下版本号是否正确
```dart
  flutter --version
```
- 运行以下命令查看是否需要安装其它依赖项来完成安装
```dart
  flutter doctor
```
- 运行启动您的应用
```dart
  flutter packages get 
  flutter run
```

- 如果有其他问题,请参考
  - https://flutterchina.club/setup-macos/
  - https://flutter.dev/docs/get-started/install/macos

## Usage
  - 分享 
```dart
  平台调用支持
  iOS
  UmengPlugin.shareText(shareString: "分享测试数据");
  UmengPlugin.shareImage(shareImage: "https://mobile.umeng.com/images/pic/home/social/img-1.png");
  UmengPlugin.shareImageText(shareText: "分享文字",shareImage: "https://mobile.umeng.com/images/pic/home/social/img-1.png");
  UmengPlugin.shareWeb(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',webUrl: 'www.baidu.com' );
  UmengPlugin.shareMusic(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',musicUrl: 'http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect');
  UmengPlugin.shareVideo(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',videoUrl: 'http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html');
  
  android 
  UmengPlugin.shareText(shareString: "分享测试数据");
  UmengPlugin.shareWeb(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',webUrl: 'www.baidu.com' );

```
  - 登录
```dart
   UmengPlugin.loginWechat; //返回为Map
   UmengPlugin.loginQQ;
   UmengPlugin.loginSina;
```

 - 埋点
```dart
UmengPlugin.beginPageView("flutterHomePage");
UmengPlugin.endPageView("flutterEndPage");
UmengPlugin.logPageView("flutterHomePage",seconds: 10);
UmengPlugin.analyticsEvent("flutterHomePage",label: 'lable');
```




## 基础环境
本项目环境V1.7.8+4

```dart
// 运行如下命令
flutter --version
dart --version
pub --version

// 正确环境如下
// Flutter (Channel beta, v1.7.8)
// Dart VM version: 2.4.0
// Pub 2.4.0
```


### 背景

#### Flutter 是什么?

2018年6月21日Google发布Flutter首个release预览版,作为Google 大力推出的一种全新的响应式，跨平台，高性能的移动开发框架。Flutter是一个跨平台的移动UI框架，旨在帮助开发者使用一套代码开发高性能、高保真的Android和iOS应用。

flutter优点主要包括：
- 跨平台
- 开源
- Hot Reload、响应式框架、及其丰富的控件以及开发工具
- 灵活的界面设计以及控件组合
- 借助可以移植的GPU加速的渲染引擎以及高性能ARM代码运行时已达到高质量的用户体验

### app 预览

<img src="https://github.com/sanrixue/macdown/blob/master/umengPlugin.gif?raw=true" width=200> 

### Core Team

<table>
  <tbody>
    <tr>
      <td align="center" width="80" valign="top">
        <img height="80" width="80" src="https://github.com/sanrixue/macdown/blob/master/WechatIMG6.jpeg?raw=true">
        <br>
        <a href="https://github.com/sanrixue">@Eureka</a>
      </td>
     </tr>
  </tbody>
</table>

### 版权说明
- 感谢大家对 `Flutter UMeng Plugin` 的支持和下载。

- 大家的互相信任，尊重与支持，才是开源社区前进的动力和来源.

Powered by Eureka
