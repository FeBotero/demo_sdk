package mb.sdk_camera_android.uniview

import android.util.Log
import com.sdk.NETDEV_DEVICE_LOGIN_INFO_S
import com.sdk.NETDEV_PREVIEWINFO_S
import com.sdk.NETDEV_SELOG_INFO_S
import com.sdk.NETDEV_VIDEO_CHL_DETAIL_INFO_S
import com.sdk.NetDEVSDK

class UniviewCamera {

        private val sdk = NetDEVSDK()
        private val channelInfoMap = mutableMapOf<Long, List<NETDEV_VIDEO_CHL_DETAIL_INFO_S>>()
        private val liveInfoMap = mutableMapOf<Long, Long>()

        fun login(settings: UniviewLoginSettings): UniviewResponse {
            Log.d(LOG_TAG, "Login")
            val response = UniviewResponse()

            val initRet = sdk.NETDEV_Init()

            if (initRet != 1) {
                return response
            }

            val deviceLoginInfo = NETDEV_DEVICE_LOGIN_INFO_S()
            val seLogInfo = NETDEV_SELOG_INFO_S()

            deviceLoginInfo.szIPAddr = settings.ip
            deviceLoginInfo.dwPort = settings.port
            deviceLoginInfo.szUserName = settings.userName
            deviceLoginInfo.szPassword = settings.password

            if (settings.extra.containsKey("dwLoginProto")) {
                deviceLoginInfo.dwLoginProto = settings.extra["dwLoginProto"].toString().toIntOrNull() ?: 0
            }

            if (settings.extra.containsKey("dwDeviceType")) {
                deviceLoginInfo.dwDeviceType = settings.extra["dwDeviceType"].toString().toIntOrNull() ?: 0
            }

            val userID = NetDEVSDK.NETDEV_Login_V30(deviceLoginInfo, seLogInfo)

            NetDEVSDK.lpUserID = userID
            response.value = userID

            Log.i(LOG_TAG, "UserID: 0x${userID.toString(16)}")

            if (userID == 0L) {
                return response
            }

            channelInfoMap[userID] = NetDEVSDK.NETDEV_QueryVideoChlDetailList(userID, 64)

            response.status = ResponseStatus.SUCCESS
            return response
        }

        fun logout(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "logout")
            val response = UniviewResponse()

            if (userID == null || userID == 0L) {
                return response
            }

            val winIndex = 0

            val oldLiveHandle = liveInfoMap[userID] ?: 0L

            if (oldLiveHandle != 0L) {
                NetDEVSDK.NETDEV_StopRealPlay(oldLiveHandle, winIndex)
            }

            if (NetDEVSDK.NETDEV_Logout(NetDEVSDK.lpUserID) == 1) {
                NetDEVSDK.lpUserID = 0L
                liveInfoMap.clear()
                channelInfoMap.clear()

                response.status = ResponseStatus.SUCCESS
                return response
            }

            return response
        }

        fun getChannelList(userID: Long?): UniviewResponse {
            val channelList = mutableListOf<Int>()
            val ch = channelInfoMap[userID] ?: return UniviewResponse(ResponseStatus.FAILURE)

            ch.forEach { channelList.add(it.dwChannelID) }

            return UniviewResponse(ResponseStatus.SUCCESS, channelList.toList())
        }

        fun startPlayback(userID: Long?, channelId: Int?, winIndex: Int?): UniviewResponse {
            Log.d(LOG_TAG, "startPlayback")
            val response = UniviewResponse()

            if (userID == null || userID == 0L) {
                return response
            }

            val stPreviewInfo = NETDEV_PREVIEWINFO_S()
            stPreviewInfo.dwChannelID = channelId ?: 1
            stPreviewInfo.dwLinkMode = 1 // TCP: 1 - UDP: 2
            stPreviewInfo.dwStreamIndex = 0 // Main stream: 0 - Sub stream: 1 - Third stream: 2

            val oldLiveHandle = liveInfoMap[userID] ?: 0L

            if (oldLiveHandle != 0L) {
                NetDEVSDK.NETDEV_StopRealPlay(oldLiveHandle, winIndex ?: -1)
            }

            val liveHandle = NetDEVSDK.NETDEV_RealPlay(userID, stPreviewInfo, winIndex ?: -1)
            Log.i(LOG_TAG, "LiveHandle: $liveHandle")
            liveInfoMap[userID] = liveHandle

            if (liveInfoMap[userID] == 0L) {
                response.status = ResponseStatus.FAILURE
            } else {
                response.status = ResponseStatus.SUCCESS
                response.value = liveInfoMap[userID]
            }

            return response
        }

        fun stopLive(userID: Long?, winIndex: Int?): UniviewResponse {
            Log.d(LOG_TAG, "stopLive")
            val response = UniviewResponse()

            if (userID == null || userID == 0L) {
                return response
            }

            val liveHandle = liveInfoMap[userID] ?: 0L

            var ret = 0
            if (liveHandle != 0L) {
                ret = NetDEVSDK.NETDEV_StopRealPlay(liveHandle, winIndex ?: -1)
            }

            if (ret == 1) {
                liveInfoMap[userID] = 0L
                response.status = ResponseStatus.SUCCESS
            } else {
                response.status = ResponseStatus.FAILURE
            }

            return response
        }

        fun zoomIn(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "zoomIn")

            return ptz(userID, ZOOM_IN, ZOOM_SPEED)
        }

        fun zoomOut(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "zoomOut")

            return ptz(userID, ZOOM_OUT, ZOOM_SPEED)
        }

        fun tiltUp(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "tiltUp")

            return ptz(userID, PAN_UP, PAN_TILT_SPEED)
        }

        fun tiltDown(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "tiltDown")

            return ptz(userID, PAN_DOWN, PAN_TILT_SPEED)
        }

        fun panLeft(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panLeft")

            return ptz(userID, PAN_LEFT, PAN_TILT_SPEED)
        }

        fun panRight(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panRight")

            return ptz(userID, PAN_RIGHT, PAN_TILT_SPEED)
        }

        fun panLeftUp(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panLeftUp")

            return ptz(userID, PAN_LEFT_UP, PAN_TILT_SPEED)
        }

        fun panLeftDown(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panLeftDown")

            return ptz(userID, PAN_LEFT_DOWN, PAN_TILT_SPEED)
        }

        fun panRightUp(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panRightUp")

            return ptz(userID, PAN_RIGHT_UP, PAN_TILT_SPEED)
        }

        fun panRightDown(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panRightDown")

            return ptz(userID, PAN_RIGHT_DOWN, PAN_TILT_SPEED)
        }

        fun focusFar(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panRightDown")

            return ptz(userID, FOCUS_FAR, PAN_TILT_SPEED)
        }

        fun focusNear(userID: Long?): UniviewResponse {
            Log.d(LOG_TAG, "panRightDown")

            return ptz(userID, FOCUS_NEAR, PAN_TILT_SPEED)
        }

        private fun ptz(userID: Long?, ptzType: Int, speed: Int): UniviewResponse {
            val response = UniviewResponse()

            if (userID == null || userID == 0L) {
                return response
            }

            val liveHandle = liveInfoMap[userID] ?: 0L

            if (liveHandle == 0L) {
                Log.e(LOG_TAG, "Playback start failed")

                return response
            }

            val ptzCommand = when (ptzType) {
                ZOOM_IN -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_ZOOMTELE
                ZOOM_OUT -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_ZOOMWIDE
                PAN_UP -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_TILTUP
                PAN_DOWN -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_TILTDOWN
                PAN_LEFT -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_PANLEFT
                PAN_RIGHT -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_PANRIGHT
                PAN_LEFT_UP -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_LEFTUP
                PAN_LEFT_DOWN -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_LEFTDOWN
                PAN_RIGHT_UP -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_RIGHTUP
                PAN_RIGHT_DOWN -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_RIGHTDOWN
                FOCUS_FAR -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_FOCUSFAR
                FOCUS_NEAR -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_FOCUSNEAR
                else -> NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_ALLSTOP
            }

            NetDEVSDK.NETDEV_PTZControl(liveHandle, ptzCommand, speed)
            NetDEVSDK.NETDEV_PTZControl(liveHandle, NetDEVSDK.NETDEV_VOD_PTZ_CMD_E.NETDEV_PTZ_ALLSTOP, speed)

            response.status = ResponseStatus.SUCCESS
            return response
        }

        companion object {
            const val LOG_TAG = "UniviewCamera"
            const val ZOOM_OUT = 0
            const val ZOOM_IN = 1

            const val PAN_UP = 2
            const val PAN_DOWN = 3
            const val PAN_LEFT = 4
            const val PAN_RIGHT = 5
            const val PAN_LEFT_UP = 6
            const val PAN_LEFT_DOWN = 7
            const val PAN_RIGHT_UP = 8
            const val PAN_RIGHT_DOWN = 9

            const val FOCUS_FAR = 10
            const val FOCUS_NEAR = 11

            const val ZOOM_SPEED = 6
            const val PAN_TILT_SPEED = 2
            const val FOCUS_SPEED = 6
        }

}