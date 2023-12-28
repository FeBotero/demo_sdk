import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sdk_camera_platform_interface/sdk_camera_platform_interface.dart';

class SdkCameraAndroid extends SdkCameraPlatformInterface {
  static void registerWith() {
    SdkCameraPlatformInterface.instance = SdkCameraAndroid();
  }

  @visibleForTesting
  final methodChannel = const MethodChannel('sdk_camera');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
