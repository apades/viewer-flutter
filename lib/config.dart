import 'package:flutter/material.dart';

enum DevMode { sf, ad }

class AppConfig {
  DevMode mode;
  static AppConfig _appConfig;

  factory AppConfig(DevMode mode) {
    if (_appConfig != null)
      return _appConfig;
    else {
      _appConfig = AppConfig._init(mode);
      return _appConfig;
    }
  }

  static AppConfig getConfig() {
    if (_appConfig == null) return throw new ErrorSummary("需要初始化");
    return _appConfig;
  }

  AppConfig._init(this.mode);
}
