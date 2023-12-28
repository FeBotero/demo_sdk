import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sdk_camera_ios_platform_interface.dart';

/// An implementation of [SdkCameraIosPlatform] that uses method channels.
class MethodChannelSdkCameraIos extends SdkCameraIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk_camera_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
