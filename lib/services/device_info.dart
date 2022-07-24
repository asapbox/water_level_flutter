import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_udid/flutter_udid.dart';

class DeviceInfo {
  static Future<String> getDeviceId() async {
//    TODO: implement web device_id
    if (kIsWeb) return '${new DateTime.now().millisecondsSinceEpoch}';
    return FlutterUdid.consistentUdid;
  }

  static String get platform => getPlatformName().toLowerCase();

  static String getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return Platform.operatingSystem;
  }

  static bool isDesktopPlatform() {
    if (Platform.isMacOS)
      return true;
    if (Platform.isWindows)
      return true;
    if (Platform.isLinux)
      return true;
    return false;
  }
}
