import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sdk_camera_platform_interface/src/types/login_settings.dart';
import 'package:sdk_camera_platform_interface/src/types/response.dart';

import 'method_channel.dart';

abstract class SdkCameraPlatformInterface extends PlatformInterface {
  SdkCameraPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static SdkCameraPlatformInterface _instance =
      MethodChannelSdkCameraPlatformInterface();

  static SdkCameraPlatformInterface get instance => _instance;

  static set instance(SdkCameraPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Response> login(LoginSettings settings) {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<Response> logout(int userID) {
    throw UnimplementedError('logout() has not been implemented.');
  }
}
