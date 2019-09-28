#import "FlutterUmengPlugin.h"
#import <UMCShare/UMSocialQQHandler.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UserNotifications/UserNotifications.h>
#import <UMPush/UMessage.h>
#import <UMAnalytics/MobClick.h>
#import "UmengPush.h" //推送插件
#import <UMErrorCatch/UMErrorCatch.h>

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

@implementation FlutterUmengPlugin

//share plugin start
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"umeng_plugin"
            binaryMessenger:[registrar messenger]];
  FlutterUmengPlugin* instance = [[FlutterUmengPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
  [UmengPush registerPushWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
   __strong NSString * methodString = call.method;
    
    SWITCH (methodString) {
        CASE (@"shareInit") {
            // U-Share 平台设置
             NSString *umengAppkey = call.arguments[@"umengAppkey"];
             NSString *channel = call.arguments[@"channel"];
             NSString *wxAppKey = call.arguments[@"wxAppKey"];
             NSString *wxAppSecret = call.arguments[@"wxAppSecret"];
             NSString *wxRedirectURL = call.arguments[@"wxRedirectURL"];
             NSString *qqAppID = call.arguments[@"qqAppID"];
             NSString *qqRedirectURL = call.arguments[@"qqRedirectURL"];
             NSString *wbAppKey = call.arguments[@"wbAppKey"];
             NSString *wbAppSecret = call.arguments[@"wbAppSecret"];
             NSString *wbRedirectURL = call.arguments[@"wbRedirectURL"];
             //设置友盟appkey
             [UMConfigure initWithAppkey:umengAppkey channel:channel];
             //打开调试日志
             [[UMSocialManager defaultManager] openLog:false];
             //设置微信的appKey和appSecret
             [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wxAppKey appSecret:wxAppSecret redirectURL:wxRedirectURL];
             //QQ端统一和网页端使用相同的APPKEY
             [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqAppID/*设置QQ平台的appID*/  appSecret:nil redirectURL:qqRedirectURL];
             /* 设置新浪的appKey和appSecret */
             [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:wbAppKey  appSecret:wbAppSecret redirectURL:wbRedirectURL];
             // 获取友盟social版本号
            result([UMSocialGlobal umSocialSDKVersion]);
//            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            
            FlutterViewController* flutterViewController = [FlutterViewController new];
            //初始化FlutterEventChannel对象
            [flutterViewController setInitialRoute:@"iOSSendToFlutter"];
            FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"App/Event/Channel" binaryMessenger:flutterViewController];
            [eventChannel setStreamHandler:self];
            
            break;
        }   //初始化
        CASE (@"shareText") {
             //配置需要的分享的三方应用 单独写出去 会出现第一次没有平台的问题
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
              //显示分享面板
              [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                  //创建分享消息对象
                  UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                  //设置文本
                  messageObject.text = call.arguments[@"shareString"];
                  //调用分享接口
                  [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                      if (error) {
                          //有回调 此为分享失败 统一为fail
                          result(@"fail");
                      }else{
                          //有回调 但是否是真分享不能判断 三方平台d没有返回信息 统一为success
                          result(@"success");
                      }
                  }];
              }];
            break;
        }   //分享文本
        CASE (@"shareImage") {
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
                  //显示分享面板
                  [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                      //创建分享消息对象
                      UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                      //创建图片内容对象
                      UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                      //如果有缩略图，则设置缩略图
            //          shareObject.thumbImage = [UIImage imageNamed:@"icon"];
                      [shareObject setShareImage:call.arguments[@"shareImage"]];
                      //分享消息对象设置分享内容对象
                      messageObject.shareObject = shareObject;
                     //调用分享接口
                      [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                          if (error) {
                              result(@"fail");
                          }else{
                              result(@"success");
                          }
                      }];
                  }];
            break;
        }  //分享图片
        CASE(@"shareImageText"){
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
                  //显示分享面板
                  [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                      //创建分享消息对象
                      UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                      //设置文本
                      messageObject.text =call.arguments[@"shareText"];
                      //创建图片内容对象
                      UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                      //如果有缩略图，则设置缩略图
//                      shareObject.thumbImage = [UIImage imageNamed:@"icon"];
                      [shareObject setShareImage:call.arguments[@"shareImage"]];
//                    [shareObject setShareImageArray:<#(NSArray *)#>];//或者是数组，支持新浪微博
                      //分享消息对象设置分享内容对象
                      messageObject.shareObject = shareObject;
                      //调用分享接口
                      [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                          if (error) {
                              result(@"fail");
                          }else{
                              result(@"success");
                          }
                      }];
                  }];
            break;
        }//分享图文
        CASE(@"shareWebView"){
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                  //创建分享消息对象
                     UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                     //创建网页内容对象
                     UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:call.arguments[@"shareTitle"] descr:call.arguments[@"descr"] thumImage:[UIImage imageNamed:call.arguments[@"icon"]]];
                     //设置网页地址
                     shareObject.webpageUrl =call.arguments[@"webUrl"];
                     //分享消息对象设置分享内容对象
                     messageObject.shareObject = shareObject;
                     //调用分享接口
                     [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                         if (error) {
                             result(@"fail");
                         }else{
                             result(@"success");
                         }
                     }];
            }];
            break;
        }  //分享网页
        CASE(@"shareMusic"){
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    //创建分享消息对象
                     UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                     //创建音乐内容对象
                     UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:call.arguments[@"shareTitle"] descr:call.arguments[@"descr"] thumImage:[UIImage imageNamed:call.arguments[@"icon"]]];
                     //设置音乐网页播放地址
                     shareObject.musicUrl = call.arguments[@"musicUrl"];
                     //shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
                     //分享消息对象设置分享内容对象
                     messageObject.shareObject = shareObject;
                     //调用分享接口
                     [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                         if (error) {
                             result(@"fail");
                         }else{
                             result(@"success");
                         }
                     }];
            }];
            break;
        }    //分享音乐
        CASE(@"shareVideo"){
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    //创建分享消息对象
                     UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    //创建视频内容对象
                     UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:call.arguments[@"shareTitle"] descr:call.arguments[@"descr"] thumImage:[UIImage imageNamed:call.arguments[@"icon"]]];
                     //设置音乐网页播放地址
                     shareObject.videoUrl = call.arguments[@"videoUrl"];
                      //shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
                //分享消息对象设置分享内容对象
                     messageObject.shareObject = shareObject;
                     //调用分享接口
                     [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                         if (error) {
                             result(@"fail");
                         }else{
                             result(@"success");
                         }
                     }];
            }];
           break;
        } //分享视频
        CASE(@"shareWXExpression"){
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Sina)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    //创建分享消息对象
                     UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//                     UMShareEmotionObject *shareObject = [UMShareEmotionObject shareObjectWithTitle:UMS_Title descr:UMS_Text thumImage:nil];
//                     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gifFile"
//                                                                        ofType:@"gif"];
//                     NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
//                     shareObject.emotionData = emoticonData;
//                     messageObject.shareObject = shareObject;
                     //调用分享接口
                     [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                         if (error) {
                             result(@"fail");
                         }else{
                             result(@"success");
                         }
                     }];
            }];
           break;
        }//分享微信表情  暂不开发
        CASE(@"shareApplets"){
            break;
        }      //分享微细小程序
        CASE(@"loginWX"){
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id loginResult, NSError *error) {
                if (error) {
                    NSDictionary *resultDic=@{@"status":@"fail"};
                    result(resultDic);
                } else {
//                    resp.expiration 返回的是时间格式 不能作为
                    UMSocialUserInfoResponse *resp = loginResult;
                    // 第三方登录数据(为空表示平台未提供)
                    NSDictionary *resultDic=@{
                        @"status":@"success",
                        // 授权数据
                         @"uid":resp.uid,
                         @"openid":resp.openid,
                         @"accessToken":resp.accessToken,
                         @"refreshToken":resp.refreshToken,
                        // 用户数据
                         @"nickname":resp.name,
                         @"headimgurl":resp.iconurl,
                         @"unionId":resp.unionId,
                         @"gender":resp.unionGender};
                    result(resultDic);
                }
            }];
           break;
        }            //登录微信
        CASE(@"loginQQ"){
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id loginResult, NSError *error) {
                 if (error) {
                    NSDictionary *resultDic=@{@"status":@"fail"};
                    result(resultDic);
                } else {
//                    resp.expiration 返回的是时间格式 不能作为
                    UMSocialUserInfoResponse *resp = loginResult;
                    // 第三方登录数据(为空表示平台未提供)
                    NSDictionary *resultDic=@{
                        @"status":@"success",
                        // 授权数据
                         @"uid":resp.uid==nil?@"":resp.uid,
                         @"openid":resp.openid,
                         @"accessToken":resp.accessToken,
                         @"refreshToken":resp.refreshToken,
                        // 用户数据
                         @"nickname":resp.name,
                         @"headimgurl":resp.iconurl,
                         @"unionId":resp.unionId,
                         @"gender":resp.unionGender};
                    result(resultDic);
                }
            }];
           break;
        }                //登录QQ 未测试 需要真实ID测试一下
        CASE(@"loginSina"){
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id loginResult, NSError *error) {
                 if (error) {
                    NSDictionary *resultDic=@{@"status":@"fail"};
                    result(resultDic);
                } else {
//                    resp.expiration 返回的是时间格式 不能作为
                    UMSocialUserInfoResponse *resp = loginResult;
                    // 第三方登录数据(为空表示平台未提供)
                    NSDictionary *resultDic=@{
                        @"status":@"success",
                        // 授权数据
                         @"uid":resp.uid,
                         @"openid":resp.openid==nil?@"":resp.openid,//openid为空 字典避免插入空
                         @"accessToken":resp.accessToken,
                         @"refreshToken":resp.refreshToken,
                        // 用户数据
                         @"nickname":resp.name,
                         @"headimgurl":resp.iconurl,
                         @"unionId":resp.unionId,
                         @"gender":resp.unionGender};
                    result(resultDic);
                }
            }];
           break;
        }            //登录微博
        //以下为埋点
        CASE(@"analyticsInit"){
            NSString *appKey = call.arguments[@"umengAppkey"];
            NSString *channel = call.arguments[@"channel"];
            BOOL logEnable = [call.arguments[@"logEnable"] boolValue];
            BOOL encrypt = [call.arguments[@"encrypt"] boolValue];
            BOOL reportCrash = [call.arguments[@"reportCrash"] boolValue];
//            NSString *deviceID = [UMConfigure deviceIDForIntegration];
            [UMConfigure initWithAppkey:appKey channel:channel];
            [UMCommonLogManager setUpUMCommonLogManager];
            [UMConfigure setLogEnabled:logEnable];
            [UMConfigure setEncryptEnabled:encrypt];
            [MobClick setCrashReportEnabled:reportCrash];
            [UMErrorCatch initErrorCatch];
            result(nil);
        break;
        }//埋点统计事件初始化
        CASE(@"beginPageView"){
          [MobClick beginLogPageView:call.arguments[@"pageName"]];
        break;
        }//页面开始统计
        CASE(@"endPageView"){
          [MobClick endLogPageView:call.arguments[@"pageName"]];
        break;
        }//页面结束统计
        CASE(@"logPageView"){
         [MobClick logPageView:call.arguments[@"pageName"] seconds:[call.arguments[@"seconds"] intValue]];
        break;
        }//登录页面统计
        CASE(@"analyticsEvent"){
            [MobClick event:call.arguments[@"pageName"] label:call.arguments[@"label"]];
        break;
        }//事件统计
        DEFAULT {
            result(FlutterMethodNotImplemented);
            break;
        }
     }
    
}




@end
