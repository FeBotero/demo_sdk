import 'package:flutter_test/flutter_test.dart';
import 'package:sdk_camera_ios/sdk_camera_ios.dart';
import 'package:sdk_camera_ios/sdk_camera_ios_platform_interface.dart';
import 'package:sdk_camera_ios/sdk_camera_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSdkCameraIosPlatform
    with MockPlatformInterfaceMixin
    implements SdkCameraIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SdkCameraIosPlatform initialPlatform = SdkCameraIosPlatform.instance;

  test('$MethodChannelSdkCameraIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSdkCameraIos>());
  });

  test('getPlatformVersion', () async {
    SdkCameraIos sdkCameraIosPlugin = SdkCameraIos();
    MockSdkCameraIosPlatform fakePlatform = MockSdkCameraIosPlatform();
    SdkCameraIosPlatform.instance = fakePlatform;

    expect(await sdkCameraIosPlugin.getPlatformVersion(), '42');
  });
}
