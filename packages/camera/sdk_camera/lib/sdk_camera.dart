// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:sdk_camera_platform_interface/sdk_camera_platform_interface.dart';

export 'package:sdk_camera_platform_interface/sdk_camera_platform_interface.dart';

class SdkCamera {
  Future<String?> getPlatformVersion() {
    return SdkCameraPlatformInterface.instance.getPlatformVersion();
  }

  Future<Response> login(LoginSettings settings) {
    return SdkCameraPlatformInterface.instance.login(settings);
  }

  Future<Response> logout(int userID) {
    return SdkCameraPlatformInterface.instance.logout(userID);
  }
}
