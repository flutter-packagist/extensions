import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限扩展：
/// 1. 申请权限被永久拒绝后统一处理
/// 2. 适配Android 13权限变更（多媒体资源访问）
extension PermissionActionHandle on Permission {
  Future<PermissionStatus> use({
    Function(PermissionStatus)? onAccept,
    Function(PermissionStatus)? onDenied,
    bool showSettingDialog = true,
    String? permissionTitle,
  }) async {
    Permission permission = await _handleMediaPermission();
    final PermissionStatus status = await permission.request();
    if (status.isGranted || status.isLimited) {
      onAccept?.call(status);
    } else if (onDenied != null) {
      onDenied.call(status);
    } else if (status.isPermanentlyDenied && showSettingDialog) {
      String title = permissionTitle ?? permission._handleSettingTitle();
      PermissionContext.showSettingDialog(text: title);
    }
    return status;
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

  String _handleSettingTitle() {
    Map<Permission, String> permissionMap = PermissionContext._permissionMap ??
        {
          Permission.camera: '相機',
          Permission.contacts: '聯絡人',
          Permission.location: '位置',
          Permission.locationAlways: '位置',
          Permission.locationWhenInUse: '位置',
          Permission.microphone: '麥克風',
          Permission.phone: '電話',
          Permission.photos: '相片和影片',
          Permission.photosAddOnly: '',
          Permission.sensors: '人體感測器',
          Permission.sms: '簡訊',
          Permission.speech: '錄音',
          Permission.storage: '儲存空間',
          Permission.ignoreBatteryOptimizations: '電池優化',
          Permission.notification: '通知',
          Permission.bluetooth: '藍牙',
          Permission.videos: '相片和影片',
          Permission.audio: '音樂和音訊',
          Permission.calendarWriteOnly: '日曆',
          Permission.calendarFullAccess: '日曆',
        };
    print("permissionMap: $this ==> ${permissionMap[this]}");
    return permissionMap[this] ?? '';
  }
}

class PermissionContext {
  static BuildContext? _context;
  static String? _title;
  static String Function(String text)? _description;
  static String? _cancelText;
  static String? _confirmText;
  static Map<Permission, String>? _permissionMap;

  static void init(
    BuildContext context, {
    String? title,
    String Function(String text)? description,
    String? cancelText,
    String? confirmText,
    Map<Permission, String>? permissionMap,
  }) {
    _context = context;
    _title = title;
    _description = description;
    _cancelText = cancelText;
    _confirmText = confirmText;
    _permissionMap = permissionMap;
  }

  static Future showSettingDialog({String text = ""}) {
    assert(_context != null, 'Please call initContext() method first.');
    return showDialog(
      context: _context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Text(
              _title ?? '授權失敗',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _description?.call(text) ?? '請前往設置中心開啟$text權限',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(height: 0.5, width: 300, color: Colors.black12),
            SizedBox(
              width: 300,
              height: 50,
              child: Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(_context!).pop(),
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      _cancelText ?? '取消',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(height: 50, width: 0.5, color: Colors.black12),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(_context!).pop();
                      openAppSettings();
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      _confirmText ?? '前往',
                      style: const TextStyle(
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
      ),
    );
  }
}
