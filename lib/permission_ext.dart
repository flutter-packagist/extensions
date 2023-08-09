import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:route/route.dart';

extension PermissionActionHandle on Permission {
  Future<PermissionStatus> use({
    Function(PermissionStatus)? onAccept,
    Function(PermissionStatus)? onDenied,
  }) async {
    Permission permission = await _handleMediaPermission();
    final PermissionStatus status = await permission.request();
    if (status.isGranted || status.isLimited) {
      onAccept?.call(status);
    } else if (onDenied != null) {
      onDenied.call(status);
    } else if (status.isPermanentlyDenied) {
      settingDialog();
    }
    return status;
  }

  Future settingDialog({String? description}) {
    return Go.dialog(Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            '提示',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description ?? '請在設置中打開權限',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 0.5, width: 300, color: Colors.black12),
          SizedBox(
            width: 300,
            height: 50,
            child: Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Go.back(),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(height: 50, width: 0.5, color: Colors.black12),
              Expanded(
                child: TextButton(
                  onPressed: () => openAppSettings(),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    '前往',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    ));
  }

  // 在 Android 上，Permission.storage 权限链接到 Android READ_EXTERNAL_STORAGE 和 WRITE_EXTERNAL_STORAGE 权限。
  // 从 Android SDK 29 (Android 10) 开始，READ_EXTERNAL_STORAGE 和 WRITE_EXTERNAL_STORAGE 权限已被标记为已弃用，
  // 并自 Android SDK 33 (Android 13) 起已完全删除/禁用。
  //
  // 如果您的应用程序需要访问媒体文件，Google 建议使用 READ_MEDIA_IMAGES、READ_MEDIA_VIDEOS 或 READ_MEDIA_AUDIO 权限。
  // 这些可以分别使用 Permission.photos、Permission.videos 和 Permission.audio 来请求。 要请求这些权限，
  // 请确保 android/app/build.gradle 文件中的compileSdkVersion 设置为 33。
  Future<Permission> _handleMediaPermission() async {
    Permission permission = this;
    if (GetPlatform.isAndroid) {
      if (this == Permission.photos ||
          this == Permission.videos ||
          this == Permission.audio) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          permission = Permission.storage;
        }
      }
    }
    return permission;
  }
}
