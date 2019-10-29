package com.example.flutter_umeng_plugin;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import android.nfc.Tag;
import android.os.Build;
import android.util.Log;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.message.IUmengRegisterCallback;
import com.umeng.message.PushAgent;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMAuthListener;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMVideo;
import com.umeng.socialize.media.UMWeb;
import com.umeng.socialize.media.UMusic;


import java.util.HashMap;
import java.util.Map;

import com.umeng.socialize.shareboard.ShareBoardConfig;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import io.flutter.plugin.common.PluginRegistry.NewIntentListener;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener;

/** FlutterUmengPlugin */
public class FlutterUmengPlugin implements MethodCallHandler, ActivityResultListener, RequestPermissionsResultListener  {

    private final Registrar registrar;
    private final MethodChannel channel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "umeng_plugin");
      channel.setMethodCallHandler(new FlutterUmengPlugin(registrar, channel));
      FlutterUmengPushPlugin.registerWith(registrar);
  }

    private FlutterUmengPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
    }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("shareInit")) {
        UMConfigure.setLogEnabled(false);
        String appkey = call.argument("umengAppkey");
        String umengMessageSecret = call.argument("umengMessageSecret");
        String wxAppKey = call.argument("wxAppKey");
        String wxAppSecret = call.argument("wxAppSecret");


        UMConfigure.init(this.registrar.context(), appkey, "flutter_umeng_plugin", UMConfigure.DEVICE_TYPE_PHONE, umengMessageSecret);//58edcfeb310c93091c000be2 5965ee00734be40b580001a0
        PlatformConfig.setWeixin(wxAppKey, wxAppSecret);
//        PlatformConfig.setSinaWeibo(appKey, appSecret, redirectURL);
//        PlatformConfig.setQQZone(appKey, appSecret, redirectURL);

        // 选用AUTO页面采集模式
        MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);

        result.success("shareInitSuccess");
    } 
    else if (call.method.equals("shareText")) {
        String shareText = call.argument("shareString");
         new ShareAction(registrar.activity()).withText(shareText).setDisplayList(SHARE_MEDIA.SINA,SHARE_MEDIA.QQ,SHARE_MEDIA.WEIXIN)
                .setCallback(new UmengshareActionListener(registrar.activity(), result)).open();
    } 
    else if (call.method.equals("shareImage")) {
        String shareImage = call.argument("shareImage");
        final Activity activity = registrar.activity();
        UMImage sImage = new UMImage(activity, shareImage);  //分享图
        new ShareAction(activity)
                .setDisplayList(SHARE_MEDIA.SINA,SHARE_MEDIA.QQ,SHARE_MEDIA.WEIXIN)
                .withMedia(sImage)
                .setCallback(new UmengshareActionListener(activity, result)).open();
    } 
    else if (call.method.equals("shareImageText")) {
      result.success("Android");
    }
    else if (call.method.equals("shareWebView")) {
        String shareTitle = call.argument("shareTitle");
        String descr = call.argument("descr");
        String icon = call.argument("icon");
        String webUrl = call.argument("webUrl");
        Activity activity = registrar.activity();
        UMImage thumbImage = new UMImage(activity, icon);
        UMWeb web = new UMWeb(webUrl);
        web.setTitle(shareTitle);//标题
        web.setThumb(thumbImage);  //缩略图
        web.setDescription(descr);//描述
        new ShareAction(activity).setDisplayList(SHARE_MEDIA.SINA,SHARE_MEDIA.QQ,SHARE_MEDIA.WEIXIN)
                .withMedia(web)
                .setCallback(new UmengshareActionListener(activity, result)).open();
    } 
    else if (call.method.equals("shareMusic")) {
      result.success("Android");
    } 
    else if (call.method.equals("shareVideo")) {
      result.success("Android");
    } 
     else if (call.method.equals("shareWXExpression")) {
      result.success("Android");
    } 
     else if (call.method.equals("shareApplets")) {
      result.success("Android");
    } 
     else if (call.method.equals("loginWX")) {
        login(SHARE_MEDIA.WEIXIN,result);
    }
     else if (call.method.equals("loginQQ")) {
        login(SHARE_MEDIA.QQ,result);
    } 
     else if (call.method.equals("loginSina")) {
        login(SHARE_MEDIA.SINA,result);
    } 
     else if (call.method.equals("analyticsInit")) {
      result.success("Android");
    } 
       else if (call.method.equals("beginPageView")) {
        String pageName = call.argument("pageName");
        MobclickAgent.onPageStart(pageName); //统计页面("MainScreen"为页面名称，可自定义)
    } 
       else if (call.method.equals("endPageView")) {
        String pageName = call.argument("pageName");
        MobclickAgent.onPageEnd(pageName); //统计页面("MainScreen"为页面名称，可自定义)
    }
      else if (call.method.equals("logPageView")) {
      result.success("Android");
    } 
     else if (call.method.equals("analyticsEvent")) {
      result.success("Android");
    }
    else {
      result.notImplemented();
    }
  }


  private void login(SHARE_MEDIA platform, final Result result) {

        UMShareAPI.get(registrar.activity()).getPlatformInfo(registrar.activity(), platform, new UMAuthListener() {
            @Override
            public void onStart(SHARE_MEDIA share_media) {

            }
            @Override
            public void onComplete(SHARE_MEDIA share_media, int i, Map<String, String> map) {
                map.put("status", "success");
                result.success(map);

            }

            @Override
            public void onError(SHARE_MEDIA share_media, int i, Throwable throwable) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", "fail");
                result.success(map);
            }
            @Override
            public void onCancel(SHARE_MEDIA share_media, int i) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", "fail");
                result.success(map);
            }
        });
    }


    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        UMShareAPI.get(registrar.activity()).onActivityResult(i, i1, intent);
        return false;
    }

    @Override
    public boolean onRequestPermissionsResult(int i, String[] strings, int[] ints) {
        return false;
    }

}
