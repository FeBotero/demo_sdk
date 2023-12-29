package mb.sdk_camera_android.sdk

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import mb.sdk_camera_android.uniview.UniviewCamera
import mb.sdk_camera_android.uniview.UniviewLoginSettings
import mb.sdk_camera_android.uniview.UniviewResponse
import mb.sdk_camera_android.uniview.ResponseStatus

/** SdkCameraAndroidPlugin */
class SdkCameraAndroidPlugin: FlutterPlugin, MethodCallHandler {
  
  private lateinit var channel : MethodChannel

    private var univiewCamera = UniviewCamera()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sdk_camera")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
        "getPlatformVersion" -> {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "login" -> {
            result.success(executeLogin(call))
        }
        "logout" -> {
            result.success(executeLogout(call))
        }
        else -> {
            result.notImplemented()
        }
    }
}


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  
    private fun executeLogin(call: MethodCall): Map<String, Any?> {
        val settings = UniviewLoginSettings(
            call.argument("ip") ?: "",
            call.argument("port") ?: 0,
            call.argument("userName") ?: "",
            call.argument("password") ?: "",
            mapOf()
        )
        val response = univiewCamera.login(settings)
        return "success"
        // handleUniviewResponse(response)
    }

    private fun executeLogout(call: MethodCall): Map<String, Any?> {
        val response = univiewCamera.logout(call.argument("userID"))
        return handleUniviewResponse(response)
    }

    private fun handleUniviewResponse(response: UniviewResponse): Map<String, Any?> {
        return mapOf(
            "status" to response.status.value,
            "value" to response.value,
        )
    }

}
