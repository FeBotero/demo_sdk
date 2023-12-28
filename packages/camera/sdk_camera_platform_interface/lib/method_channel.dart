import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sdk_camera_platform_interface/src/types/login_settings.dart';
import 'package:sdk_camera_platform_interface/src/types/response.dart';

import 'platform_interface.dart';

/// An implementation of [SdkCameraPlatformInterface] that uses method channels.
class MethodChannelSdkCameraPlatformInterface
    extends SdkCameraPlatformInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk_camera');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Response> login(LoginSettings settings) async {
    final Map? methodResponse =
        await methodChannel.invokeMethod<Map>('login', <String, dynamic>{
      'ip': settings.ip,
      'port': settings.port,
      'userName': settings.userName,
      'password': settings.password
    });

    return handleMethodResponse(methodResponse);
  }

  @override
  Future<Response> logout(int userID) async {
    final Map? methodResponse = await methodChannel
        .invokeMethod<Map>('logout', <String, int?>{'userID': userID});
    return handleMethodResponse(methodResponse);
  }

  Response handleMethodResponse(Map? methodResponse) {
    return Response(
      status: methodResponse!['status'] == 0
          ? ResponseStatus.success
          : ResponseStatus.failure,
      value: methodResponse['value'],
    );
  }
}
