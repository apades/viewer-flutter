# viewer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 安装
## android gradle build问题
修改`\flutter\packages\flutter_tools\gradle\flutter.gradle`
```groovy
buildscript {
    repositories {
        // google()
        // jcenter()
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/jcenter' }
        maven { url 'http://maven.aliyun.com/nexus/content/groups/public' }
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:3.5.0'
    }
}
```

## 快速启动dart命令
`choco install dart-sdk`

# 用法

## 快速json
``` dart
API.getUsers().then((response) {
    setState(() {
    Iterable list = json.decode(response.body);
    users = list.map((model) => User.fromJson(model)).toList();
    });
});
```