
import 'sdk_camera_ios_platform_interface.dart';

class SdkCameraIos {
  Future<String?> getPlatformVersion() {
    return SdkCameraIosPlatform.instance.getPlatformVersion();
  }
}
