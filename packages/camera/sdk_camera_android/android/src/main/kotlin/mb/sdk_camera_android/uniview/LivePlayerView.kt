import javax.microedition.khronos.egl.EGL10
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.egl.EGLContext
import javax.microedition.khronos.egl.EGLDisplay
import javax.microedition.khronos.opengles.GL10
import android.content.Context
import android.opengl.GLSurfaceView
import android.util.AttributeSet
import android.util.Log
import com.sdk.*


class LivePlayerView(context: Context?, attrs: AttributeSet, private var dwWinIndex: Int) : GLSurfaceView(context, attrs) {
    private var canDrawFrame: Boolean = true
    private var renderInited: Boolean = false

    init {
//        this.holder.setFormat(PixelFormat.TRANSLUCENT)
        setEGLContextFactory(ContextFactory())
//        setEGLConfigChooser(ConfigChooser(5, 6, 5, 0, 0, 0))
        setRenderer(Renderer())
    }

    inner class ContextFactory: EGLContextFactory {
        override fun createContext(
            egl: EGL10?,
            eglDisplay: EGLDisplay?,
            eglConfig: EGLConfig?
        ): EGLContext? {
            val attrList = intArrayOf(EGL_CONTEXT_CLIENT_VERSION, 2, EGL10.EGL_NONE)
            return egl?.eglCreateContext(eglDisplay, eglConfig, EGL10.EGL_NO_CONTEXT, attrList)
        }

        override fun destroyContext(egl: EGL10?, eglDisplay: EGLDisplay?, eglContext: EGLContext) {
            egl?.eglDestroyContext(eglDisplay, eglContext)
        }
    }

    inner class ConfigChooser(
        private val red: Int,
        private val green: Int,
        private val blue: Int,
        private val alpha: Int,
        private val depth: Int,
        private val stencil: Int
    ): EGLConfigChooser {
        private val mValue = IntArray(1)

        override fun chooseConfig(egl: EGL10?, eglDisplay: EGLDisplay): EGLConfig? {
            /*
             * Get the number of minimally matching EGL configurations
             */
            val numConfig = IntArray(1)
            egl!!.eglChooseConfig(eglDisplay, configAttrs, null, 0, numConfig)

            val numConfigs = numConfig[0]

            require(numConfigs > 0) { "No configs match configSpec" }


            /*
		 * Allocate then read the array of minimally matching EGL configs
		 */
            val configs = arrayOf<EGLConfig>()
            egl.eglChooseConfig(
                eglDisplay, configAttrs, configs, numConfigs,
                numConfig
            )

            return chooseConfig(egl, eglDisplay, configs)
        }

        fun chooseConfig(
            egl: EGL10, eglDisplay: EGLDisplay,
            eglConfigs: Array<EGLConfig>
        ): EGLConfig? {
            for (config in eglConfigs) {
                val d = findConfigAttrib(
                    egl, eglDisplay, config,
                    EGL10.EGL_DEPTH_SIZE, 0
                )
                val s = findConfigAttrib(
                    egl, eglDisplay, config,
                    EGL10.EGL_STENCIL_SIZE, 0
                )

                // We need at least mDepthSize and mStencilSize bits
                if (d < depth || s < stencil) continue

                // We want an *exact* match for red/green/blue/alpha
                val r = findConfigAttrib(
                    egl, eglDisplay, config,
                    EGL10.EGL_RED_SIZE, 0
                )
                val g = findConfigAttrib(
                    egl, eglDisplay, config,
                    EGL10.EGL_GREEN_SIZE, 0
                )
                val b = findConfigAttrib(
                    egl, eglDisplay, config,
                    EGL10.EGL_BLUE_SIZE, 0
                )
                val a = findConfigAttrib(
                    egl, eglDisplay, config,
                    EGL10.EGL_ALPHA_SIZE, 0
                )
                if (r == red && g == green && b == blue && a == alpha) return config
            }
            return null
        }

        private fun findConfigAttrib(
            egl: EGL10, display: EGLDisplay,
            config: EGLConfig, attribute: Int, defaultValue: Int
        ): Int {
            return if (egl.eglGetConfigAttrib(display, config, attribute, mValue)) {
                mValue[0]
            } else defaultValue
        }

    }

    inner class Renderer: GLSurfaceView.Renderer {
        init {
            val ret: Int = NetDEVSDK.initialize()
            if (ret == 1) {
                renderInited = true
            }
        }

        override fun onSurfaceCreated(gl: GL10?, glConfig: EGLConfig?) {
            Log.d(TAG, "onSurfaceCreated")
            NetDEVSDK.initializeRenderer(dwWinIndex)
        }

        override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
            Log.d(TAG, "onSurfaceChanged")
            NetDEVSDK.setRendererViewport(width, height)
        }

        override fun onDrawFrame(gl: GL10?) {
            if (canDrawFrame && renderInited) {
                NetDEVSDK.rendererRender(dwWinIndex)
            } else {
                gl?.glClear(GL10.GL_COLOR_BUFFER_BIT)
            }
        }

    }

    companion object {
        const val TAG = "LivePlayer"
        private const val EGL_CONTEXT_CLIENT_VERSION = 0x3098
        private const val EGL_OPENGL_ES2_BIT = 4
        private val configAttrs = intArrayOf(
            EGL10.EGL_RED_SIZE, 4,
            EGL10.EGL_GREEN_SIZE, 4, EGL10.EGL_BLUE_SIZE, 4,
            EGL10.EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT, EGL10.EGL_NONE
        )
    }
}

