import android.content.Context
import io.flutter.plugin.common.StandartMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import mb.sdk_camera_android.sdk.LivePlayerNativeView

class LivePlayerNativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return LivePlayerNativeView(context, viewId, creationParams)
    }
}
