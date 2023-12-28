

import android.content.Context
import android.content.res.XmlResourceParser
import android.util.AttributeSet
import android.util.Xml
import android.view.View
import io.flutter.plugin.platform.PlatformView
import mb.sdk_camera_android.uniview.LivePlayerView


internal class LivePlayerNativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val livePlayerView: LivePlayerView
    private val parser: XmlResourceParser = context.resources.getLayout(R.layout.live_player_view)
    private val attributeSet: AttributeSet = Xml.asAttributeSet(parser)

    override fun getView(): View {
        return livePlayerView
    }

    override fun dispose() {}

    init {
        livePlayerView = LivePlayerView(context, attributeSet, (creationParams?.get("winIndex") as Int?) ?: -1)
    }
}
