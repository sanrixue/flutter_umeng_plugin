package com.example.flutter_umeng_plugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterUmengPlugin */
public class FlutterUmengPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "umeng_plugin");
    channel.setMethodCallHandler(new FlutterUmengPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("shareInit")) {
      result.success("Android");
    } 
    else if (call.method.equals("shareText")) {
      result.success("Android");
    } 
    else if (call.method.equals("shareImage")) {
      result.success("Android");
    } 
    else if (call.method.equals("shareImageText")) {
      result.success("Android");
    } 
    else if (call.method.equals("shareWebView")) {
      result.success("Android");
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
      result.success("Android");
    } 
     else if (call.method.equals("loginQQ")) {
      result.success("Android");
    } 
     else if (call.method.equals("loginSina")) {
      result.success("Android");
    } 
       else if (call.method.equals("analyticsInit")) {
      result.success("Android");
    } 
       else if (call.method.equals("beginPageView")) {
      result.success("Android");
    } 
       else if (call.method.equals("endPageView")) {
      result.success("Android");
    } 
      else if (call.method.equals("logPageView")) {
      result.success("Android");
    } 
          else if (call.method.equals("analyticsEvent")) {
      result.success("Android");
    } 
          else if (call.method.equals("configure")) {
      result.success("Android");
    } 
    else {
      result.notImplemented();
    }
  }
}
