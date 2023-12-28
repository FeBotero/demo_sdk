import 'package:flutter_test/flutter_test.dart';
import 'package:sdk_camera_platform_interface/sdk_camera_platform_interface.dart';
import 'package:sdk_camera_platform_interface/platform_interface.dart';
import 'package:sdk_camera_platform_interface/method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSdkCameraPlatformInterfacePlatform
    with MockPlatformInterfaceMixin
    implements SdkCameraPlatformInterface {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Response> getChannelList(int userID) {
    // TODO: implement getChannelList
    throw UnimplementedError();
  }

  @override
  Future<Response> login(LoginSettings settings) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Response> logout(int userID) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Response> startPlayback(int userID, int channelId, int winIndex) {
    // TODO: implement startPlayback
    throw UnimplementedError();
  }

  @override
  Future<Response> stopLive(int userID, int winIndex) {
    // TODO: implement stopLive
    throw UnimplementedError();
  }
}

void main() {
  final SdkCameraPlatformInterface initialPlatform =
      SdkCameraPlatformInterface.instance;

  test('$MethodChannelSdkCameraPlatformInterface is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelSdkCameraPlatformInterface>());
  });

  void main() {
    final SdkCameraPlatformInterface initialPlatform =
        SdkCameraPlatformInterface.instance;

    test('$MethodChannelSdkCameraPlatformInterface is the default instance',
        () {
      expect(initialPlatform,
          isInstanceOf<MethodChannelSdkCameraPlatformInterface>());
    });
  }
}
