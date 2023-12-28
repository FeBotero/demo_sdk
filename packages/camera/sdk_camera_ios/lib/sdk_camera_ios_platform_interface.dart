import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sdk_camera_ios_method_channel.dart';

abstract class SdkCameraIosPlatform extends PlatformInterface {
  /// Constructs a SdkCameraIosPlatform.
  SdkCameraIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static SdkCameraIosPlatform _instance = MethodChannelSdkCameraIos();

  /// The default instance of [SdkCameraIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelSdkCameraIos].
  static SdkCameraIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SdkCameraIosPlatform] when
  /// they register themselves.
  static set instance(SdkCameraIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
