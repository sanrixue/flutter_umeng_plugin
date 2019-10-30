import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_umeng_plugin/flutter_umeng_plugin.dart';
import 'package:flutter_umeng_plugin/umeng_push_plugin.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
     initUMeng(); //初始化友盟控件
    //  initPushState();
     FlutterUmengPlugin.logPageView("flutterHomePage",seconds: 10);
  }

  
  //获取推送信息
  Future<void> initPushState() async {
      UmengPush().configure(
      onMessage: (String message) async {
        print("Message: $message");
        setState(() {
        });
        return true;
      },
      onLaunch: (String message) async {
        print("Launch: $message");
        setState(() {
        });
        return true;
      },
      onResume: (String message) async {
        print("Resume: $message");
        setState(() {
        });
        return true;
      },
      onToken: (String token) async {
        print("Token: $token");
        setState(() {
        
        });
        return true;
      },
    );
  }
// com.formal.flutter1r1y
// com.example.flutterUmengPluginExample
  //初始化友盟 同时初始化埋点
  Future<void> initUMeng() async {
    String umSocialSDKVersion;
    try {
      umSocialSDKVersion = await FlutterUmengPlugin.shareInit(
        umengAppkey: "5db7a5424ca357186c000465", //your Umeng appkey
        umengMessageSecret: 'e53f592870e6d34e02f09b10eeebaf52', //your Umeng Message Secret Of Android 
        channel: "App Store", //your Umeng channel
        //以下key secret 需要在各自的开放平台申请
        wxAppKey: "wxf88b59b3cd70a18d",
        wxAppSecret: "420baa192d1eeec5787c9956269515a7",
        wxRedirectURL: "http://mobile.umeng.com/social",//默认回调
        qqAppID: "",
        qqRedirectURL: "http://mobile.umeng.com/social",
        wbAppKey: "",
        wbAppSecret: "",
        wbRedirectURL: "",//微博中设置
      );
      umSocialSDKVersion = await FlutterUmengPlugin.analyticsInit(
        umengAppkey: "5db7a5424ca357186c000465", //your Umeng appkey
        channel: "App Store", //your Umeng channel
      );
    } on PlatformException {
      umSocialSDKVersion = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(umSocialSDKVersion);
    });
  }

  Future<void> shareText() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareText(shareString: "分享测试数据");
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;

    setState(() {
      print(result);
    });
  }

  Future<void> shareImage() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareImage(shareImage: "https://mobile.umeng.com/images/pic/home/social/img-1.png");
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

    Future<void> shareImageText() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareImageText(shareText: "分享文字",shareImage: "https://mobile.umeng.com/images/pic/home/social/img-1.png");
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

  // 其中 icon 需要配置在项目中
  Future<void> shareWebView() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareWeb(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',webUrl: 'https://www.baidu.com' );
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

    // 其中 icon 需要配置在项目中
  Future<void> shareMusicView() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareMusic(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',musicUrl: 'http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect');
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

 // 其中 icon 需要配置在项目中
  Future<void> shareVideoView() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareVideo(shareTitle: '分享标题',descr:'分享简介',icon: 'AppIcon',videoUrl: 'http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html');
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

    Future<void> loginToWx() async {
    Map result;
    try {
      result = await FlutterUmengPlugin.loginWechat;
    } on PlatformException {
      result = {"status": 'fail'};
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

      Future<void> loginToQQ() async {
    Map result;
    try {
      result = await FlutterUmengPlugin.loginQQ;
    } on PlatformException {
      result = {"status": 'fail'};
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

      Future<void> loginToSina() async {
    Map result;
    try {
      result = await FlutterUmengPlugin.loginSina;
    } on PlatformException {
      result = {"status": 'fail'};
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterUmengPlugin-share Push'),
        ),
        body: new ListView(
          padding: EdgeInsets.only(top: 10),
          children: <Widget>[
            new Center(
              child: RaisedButton(
                onPressed: () {
                  shareText();
                },
                child: Text("分享文本"),
              ),
            ),
            new Center(
              child: RaisedButton(
                onPressed: () {
                  shareImage();
                },
                child: Text("分享图片"),
              ),
            ),
            new Center(
              child: RaisedButton(
                onPressed: () {
                  shareImageText();
                },
                child: Text("分享图文"),
              ),
            ),
            new Center(
              child: RaisedButton(
                onPressed: () {
                  shareWebView();
                },
                child: Text("分享网页"),
              ),
            ),
            new Center(
              child: RaisedButton(
                onPressed: () {
                  shareMusicView();
                },
                child: Text("分享音乐"),
              ),
            ),
            new Center(
              child: RaisedButton(
                onPressed: () {
                  shareVideoView();
                },
                child: Text("分享视频"),
              ),
            ),
            // new Center(
            //   child: RaisedButton(
            //     onPressed: () {},
            //     child: Text("分享微信表情"),
            //   ),
            // ),
            // new Center(
            //   child: RaisedButton(
            //     onPressed: () {},
            //     child: Text("分享微信小程序"),
            //   ),
            // ),
            new Center(
              child: RaisedButton(
                onPressed: () {
                   loginToWx();
                },
                child: Text("微信登录"),
              ),
            ),
                        new Center(
              child: RaisedButton(
                onPressed: () {
                   loginToQQ();
                },
                child: Text("QQ登录"),
              ),
            ),
                        new Center(
              child: RaisedButton(
                onPressed: () {
                   loginToSina();
                },
                child: Text("微博登录"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
