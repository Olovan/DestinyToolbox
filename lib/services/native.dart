import 'package:flutter/services.dart';

class NativeIntegrationService {
  // These values must match the values used in MainActivity.kt in the native code
  static const CHANNEL_NAME = 'com.example.Destiny2Toolbox';
  static const VIEW_URL_METHOD = "openUrl";
  static const AUTH_CALLBACK = "handleAuthCode";

  Map<String, Function> handlers;
  MethodChannel channel;

  factory NativeIntegrationService() {
    return NativeIntegrationService._(MethodChannel(CHANNEL_NAME));
  }

  NativeIntegrationService._(this.channel) {
    this.handlers = new Map<String, Function>();
    this.channel.setMethodCallHandler(_handleNativeCall);
  }

  addMethodHandler(String methodName, dynamic Function(dynamic) callback) {
    handlers[methodName] = callback;
  }

  Future<dynamic> _handleNativeCall(MethodCall call) {
    String method = call.method;
    if(handlers.containsKey(method)) {
      return handlers[method](call.arguments);
    }
  }

  invokeNativeMethod(String methodName, [dynamic args]) {
    channel.invokeMethod(methodName, args);
  }
}