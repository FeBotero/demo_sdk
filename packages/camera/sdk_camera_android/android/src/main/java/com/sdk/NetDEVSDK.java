package com.sdk;

import java.util.ArrayList;

import com.sdk.AlarmCallBack_PF;

import android.view.Surface;


/**
 * The type Net devsdk.
 */
public class NetDEVSDK {
	static {
		System.loadLibrary("Curl");
		System.loadLibrary("RSA");
		System.loadLibrary("MP4");
		System.loadLibrary("MP2");
		System.loadLibrary("mXML");
		System.loadLibrary("NDRtmp");
		System.loadLibrary("CloudSDK");
		System.loadLibrary("RM_Module");
		System.loadLibrary("dspvideomjpeg");
		System.loadLibrary("NDPlayer");
		System.loadLibrary("Discovery");
        System.loadLibrary("NetDEVSDK");
        System.loadLibrary("NetDEVSDK_JNI");
    }

	/**
	 * The constant lpUserID.
	 */
//private OnNotifyListener mNotifyListener;
 	public static long lpUserID;       	/* User ID*/
	/**
	 * The constant gdwWinIndex.
	 */
	public static int gdwWinIndex;       	/* User ID*/
	/**
	 * The constant lpDownloadID.
	 */
	public static long lpDownloadID;      	/* Cloud ID*/
	/**
	 * The constant strDevName.
	 */
	public static String strDevName;
	/**
	 * The constant dwDeviceType.
	 */
	public static int dwDeviceType = 0;         /* 0 is NVR/IPC, 1 is VMS */
	/**
	 * The constant m_astVodFile.
	 */
	public static NETDEV_FINDDATA_S []m_astVodFile = new NETDEV_FINDDATA_S[1000];
	/**
	 * The constant gastLoginDeviceInfo.
	 */
	public static NETDEMO_DEV_LOGININFO_S gastLoginDeviceInfo = new NETDEMO_DEV_LOGININFO_S();
 	
	/**
	 * @enum tagNETDEVAlarmTypeEn
	 * @brief  Alarm Type Enumeration definition
	 * @attention None
	 */
	public class NETDEV_ALARM_TYPE_E
	{
		/**
		 * The constant NETDEV_ALARM_MOVE_DETECT.
		 */
		public static final int NETDEV_ALARM_MOVE_DETECT                = 1;        /* 运动检测告警  Motion detection alarm */
		/**
		 * The constant NETDEV_ALARM_MOVE_DETECT_RECOVER.
		 */
		public static final int NETDEV_ALARM_MOVE_DETECT_RECOVER        = 2;        /* 运动检测告警恢复  Motion detection alarm recover */
		/**
		 * The constant NETDEV_ALARM_VIDEO_LOST.
		 */
		public static final int NETDEV_ALARM_VIDEO_LOST                 = 3;        /* 视频丢失告警  Video loss alarm */
		/**
		 * The constant NETDEV_ALARM_VIDEO_LOST_RECOVER.
		 */
		public static final int NETDEV_ALARM_VIDEO_LOST_RECOVER         = 4;        /* 视频丢失告警恢复  Video loss alarm recover */
		/**
		 * The constant NETDEV_ALARM_VIDEO_TAMPER_DETECT.
		 */
		public static final int NETDEV_ALARM_VIDEO_TAMPER_DETECT        = 5;        /* 遮挡侦测告警  Tampering detection alarm */
		/**
		 * The constant NETDEV_ALARM_VIDEO_TAMPER_RECOVER.
		 */
		public static final int NETDEV_ALARM_VIDEO_TAMPER_RECOVER       = 6;        /* 遮挡侦测告警恢复  Tampering detection alarm recover */
		/**
		 * The constant NETDEV_ALARM_INPUT_SWITCH.
		 */
		public static final int NETDEV_ALARM_INPUT_SWITCH               = 7;        /* 输入开关量告警  boolean input alarm */
		/**
		 * The constant NETDEV_ALARM_INPUT_SWITCH_RECOVER.
		 */
		public static final int NETDEV_ALARM_INPUT_SWITCH_RECOVER       = 8;        /* 输入开关量告警恢复  Boolean input alarm recover */
		/**
		 * The constant NETDEV_ALARM_TEMPERATURE_HIGH.
		 */
		public static final int NETDEV_ALARM_TEMPERATURE_HIGH           = 9;        /* 高温告警  High temperature alarm */
		/**
		 * The constant NETDEV_ALARM_TEMPERATURE_LOW.
		 */
		public static final int NETDEV_ALARM_TEMPERATURE_LOW            = 10;       /* 低温告警  Low temperature alarm */
		/**
		 * The constant NETDEV_ALARM_TEMPERATURE_RECOVER.
		 */
		public static final int NETDEV_ALARM_TEMPERATURE_RECOVER        = 11;       /* 温度告警恢复  Temperature alarm recover */
		/**
		 * The constant NETDEV_ALARM_AUDIO_DETECT.
		 */
		public static final int NETDEV_ALARM_AUDIO_DETECT               = 12;       /* 音频异常检测告警  Audio detection alarm */
		/**
		 * The constant NETDEV_ALARM_AUDIO_DETECT_RECOVER.
		 */
		public static final int NETDEV_ALARM_AUDIO_DETECT_RECOVER       = 13;       /* 音频异常检测告警恢复  Audio detection alarm recover */
		/**
		 * The constant NETDEV_ALARM_SERVER_FAULT.
		 */
		public static final int NETDEV_ALARM_SERVER_FAULT               = 18;       /* 服务器故障 */
		/**
		 * The constant NETDEV_ALARM_SERVER_NORMAL.
		 */
		public static final int NETDEV_ALARM_SERVER_NORMAL              = 19;       /* 服务器故障恢复 */

		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_ONLINE.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_ONLINE          = 201;       /* 设备上线告警 */
		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_OFFLINE.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_OFFLINE         = 202;       /* 设备下线告警 */
		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_REBOOT.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_REBOOT          = 203;       /* 设备重启  Device restart */
		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_SERVICE_REBOOT.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_SERVICE_REBOOT  = 204;       /* 服务重启  Service restart */
		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_CHL_ONLINE.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_CHL_ONLINE      = 205;       /* 视频通道: 上线 */
		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_CHL_OFFLINE.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_CHL_OFFLINE     = 206;       /* 视频通道: 下线 */
		/**
		 * The constant NETDEV_ALARM_REPORT_DEV_DELETE_CHL.
		 */
		public static final int NETDEV_ALARM_REPORT_DEV_DELETE_CHL      = 207;       /* 视频通道: 删除 */

		/**
		 * The constant NETDEV_ALARM_NET_FAILED.
		 */
		public static final int NETDEV_ALARM_NET_FAILED                 = 401;      /* 会话网络错误 Network error */
		/**
		 * The constant NETDEV_ALARM_NET_TIMEOUT.
		 */
		public static final int NETDEV_ALARM_NET_TIMEOUT                = 402;      /* 会话网络超时 Network timeout */
		/**
		 * The constant NETDEV_ALARM_SHAKE_FAILED.
		 */
		public static final int NETDEV_ALARM_SHAKE_FAILED               = 403;      /* 会话交互错误 Interaction error */
		/**
		 * The constant NETDEV_ALARM_STREAMNUM_FULL.
		 */
		public static final int NETDEV_ALARM_STREAMNUM_FULL             = 404;      /* 流数已经满 Stream full */
		/**
		 * The constant NETDEV_ALARM_STREAM_THIRDSTOP.
		 */
		public static final int NETDEV_ALARM_STREAM_THIRDSTOP           = 405;      /* 第三方停止流 Third party stream stopped */
		/**
		 * The constant NETDEV_ALARM_FILE_END.
		 */
		public static final int NETDEV_ALARM_FILE_END                   = 406;      /* 文件结束 File ended */
		/**
		 * The constant NETDEV_ALARM_RTMP_CONNECT_FAIL.
		 */
		public static final int NETDEV_ALARM_RTMP_CONNECT_FAIL          = 407;      /* RTMP连接失败 */
		/**
		 * The constant NETDEV_ALARM_RTMP_INIT_FAIL.
		 */
		public static final int NETDEV_ALARM_RTMP_INIT_FAIL             = 408;      /* RTMP初始化失败*/
		/**
		 * The constant NETDEV_ALARM_STREAM_DOWNLOAD_OVER.
		 */
		public static final int NETDEV_ALARM_STREAM_DOWNLOAD_OVER       = 409;      /* 一体机国标流下载完成 */

		/**
		 * The constant NETDEV_ALARM_DISK_ERROR.
		 */
		public static final int NETDEV_ALARM_DISK_ERROR                         = 601;      /* 设备磁盘错误  Disk error */
		/**
		 * The constant NETDEV_ALARM_SYS_DISK_ERROR.
		 */
		public static final int NETDEV_ALARM_SYS_DISK_ERROR                     = 602;      /* 系统磁盘错误  Disk error */
		/**
		 * The constant NETDEV_ALARM_DISK_ONLINE.
		 */
		public static final int NETDEV_ALARM_DISK_ONLINE                        = 603;      /* 设备磁盘上线 Disk online */
		/**
		 * The constant NETDEV_ALARM_SYS_DISK_ONLINE.
		 */
		public static final int NETDEV_ALARM_SYS_DISK_ONLINE                    = 604;      /* 系统磁盘上线 Disk online */
		/**
		 * The constant NETDEV_ALARM_DISK_OFFLINE.
		 */
		public static final int NETDEV_ALARM_DISK_OFFLINE                       = 605;      /* 设备磁盘离线 */
		/**
		 * The constant NETDEV_ALARM_SYS_DISK_OFFLINE.
		 */
		public static final int NETDEV_ALARM_SYS_DISK_OFFLINE                   = 606;      /* 系统磁盘离线 */
		/**
		 * The constant NETDEV_ALARM_DISK_ABNORMAL.
		 */
		public static final int NETDEV_ALARM_DISK_ABNORMAL                      = 607;      /* 磁盘异常 Disk abnormal */
		/**
		 * The constant NETDEV_ALARM_DISK_ABNORMAL_RECOVER.
		 */
		public static final int NETDEV_ALARM_DISK_ABNORMAL_RECOVER              = 608;      /* 磁盘异常恢复 Disk abnormal recover */
		/**
		 * The constant NETDEV_ALARM_DISK_STORAGE_WILL_FULL.
		 */
		public static final int NETDEV_ALARM_DISK_STORAGE_WILL_FULL             = 609;      /* 磁盘存储空间即将满 Disk StorageGoingfull */
		/**
		 * The constant NETDEV_ALARM_DISK_STORAGE_WILL_FULL_RECOVER.
		 */
		public static final int NETDEV_ALARM_DISK_STORAGE_WILL_FULL_RECOVER     = 610;      /* 磁盘存储空间即将满恢复 Disk StorageGoingfull recover */
		/**
		 * The constant NETDEV_ALARM_DISK_STORAGE_IS_FULL.
		 */
		public static final int NETDEV_ALARM_DISK_STORAGE_IS_FULL               = 611;      /* 设备存储空间满 StorageIsfull */
		/**
		 * The constant NETDEV_ALARM_SYS_DISK_STORAGE_IS_FULL.
		 */
		public static final int NETDEV_ALARM_SYS_DISK_STORAGE_IS_FULL           = 612;      /* 系统存储空间满 StorageIsfull */
		/**
		 * The constant NETDEV_ALARM_DISK_STORAGE_IS_FULL_RECOVER.
		 */
		public static final int NETDEV_ALARM_DISK_STORAGE_IS_FULL_RECOVER       = 613;      /* 存储空间满恢复 StorageIsfull recover */
		/**
		 * The constant NETDEV_ALARM_DISK_RAID_DISABLED_RECOVER.
		 */
		public static final int NETDEV_ALARM_DISK_RAID_DISABLED_RECOVER         = 614;      /* 阵列损坏恢复 RAIDDisabled recover */
		/**
		 * The constant NETDEV_ALARM_DISK_RAID_DEGRADED.
		 */
		public static final int NETDEV_ALARM_DISK_RAID_DEGRADED                 = 615;      /* 设备阵列衰退 RAIDDegraded */
		/**
		 * The constant NETDEV_ALARM_SYS_DISK_RAID_DEGRADED.
		 */
		public static final int NETDEV_ALARM_SYS_DISK_RAID_DEGRADED             = 616;      /* 系统阵列衰退 RAIDDegraded */
		/**
		 * The constant NETDEV_ALARM_DISK_RAID_DISABLED.
		 */
		public static final int NETDEV_ALARM_DISK_RAID_DISABLED                 = 617;      /* 设备阵列损坏 RAIDDisabled */
		/**
		 * The constant NETDEV_ALARM_SYS_DISK_RAID_DISABLED.
		 */
		public static final int NETDEV_ALARM_SYS_DISK_RAID_DISABLED             = 618;      /* 系统阵列损坏 RAIDDisabled */
		/**
		 * The constant NETDEV_ALARM_DISK_RAID_DEGRADED_RECOVER.
		 */
		public static final int NETDEV_ALARM_DISK_RAID_DEGRADED_RECOVER         = 619;      /* 阵列衰退恢复 RAIDDegraded recover */
		/**
		 * The constant NETDEV_ALARM_STOR_GO_FULL.
		 */
		public static final int NETDEV_ALARM_STOR_GO_FULL                       = 620;      /* 设备存储即将满告警 */
		/**
		 * The constant NETDEV_ALARM_SYS_STOR_GO_FULL.
		 */
		public static final int NETDEV_ALARM_SYS_STOR_GO_FULL                   = 621;      /* 系统存储即将满告警 */
		/**
		 * The constant NETDEV_ALARM_ARRAY_NORMAL.
		 */
		public static final int NETDEV_ALARM_ARRAY_NORMAL                       = 622;      /* 设备阵列正常 */
		/**
		 * The constant NETDEV_ALARM_SYS_ARRAY_NORMAL.
		 */
		public static final int NETDEV_ALARM_SYS_ARRAY_NORMAL                   = 623;      /* 系统阵列正常 */
		/**
		 * The constant NETDEV_ALARM_DISK_RAID_RECOVERED.
		 */
		public static final int NETDEV_ALARM_DISK_RAID_RECOVERED                = 624;      /* 阵列恢复正常 RAIDDegraded */
		/**
		 * The constant NETDEV_ALARM_STOR_ERR.
		 */
		public static final int NETDEV_ALARM_STOR_ERR                           = 625;      /* 设备存储错误  Storage error */
		/**
		 * The constant NETDEV_ALARM_SYS_STOR_ERR.
		 */
		public static final int NETDEV_ALARM_SYS_STOR_ERR                       = 626;      /* 系统存储错误  Storage error */
		/**
		 * The constant NETDEV_ALARM_STOR_ERR_RECOVER.
		 */
		public static final int NETDEV_ALARM_STOR_ERR_RECOVER                   = 627;      /* 存储错误恢复  Storage error recover */
		/**
		 * The constant NETDEV_ALARM_STOR_DISOBEY_PLAN.
		 */
		public static final int NETDEV_ALARM_STOR_DISOBEY_PLAN                  = 628;      /* 未按计划存储  Not stored as planned */
		/**
		 * The constant NETDEV_ALARM_STOR_DISOBEY_PLAN_RECOVER.
		 */
		public static final int NETDEV_ALARM_STOR_DISOBEY_PLAN_RECOVER          = 629;      /* 未按计划存储恢复  Not stored as planned recover */

		/**
		 * The constant NETDEV_ALARM_BANDWITH_CHANGE.
		 */
		public static final int NETDEV_ALARM_BANDWITH_CHANGE                    = 801;      /* 设备出口带宽变更 */
		/**
		 * The constant NETDEV_ALARM_VIDEOENCODER_CHANGE.
		 */
		public static final int NETDEV_ALARM_VIDEOENCODER_CHANGE                = 802;      /* 设备码流配置变更告警 */
		/**
		 * The constant NETDEV_ALARM_IP_CONFLICT.
		 */
		public static final int NETDEV_ALARM_IP_CONFLICT                        = 803;      /* IP冲突异常告警 IP conflict exception alarm*/
		/**
		 * The constant NETDEV_ALARM_IP_CONFLICT_CLEARED.
		 */
		public static final int NETDEV_ALARM_IP_CONFLICT_CLEARED                = 804;      /* IP冲突异常告警恢复IP conflict exception alarm recovery */
		/**
		 * The constant NETDEV_ALARM_NET_OFF.
		 */
		public static final int NETDEV_ALARM_NET_OFF                            = 805;      /* 网络断开异常告警 */
		/**
		 * The constant NETDEV_ALARM_NET_RESUME_ON.
		 */
		public static final int NETDEV_ALARM_NET_RESUME_ON                      = 806;      /* 网络断开恢复告警 */

		/**
		 * The constant NETDEV_ALARM_ILLEGAL_ACCESS.
		 */
		public static final int NETDEV_ALARM_ILLEGAL_ACCESS                     = 1001;          /* 设备非法访问  Illegal access */
		/**
		 * The constant NETDEV_ALARM_SYS_ILLEGAL_ACCESS.
		 */
		public static final int NETDEV_ALARM_SYS_ILLEGAL_ACCESS                 = 1002;          /* 系统非法访问  Illegal access */
		/**
		 * The constant NETDEV_ALARM_LINE_CROSS.
		 */
		public static final int NETDEV_ALARM_LINE_CROSS                         = 1003;          /* 越界告警  Line cross */
		/**
		 * The constant NETDEV_ALARM_OBJECTS_INSIDE.
		 */
		public static final int NETDEV_ALARM_OBJECTS_INSIDE                     = 1004;          /* 区域入侵  Objects inside */
		/**
		 * The constant NETDEV_ALARM_FACE_RECOGNIZE.
		 */
		public static final int NETDEV_ALARM_FACE_RECOGNIZE                     = 1005;          /* 人脸识别  Face recognize */
		/**
		 * The constant NETDEV_ALARM_IMAGE_BLURRY.
		 */
		public static final int NETDEV_ALARM_IMAGE_BLURRY                       = 1006;          /* 图像虚焦  Image blurry */
		/**
		 * The constant NETDEV_ALARM_SCENE_CHANGE.
		 */
		public static final int NETDEV_ALARM_SCENE_CHANGE                       = 1007;          /* 场景变更  Scene change */
		/**
		 * The constant NETDEV_ALARM_SMART_TRACK.
		 */
		public static final int NETDEV_ALARM_SMART_TRACK                        = 1008;          /* 智能跟踪  Smart track */
		/**
		 * The constant NETDEV_ALARM_LOITERING_DETECTOR.
		 */
		public static final int NETDEV_ALARM_LOITERING_DETECTOR                 = 1009;          /* 徘徊检测  Loitering Detector */
		/**
		 * The constant NETDEV_ALARM_BANDWIDTH_CHANGE.
		 */
		public static final int NETDEV_ALARM_BANDWIDTH_CHANGE                   = 1010;          /* 带宽变更  Bandwidth change */
		/**
		 * The constant NETDEV_ALARM_ALLTIME_FLAG_END.
		 */
		public static final int NETDEV_ALARM_ALLTIME_FLAG_END                   = 1011;          /* 无布防告警结束标记  End marker of alarm without arming schedule */
		/**
		 * The constant NETDEV_ALARM_MEDIA_CONFIG_CHANGE.
		 */
		public static final int NETDEV_ALARM_MEDIA_CONFIG_CHANGE                = 1012;          /* 编码参数变更 media configurationchanged */
		/**
		 * The constant NETDEV_ALARM_REMAIN_ARTICLE.
		 */
		public static final int NETDEV_ALARM_REMAIN_ARTICLE                     = 1013;          /*物品遗留告警  Remain article*/
		/**
		 * The constant NETDEV_ALARM_PEOPLE_GATHER.
		 */
		public static final int NETDEV_ALARM_PEOPLE_GATHER                      = 1014;          /* 人员聚集告警 People gather alarm*/
		/**
		 * The constant NETDEV_ALARM_ENTER_AREA.
		 */
		public static final int NETDEV_ALARM_ENTER_AREA                         = 1015;          /* 进入区域 Enter area*/
		/**
		 * The constant NETDEV_ALARM_LEAVE_AREA.
		 */
		public static final int NETDEV_ALARM_LEAVE_AREA                         = 1016;          /* 离开区域 Leave area*/
		/**
		 * The constant NETDEV_ALARM_ARTICLE_MOVE.
		 */
		public static final int NETDEV_ALARM_ARTICLE_MOVE                       = 1017;          /* 物品搬移 Article move*/
		/**
		 * The constant NETDEV_ALARM_SMART_FACE_MATCH_LIST.
		 */
		public static final int NETDEV_ALARM_SMART_FACE_MATCH_LIST                  = 1018;       /* 人脸识别黑名单报警 */
		/**
		 * The constant NETDEV_ALARM_SMART_FACE_MATCH_LIST_RECOVER.
		 */
		public static final int NETDEV_ALARM_SMART_FACE_MATCH_LIST_RECOVER          = 1019;       /* 人脸识别黑名单报警恢复 */
		/**
		 * The constant NETDEV_ALARM_SMART_FACE_MISMATCH_LIST.
		 */
		public static final int NETDEV_ALARM_SMART_FACE_MISMATCH_LIST               = 1020;       /* 人脸识别不匹配报警 */
		/**
		 * The constant NETDEV_ALARM_SMART_FACE_MISMATCH_LIST_RECOVER.
		 */
		public static final int NETDEV_ALARM_SMART_FACE_MISMATCH_LIST_RECOVER       = 1021;       /* 人脸识别不匹配报警恢复 */
		/**
		 * The constant NETDEV_ALARM_SMART_VEHICLE_MATCH_LIST.
		 */
		public static final int NETDEV_ALARM_SMART_VEHICLE_MATCH_LIST               = 1022;       /* 车辆识别匹配报警 */
		/**
		 * The constant NETDEV_ALARM_SMART_VEHICLE_MATCH_LIST_RECOVER.
		 */
		public static final int NETDEV_ALARM_SMART_VEHICLE_MATCH_LIST_RECOVER       = 1023;       /* 车辆识别匹配报警恢复 */
		/**
		 * The constant NETDEV_ALARM_SMART_VEHICLE_MISMATCH_LIST.
		 */
		public static final int NETDEV_ALARM_SMART_VEHICLE_MISMATCH_LIST            = 1024;       /* 车辆识别不匹配报警 */
		/**
		 * The constant NETDEV_ALARM_SMART_VEHICLE_MISMATCH_LIST_RECOVER.
		 */
		public static final int NETDEV_ALARM_SMART_VEHICLE_MISMATCH_LIST_RECOVER    = 1025;       /* 车辆识别不匹配报警回复 */
		/**
		 * The constant NETDEV_ALARM_IMAGE_BLURRY_RECOVER.
		 */
		public static final int NETDEV_ALARM_IMAGE_BLURRY_RECOVER               = 1026;         /* 图像虚焦告警恢复  Image blurry recover */
		/**
		 * The constant NETDEV_ALARM_SMART_TRACK_RECOVER.
		 */
		public static final int NETDEV_ALARM_SMART_TRACK_RECOVER                = 1027;         /* 智能跟踪告警恢复  Smart track recover */
		/**
		 * The constant NETDEV_ALARM_SMART_READ_ERROR_RATE.
		 */
		public static final int NETDEV_ALARM_SMART_READ_ERROR_RATE              = 1028;         /* 底层数据读取错误率Error reding the underlying data */
		/**
		 * The constant NETDEV_ALARM_SMART_SPIN_UP_TIME.
		 */
		public static final int NETDEV_ALARM_SMART_SPIN_UP_TIME                 = 1029;         /* 主轴起旋时间  Rotation time of spindle */
		/**
		 * The constant NETDEV_ALARM_SMART_START_STOP_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_START_STOP_COUNT             = 1030;         /* 启停计数 Rev. Stop counting*/
		/**
		 * The constant NETDEV_ALARM_SMART_REALLOCATED_SECTOR_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_REALLOCATED_SECTOR_COUNT     = 1031;         /* 重映射扇区计数  Remap sector count*/
		/**
		 * The constant NETDEV_ALARM_SMART_SEEK_ERROR_RATE.
		 */
		public static final int NETDEV_ALARM_SMART_SEEK_ERROR_RATE              = 1032;         /* 寻道错误率 Trace error rate*/
		/**
		 * The constant NETDEV_ALARM_SMART_POWER_ON_HOURS.
		 */
		public static final int NETDEV_ALARM_SMART_POWER_ON_HOURS               = 1033;         /* 通电时间累计，出厂后通电的总时间，一般磁盘寿命三万小时 */
		/**
		 * The constant NETDEV_ALARM_SMART_SPIN_RETRY_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_SPIN_RETRY_COUNT             = 1034;         /* 主轴起旋重试次数 */
		/**
		 * The constant NETDEV_ALARM_SMART_CALIBRATION_RETRY_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_CALIBRATION_RETRY_COUNT      = 1035;         /* 磁头校准重试计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_POWER_CYCLE_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_POWER_CYCLE_COUNT            = 1036;         /* 通电周期计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_POWEROFF_RETRACT_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_POWEROFF_RETRACT_COUNT       = 1037;         /* 断电返回计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_LOAD_CYCLE_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_LOAD_CYCLE_COUNT             = 1038;         /* 磁头加载计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_TEMPERATURE_CELSIUS.
		 */
		public static final int NETDEV_ALARM_SMART_TEMPERATURE_CELSIUS          = 1039;         /* 温度 */
		/**
		 * The constant NETDEV_ALARM_SMART_REALLOCATED_EVENT_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_REALLOCATED_EVENT_COUNT      = 1040;         /* 重映射事件计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_CURRENT_PENDING_SECTOR.
		 */
		public static final int NETDEV_ALARM_SMART_CURRENT_PENDING_SECTOR       = 1041;         /* 当前待映射扇区计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_OFFLINE_UNCORRECTABLE.
		 */
		public static final int NETDEV_ALARM_SMART_OFFLINE_UNCORRECTABLE        = 1042;         /* 脱机无法校正的扇区计数 */
		/**
		 * The constant NETDEV_ALARM_SMART_UDMA_CRC_ERROR_COUNT.
		 */
		public static final int NETDEV_ALARM_SMART_UDMA_CRC_ERROR_COUNT         = 1043;         /* 奇偶校验错误率  */
		/**
		 * The constant NETDEV_ALARM_SMART_MULTI_ZONE_ERROR_RATE.
		 */
		public static final int NETDEV_ALARM_SMART_MULTI_ZONE_ERROR_RATE        = 1044;         /* 多区域错误率 */
		/**
		 * The constant NETDEV_ALARM_RESOLUTION_CHANGE.
		 */
		public static final int NETDEV_ALARM_RESOLUTION_CHANGE                  = 1045;         /* 分辨率变更 */
		/**
		 * The constant NETDEV_ALARM_MANUAL.
		 */
		public static final int NETDEV_ALARM_MANUAL                             = 1401;         /* 手动告警 */
		/**
		 * The constant NETDEV_ALARM_ALARMHOST_COMMON.
		 */
		public static final int NETDEV_ALARM_ALARMHOST_COMMON                   = 1402;         /* 报警点事件 */
		/**
		 * The constant NETDEV_ALARM_DOORHOST_COMMON.
		 */
		public static final int NETDEV_ALARM_DOORHOST_COMMON                    = 1403;         /* 门禁事件 */
		/**
		 * The constant NETDEV_ALARM_FACE_NOT_MATCH.
		 */
		public static final int NETDEV_ALARM_FACE_NOT_MATCH                     = 1411;         /* 人脸对比失败 */
		/**
		 * The constant NETDEV_ALARM_FACE_MATCH_SUCCEED.
		 */
		public static final int NETDEV_ALARM_FACE_MATCH_SUCCEED                 = 1412;         /* 人脸对比成功 */

		/**
		 * The constant NETDEV_ALARM_VEHICLE_BLACK_LIST.
		 */
		public static final int NETDEV_ALARM_VEHICLE_BLACK_LIST                 = 1420;         /* 车辆识别黑名单报警 */


		/**
		 * The constant NETDEV_ALARM_CLOUD_DOWNLOAD_FINISH.
		 */
		/*  Cloud media view exception report 2793~2809 */
		public static final int NETDEV_ALARM_CLOUD_DOWNLOAD_FINISH              = 2793;         /* 下载完成 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_PARSE_DOMAIN_FAIL.
		 */
		public static final int NETDEV_ALARM_CLOUD_PARSE_DOMAIN_FAIL            = 2794;         /* 解析域名失败 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_CONNECT_FAIL.
		 */
		public static final int NETDEV_ALARM_CLOUD_CONNECT_FAIL                 = 2795;         /* 连接失败 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_CONNECT_TIMEOUT.
		 */
		public static final int NETDEV_ALARM_CLOUD_CONNECT_TIMEOUT              = 2796;         /* 连接超时 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_DOWNLOAD_TIMEOUT.
		 */
		public static final int NETDEV_ALARM_CLOUD_DOWNLOAD_TIMEOUT             = 2797;         /* 下载超时 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_DOWNLOAD_FAIL.
		 */
		public static final int NETDEV_ALARM_CLOUD_DOWNLOAD_FAIL                = 2798;         /* 下载失败 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_NETWORK_POOR.
		 */
		public static final int NETDEV_ALARM_CLOUD_NETWORK_POOR                 = 2799;         /* 网络较差 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_PLAY_FINISH.
		 */
		public static final int NETDEV_ALARM_CLOUD_PLAY_FINISH                  = 2800;         /* 播放完成 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_DISK_FULL.
		 */
		public static final int NETDEV_ALARM_CLOUD_DISK_FULL                    = 2801;         /* 磁盘空间满 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_AUTH_FAIL.
		 */
		public static final int NETDEV_ALARM_CLOUD_AUTH_FAIL                    = 2802;         /* 鉴权失败 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_CURRENT_TIME.
		 */
		public static final int NETDEV_ALARM_CLOUD_CURRENT_TIME                 = 2803;         /* 当前播放时间，仅用于上报 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_PRIOR_DISK_FULL.
		 */
		public static final int NETDEV_ALARM_CLOUD_PRIOR_DISK_FULL              = 2804;         /* 磁盘预值满 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_NODE_NOT_EXIST.
		 */
		public static final int NETDEV_ALARM_CLOUD_NODE_NOT_EXIST               = 2805;         /* 时间节点不存在 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_NO_CACHE_PATH.
		 */
		public static final int NETDEV_ALARM_CLOUD_NO_CACHE_PATH                = 2806;         /* 未设置缓存路径 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_MSG_SEND_FAIL.
		 */
		public static final int NETDEV_ALARM_CLOUD_MSG_SEND_FAIL                = 2807;         /* 消息发送失败 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_TASK_CANCELLED.
		 */
		public static final int NETDEV_ALARM_CLOUD_TASK_CANCELLED               = 2808;         /* 任务已取消 */
		/**
		 * The constant NETDEV_ALARM_CLOUD_TASK_STREAM_CONTINUE.
		 */
		public static final int NETDEV_ALARM_CLOUD_TASK_STREAM_CONTINUE         = 2809;         /* 流继续播放 */

		/**
		 * The constant NETDEV_ALARM_INVALID.
		 */
		public static final int NETDEV_ALARM_INVALID                            = 0xFFFF;      /* 无效值  Invalid value */
	}

	/**
	 * @enum tagNETDEVVodPlayStatus
	 * @brief Playback and download status Enumeration definition
	 * @attention None
	 */
	public class NETDEV_VOD_PLAY_STATUS_E{
		/**
		 * The constant NETDEV_PLAY_STATUS_16_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_16_BACKWARD          = 0;            /*   Backward at 16x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_8_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_8_BACKWARD           = 1;            /*   Backward at 8x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_4_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_4_BACKWARD           = 2;            /*   Backward at 4x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_2_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_2_BACKWARD           = 3;            /*   Backward at 2x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_1_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_1_BACKWARD           = 4;            /*   Backward at normal speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_HALF_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_HALF_BACKWARD        = 5;            /*   Backward at 1/2 speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_QUARTER_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_QUARTER_BACKWARD     = 6;            /*   Backward at 1/4 speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_QUARTER_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_QUARTER_FORWARD      = 7;            /*   Play at 1/4 speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_HALF_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_HALF_FORWARD         = 8;            /*   Play at 1/2 speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_1_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_1_FORWARD            = 9;            /*   Forward at normal speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_2_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_2_FORWARD            = 10;           /*   Forward at 2x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_4_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_4_FORWARD            = 11;           /*   Forward at 4x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_8_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_8_FORWARD            = 12;           /*   Forward at 8x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_16_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_16_FORWARD           = 13;           /*   Forward at 16x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_2_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_2_FORWARD_IFRAME     = 14;           /* Forward at 2x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_4_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_4_FORWARD_IFRAME     = 15;           /*  Forward at 4x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_8_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_8_FORWARD_IFRAME     = 16;           /*  Forward at 8x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_16_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_16_FORWARD_IFRAME    = 17;           /*  Forward at 16x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_2_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_2_BACKWARD_IFRAME    = 18;           /*  Backward at 2x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_4_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_4_BACKWARD_IFRAME    = 19;           /*  Backward at 4x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_8_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_8_BACKWARD_IFRAME    = 20;           /*  Backward at 8x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_16_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_16_BACKWARD_IFRAME   = 21;           /* Backward at 16x speed(I frame) */
		/**
		 * The constant NETDEV_PLAY_STATUS_INTELLIGENT_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_INTELLIGENT_FORWARD  = 22;           /*  Intelligent forward */
		/**
		 * The constant NETDEV_PLAY_STATUS_1_FRAME_FORWD.
		 */
		public static final int NETDEV_PLAY_STATUS_1_FRAME_FORWD        = 23;           /*   Forward at 1 frame speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_1_FRAME_BACK.
		 */
		public static final int NETDEV_PLAY_STATUS_1_FRAME_BACK         = 24;           /*  Backward at 1 frame speed */

		/**
		 * The constant NETDEV_PLAY_STATUS_40_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_40_FORWARD           = 25;           /*  Forward at 40x speed*/

		/**
		 * The constant NETDEV_PLAY_STATUS_32_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_32_FORWARD_IFRAME    = 26;          /*  Forward at 32x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_32_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_32_BACKWARD_IFRAME   = 27;           /*  Backward at 32x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_64_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_64_FORWARD_IFRAME    = 28;           /*  Forward at 64x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_64_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_64_BACKWARD_IFRAME   = 29;           /*  Backward at 64x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_128_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_128_FORWARD_IFRAME   = 30;           /*  Forward at 128x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_128_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_128_BACKWARD_IFRAME  = 31;           /*  Backward at 128x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_256_FORWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_256_FORWARD_IFRAME   = 32;           /* Forward at 256x speed(I frame)*/
		/**
		 * The constant NETDEV_PLAY_STATUS_256_BACKWARD_IFRAME.
		 */
		public static final int NETDEV_PLAY_STATUS_256_BACKWARD_IFRAME  = 33;           /* Backward at 256x speed(I frame)*/

		/**
		 * The constant NETDEV_PLAY_STATUS_32_FORWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_32_FORWARD           = 34;           /* Forward at 32x speed */
		/**
		 * The constant NETDEV_PLAY_STATUS_32_BACKWARD.
		 */
		public static final int NETDEV_PLAY_STATUS_32_BACKWARD          = 35;           /* Backward at 32x speed */
	}

 	/**
 	 * @enum tagNETDEVPlayControl
 	 * @brief Playback control commands Enumeration definition
 	 * @attention  None
 	 */
 	public class NETDEV_VOD_PLAY_CTRL_E{
		/**
		 * The constant NETDEV_PLAY_CTRL_PLAY.
		 */
		public static final int NETDEV_PLAY_CTRL_PLAY           = 0;           	/* Play */
		/**
		 * The constant NETDEV_PLAY_CTRL_PAUSE.
		 */
		public static final int NETDEV_PLAY_CTRL_PAUSE          = 1;           	/* Pause */
		/**
		 * The constant NETDEV_PLAY_CTRL_RESUME.
		 */
		public static final int NETDEV_PLAY_CTRL_RESUME         = 2;          	/* Resume */
		/**
		 * The constant NETDEV_PLAY_CTRL_GETPLAYTIME.
		 */
		public static final int NETDEV_PLAY_CTRL_GETPLAYTIME    = 3;           	/* Obtain playing time */
		/**
		 * The constant NETDEV_PLAY_CTRL_SETPLAYTIME.
		 */
		public static final int NETDEV_PLAY_CTRL_SETPLAYTIME    = 4;           	/* Configure playing time */
		/**
		 * The constant NETDEV_PLAY_CTRL_GETPLAYSPEED.
		 */
		public static final int NETDEV_PLAY_CTRL_GETPLAYSPEED   = 5;          	/* Obtain playing speed */
		/**
		 * The constant NETDEV_PLAY_CTRL_SETPLAYSPEED.
		 */
		public static final int NETDEV_PLAY_CTRL_SETPLAYSPEED   = 6;        	/* Configure playing speed */
 	}

	/**
	 * The type Netdev vod ptz cmd e.
	 */
	public class NETDEV_VOD_PTZ_CMD_E
 	{
		/**
		 * The constant NETDEV_PTZ_FOCUSNEAR_STOP.
		 */
		public static final int NETDEV_PTZ_FOCUSNEAR_STOP       = 0x0201;       	/* Focus near stop */
		/**
		 * The constant NETDEV_PTZ_FOCUSNEAR.
		 */
		public static final int NETDEV_PTZ_FOCUSNEAR            = 0x0202;       	/* Focus near */
		/**
		 * The constant NETDEV_PTZ_FOCUSFAR_STOP.
		 */
		public static final int NETDEV_PTZ_FOCUSFAR_STOP        = 0x0203;       	/* Focus far stop */
		/**
		 * The constant NETDEV_PTZ_FOCUSFAR.
		 */
		public static final int NETDEV_PTZ_FOCUSFAR             = 0x0204;       	/* Focus far */
		/**
		 * The constant NETDEV_PTZ_ZOOMTELE.
		 */
		public static final int NETDEV_PTZ_ZOOMTELE             = 0x0302;       	/* Zoom in */
		/**
		 * The constant NETDEV_PTZ_ZOOMWIDE.
		 */
		public static final int NETDEV_PTZ_ZOOMWIDE             = 0x0304;       	/* Zoom out */
		/**
		 * The constant NETDEV_PTZ_TILTUP.
		 */
		public static final int NETDEV_PTZ_TILTUP               = 0x0402;       	/* Tilt up */
		/**
		 * The constant NETDEV_PTZ_TILTDOWN.
		 */
		public static final int NETDEV_PTZ_TILTDOWN             = 0x0404;       	/* ilt down */
		/**
		 * The constant NETDEV_PTZ_PANRIGHT.
		 */
		public static final int NETDEV_PTZ_PANRIGHT             = 0x0502;       	/* Pan right */
		/**
		 * The constant NETDEV_PTZ_PANLEFT.
		 */
		public static final int NETDEV_PTZ_PANLEFT              = 0x0504;      		/* Pan left */
		/**
		 * The constant NETDEV_PTZ_LEFTUP.
		 */
		public static final int NETDEV_PTZ_LEFTUP               = 0x0702;       	/* Move up left */
		/**
		 * The constant NETDEV_PTZ_LEFTDOWN.
		 */
		public static final int NETDEV_PTZ_LEFTDOWN             = 0x0704;       	/* Move down left */
		/**
		 * The constant NETDEV_PTZ_RIGHTUP.
		 */
		public static final int NETDEV_PTZ_RIGHTUP              = 0x0802;       	/* Move up right */
		/**
		 * The constant NETDEV_PTZ_RIGHTDOWN.
		 */
		public static final int NETDEV_PTZ_RIGHTDOWN            = 0x0804;       	/* Move down right */
		/**
		 * The constant NETDEV_PTZ_ALLSTOP.
		 */
		public static final int NETDEV_PTZ_ALLSTOP              = 0x0901;       	/* All-stop command word */
 	}

	/**
	 * The type Netdev time zone e.
	 */
	public class NETDEV_TIME_ZONE_E
	{
		/**
		 * The constant NETDEV_TIME_ZONE_W1200.
		 */
		public static final int NETDEV_TIME_ZONE_W1200 = 0;              /* W12 */
		/**
		 * The constant NETDEV_TIME_ZONE_W1100.
		 */
		public static final int NETDEV_TIME_ZONE_W1100 = 1;              /* W11 */
		/**
		 * The constant NETDEV_TIME_ZONE_W1000.
		 */
		public static final int NETDEV_TIME_ZONE_W1000 = 2;              /* W10 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0900.
		 */
		public static final int NETDEV_TIME_ZONE_W0900 = 3;              /* W9 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0800.
		 */
		public static final int NETDEV_TIME_ZONE_W0800 = 4;              /* W8 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0700.
		 */
		public static final int NETDEV_TIME_ZONE_W0700 = 5;              /* W7 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0600.
		 */
		public static final int NETDEV_TIME_ZONE_W0600 = 6;              /* W6 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0500.
		 */
		public static final int NETDEV_TIME_ZONE_W0500 = 7;              /* W5 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0430.
		 */
		public static final int NETDEV_TIME_ZONE_W0430 = 8;              /* W4:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0400.
		 */
		public static final int NETDEV_TIME_ZONE_W0400 = 9;              /* W4 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0330.
		 */
		public static final int NETDEV_TIME_ZONE_W0330 = 10;             /* W3:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0300.
		 */
		public static final int NETDEV_TIME_ZONE_W0300 = 11;             /* W3 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0200.
		 */
		public static final int NETDEV_TIME_ZONE_W0200 = 12;             /* W2 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0100.
		 */
		public static final int NETDEV_TIME_ZONE_W0100 = 13;             /* W1 */
		/**
		 * The constant NETDEV_TIME_ZONE_0000.
		 */
		public static final int NETDEV_TIME_ZONE_0000  = 14;             /* W0 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0100.
		 */
		public static final int NETDEV_TIME_ZONE_E0100 = 15;             /* E1 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0200.
		 */
		public static final int NETDEV_TIME_ZONE_E0200 = 16;             /* E2 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0300.
		 */
		public static final int NETDEV_TIME_ZONE_E0300 = 17;             /* E3 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0330.
		 */
		public static final int NETDEV_TIME_ZONE_E0330 = 18;             /* E3:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0400.
		 */
		public static final int NETDEV_TIME_ZONE_E0400 = 19;             /* E4 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0430.
		 */
		public static final int NETDEV_TIME_ZONE_E0430 = 20;             /* E4:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0500.
		 */
		public static final int NETDEV_TIME_ZONE_E0500 = 21;             /* E5 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0530.
		 */
		public static final int NETDEV_TIME_ZONE_E0530 = 22;             /* E5:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0545.
		 */
		public static final int NETDEV_TIME_ZONE_E0545 = 23;             /* E5:45 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0600.
		 */
		public static final int NETDEV_TIME_ZONE_E0600 = 24;             /* E6 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0630.
		 */
		public static final int NETDEV_TIME_ZONE_E0630 = 25;             /* E6:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0700.
		 */
		public static final int NETDEV_TIME_ZONE_E0700 = 26;             /* E7 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0800.
		 */
		public static final int NETDEV_TIME_ZONE_E0800 = 27;             /* E8 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0900.
		 */
		public static final int NETDEV_TIME_ZONE_E0900 = 28;             /* E9 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0930.
		 */
		public static final int NETDEV_TIME_ZONE_E0930 = 29;             /* E9:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1000.
		 */
		public static final int NETDEV_TIME_ZONE_E1000 = 30;             /* E10 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1100.
		 */
		public static final int NETDEV_TIME_ZONE_E1100 = 31;             /* E11 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1200.
		 */
		public static final int NETDEV_TIME_ZONE_E1200 = 32;             /* E12 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1300.
		 */
		public static final int NETDEV_TIME_ZONE_E1300 = 33;             /* E13 */
		/**
		 * The constant NETDEV_TIME_ZONE_W0930.
		 */
		public static final int NETDEV_TIME_ZONE_W0930 = 34;              /* W9:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0830.
		 */
		public static final int NETDEV_TIME_ZONE_E0830 = 35;             /* E8:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E0845.
		 */
		public static final int NETDEV_TIME_ZONE_E0845 = 36;             /* E8:45 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1030.
		 */
		public static final int NETDEV_TIME_ZONE_E1030 = 37;             /* E10:30 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1245.
		 */
		public static final int NETDEV_TIME_ZONE_E1245 = 38;             /* E12:45 */
		/**
		 * The constant NETDEV_TIME_ZONE_E1400.
		 */
		public static final int NETDEV_TIME_ZONE_E1400 = 39;             /* E14 */

		/**
		 * The constant NETDEV_TIME_ZONE_INVALID.
		 */
		public static final int NETDEV_TIME_ZONE_INVALID = 0xFF;         /* Invalid value */
	}

	/**
	 * The type Netdev plan store type e.
	 */
	/* Recording storage type */
	public class NETDEV_PLAN_STORE_TYPE_E
	{
		/**
		 * The constant NETDEV_TYPE_STORE_TYPE_ALL.
		 */
		public static final int NETDEV_TYPE_STORE_TYPE_ALL                  = 0;            /* All */

		/**
		 * The constant NETDEV_EVENT_STORE_TYPE_MOTIONDETECTION.
		 */
		public static final int NETDEV_EVENT_STORE_TYPE_MOTIONDETECTION     = 4;            /*   Motion detection */
		/**
		 * The constant NETDEV_EVENT_STORE_TYPE_DIGITALINPUT.
		 */
		public static final int NETDEV_EVENT_STORE_TYPE_DIGITALINPUT        = 5;            /*   Digital input */
		/**
		 * The constant NETDEV_EVENT_STORE_TYPE_VIDEOLOSS.
		 */
		public static final int NETDEV_EVENT_STORE_TYPE_VIDEOLOSS           = 7;            /*   Video loss */

		/**
		 * The constant NETDEV_TYPE_STORE_TYPE_INVALID.
		 */
		public static final int NETDEV_TYPE_STORE_TYPE_INVALID              = 0xFF;         /*  Invalid value */
	}

	/**
	 * The type Netdev config command e.
	 */
	public class NETDEV_CONFIG_COMMAND_E
	{
		/**
		 * The constant NETDEV_GET_OSDCFG.
		 */
		public static final int NETDEV_GET_OSDCFG    = 140;		/* 获取OSD配置信息,参见#NETDEV_VIDEO_OSD_CFG_S  Get OSD configuration information, see #NETDEV_VIDEO_OSD_CFG_S */
		/**
		 * The constant NETDEV_SET_OSDCFG.
		 */
		public static final int NETDEV_SET_OSDCFG    = 141;		/* 设置OSD配置信息,参见#NETDEV_VIDEO_OSD_CFG_S  Set OSD configuration information, see #NETDEV_VIDEO_OSD_CFG_S */
	}

	/**
	 * The type Netdev dst offset time.
	 */
	public class NETDEV_DST_OFFSET_TIME {
		/**
		 * The constant NETDEV_DST_OFFSET_TIME_30MIN.
		 */
		public static final int NETDEV_DST_OFFSET_TIME_30MIN                 = 30;          /* 30分钟  30Minutes */
		/**
		 * The constant NETDEV_DST_OFFSET_TIME_60MIN.
		 */
		public static final int NETDEV_DST_OFFSET_TIME_60MIN                 = 60;          /* 60分钟  60Minutes */
		/**
		 * The constant NETDEV_DST_OFFSET_TIME_90MIN.
		 */
		public static final int NETDEV_DST_OFFSET_TIME_90MIN                 = 90;          /* 90分钟  90Minutes */
		/**
		 * The constant NETDEV_DST_OFFSET_TIME_120MIN.
		 */
		public static final int NETDEV_DST_OFFSET_TIME_120MIN                = 120;         /* 120分钟  120Minutes */
		/**
		 * The constant NETDEV_DST_OFFSET_TIME_INVALID.
		 */
		public static final int NETDEV_DST_OFFSET_TIME_INVALID               = 0xff;         /* 无效值 Invalid value */
	}


	/**
	 * The type Netdev day in week e.
	 */
	public class NETDEV_DAY_IN_WEEK_E {
		/**
		 * The constant NETDEV_WEEK_SUNDAY.
		 */
		public static final int NETDEV_WEEK_SUNDAY                  = 0;                  /* 星期日  Sunday */
		/**
		 * The constant NETDEV_WEEK_MONDAY.
		 */
		public static final int NETDEV_WEEK_MONDAY                  = 1;                  /* 星期一  Monday */
		/**
		 * The constant NETDEV_WEEK_TUESDAY.
		 */
		public static final int NETDEV_WEEK_TUESDAY                 = 2;                  /* 星期二  Tuesday */
		/**
		 * The constant NETDEV_WEEK_WEDNESDAY.
		 */
		public static final int NETDEV_WEEK_WEDNESDAY               = 3;                  /* 星期三  Wednesday */
		/**
		 * The constant NETDEV_WEEK_THURSDAY.
		 */
		public static final int NETDEV_WEEK_THURSDAY                = 4;                  /* 星期四  Thursday */
		/**
		 * The constant NETDEV_WEEK_FRIDAY.
		 */
		public static final int NETDEV_WEEK_FRIDAY                  = 5;                  /* 星期五  Friday */
		/**
		 * The constant NETDEV_WEEK_SATURDAY.
		 */
		public static final int NETDEV_WEEK_SATURDAY                = 6;                  /* 星期六  Saturday */
		/**
		 * The constant NETDEV_WEEK_INVALID.
		 */
		public static final int NETDEV_WEEK_INVALID               = 0xff;                 /* 无效值 Invalid value */
	}

	/**
	 * The Pf alarm call back.
	 */
	static AlarmCallBack_PF pfAlarmCallBack;
	/**
	 * The Pf exception call back.
	 */
	static ExceptionCallBack_PF pfExceptionCallBack;
	/**
	 * The Pf decode audio call back.
	 */
	static DecodeAudioCallBack_PF pfDecodeAudioCallBack = null;
	/**
	 * The Pf alarm call back v 30.
	 */
	static AlarmMessCallBackV30  pfAlarmCallBackV30;
	/**
	 * The Struct alarm mess data cb.
	 */
	static StructAlarmMessCallBack structAlarmMessDataCB;
	/**
	 * The Pf decode audio data cb.
	 */
	static NETDEV_DECODE_AUDIO_DATA_CALLBACK_PF pfDecodeAudioDataCB;
	/**
	 * The Pf passenger flow statistic call back.
	 */
	static PassengerFlowStatisticCallBack_PF pfPassengerFlowStatisticCallBack;

	/**
	* Callback function to receive alarm information
	* @param [IN] iUserID              	User login ID
	* @param [IN] iChannelID           	Channel number
	* @param [IN] iAlarmType          	Alarm type
	* @param [IN] tAlarmTime           	Alarm time
	* @param [IN] strName              	Alarm source name
	* @param [IN] iBufLen             	Length of structure for alarm information
	* @note*/
	/*public void alarmCallBack(long iUserID,int iChannelID, int iAlarmType, int tAlarmTime, String strName,int iBufLen) {
		pfAlarmCallBack.alarmCallBack(iUserID, iChannelID, iAlarmType, tAlarmTime, strName, iBufLen) ;
    }
 	
	public native int  NETDEV_SetAlarmCallBack(long iUserID, String strAlarmMessCallBack, int iUserData);
	public int  NETDEV_Android_SetAlarmCallBack(long iUserID, AlarmCallBack_PF strAlarmMessCallBack, int iUserData){
		pfAlarmCallBack = strAlarmMessCallBack;
		return NETDEV_SetAlarmCallBack(iUserID,"alarmCallBack",0);
	}*/

	public void alarmCallBack(long iUserID, int iAlarmSrcType, int iChannelID, int dwIndex, int iAlarmType, int tAlarmTime, String strName) {
		pfAlarmCallBack.alarmCallBack(iUserID, iAlarmSrcType, iChannelID, dwIndex, iAlarmType, tAlarmTime, strName) ;
	}

	/**
	 * Netdev set alarm call back v 2 int.
	 *
	 * @param iUserID              the user id
	 * @param strAlarmMessCallBack the str alarm mess call back
	 * @param iUserData            the user data
	 * @return the int
	 */
	public static native int  NETDEV_SetAlarmCallBackV2(long iUserID, String strAlarmMessCallBack, int iUserData);

	/**
	 * Netdev android set alarm call back int.
	 *
	 * @param iUserID              the user id
	 * @param strAlarmMessCallBack the str alarm mess call back
	 * @param iUserData            the user data
	 * @return the int
	 */
	public static int  NETDEV_Android_SetAlarmCallBack(long iUserID, AlarmCallBack_PF strAlarmMessCallBack, long iUserData){
		pfAlarmCallBack = strAlarmMessCallBack;
		return NETDEV_SetAlarmCallBackV2(iUserID,"alarmCallBack",0);
	}

	/**
	 * Alarm call back v 30.
	 *
	 * @param lpUserID     the lp user id
	 * @param stReportInfo the st report info
	 * @param lpBuf        the lp buf
	 * @param dwBufLen     the dw buf len
	 * @param lpUserData   the lp user data
	 */
	public void alarmCallBackV30(long lpUserID, NETDEV_REPORT_INFO_S stReportInfo, long lpBuf, int dwBufLen, long lpUserData) {
		pfAlarmCallBackV30.AlarmMessCallBackV30(lpUserID, stReportInfo, lpBuf, dwBufLen, lpUserData) ;
	}

	/**
	 * Netdev set alarm call back v 30 int.
	 *
	 * @param iUserID                 the user id
	 * @param strAlarmMessCallBackV30 the str alarm mess call back v 30
	 * @param iUserData               the user data
	 * @return the int
	 */
	public static native int  NETDEV_SetAlarmCallBack_V30(long iUserID, String strAlarmMessCallBackV30, long iUserData);

	/**
	 * Netdev android set alarm call back v 30 int.
	 *
	 * @param iUserID                 the user id
	 * @param strAlarmMessCallBackV30 the str alarm mess call back v 30
	 * @param iUserData               the user data
	 * @return the int
	 */
	public static int  NETDEV_Android_SetAlarmCallBack_V30(long iUserID, AlarmMessCallBackV30  strAlarmMessCallBackV30, long iUserData){
		pfAlarmCallBackV30 = strAlarmMessCallBackV30;
		return NETDEV_SetAlarmCallBack_V30(iUserID,"alarmCallBackV30",iUserData);
	}

	/**
	 * Exception call back.
	 *
	 * @param iUserID          the user id
	 * @param iExceptionType   the exception type
	 * @param iExceptionHandle the exception handle
	 */
	public void exceptionCallBack(long iUserID,int iExceptionType,long iExceptionHandle) {
		pfExceptionCallBack.exceptionCallBack(iUserID, iExceptionType, iExceptionHandle) ;
	}

	/**
	 * Netdev set exception call back int.
	 *
	 * @param strExceptionCallBack the str exception call back
	 * @param iUserData            the user data
	 * @return the int
	 */
	public static native int  NETDEV_SetExceptionCallBack(String strExceptionCallBack, long iUserData);

	/**
	 * Netdev android set exception call back int.
	 *
	 * @param strExceptionCallBack the str exception call back
	 * @param iUserData            the user data
	 * @return the int
	 */
	public static int  NETDEV_Android_SetExceptionCallBack(ExceptionCallBack_PF strExceptionCallBack, long iUserData){
		pfExceptionCallBack = strExceptionCallBack;
		return NETDEV_SetExceptionCallBack("exceptionCallBack",0);
	}

	/**
	 * Netdev discovery boolean.
	 *
	 * @param szBeginIP the sz begin ip
	 * @param szEndIP   the sz end ip
	 * @return the boolean
	 */
	public static native boolean NETDEV_Discovery(String szBeginIP, String szEndIP);

	/**
	 * Netdev set discovery call back boolean.
	 *
	 * @param cbDiscoveryCallBack the cb discovery call back
	 * @return the boolean
	 */
	public static native boolean NETDEV_SetDiscoveryCallBack(NETDEV_DISCOVERY_CALLBACK_PF cbDiscoveryCallBack);

	/**
	 * Netdev modify device addr boolean.
	 *
	 * @param stDevAddrInfo the st dev addr info
	 * @return the boolean
	 */
	public static native boolean NETDEV_ModifyDeviceAddr(NETDEV_DEV_ADDR_INFO_S stDevAddrInfo);
	
 	/**
 	* SDK initialization
 	* @return 1 means success, and any other value means failure.
 	* @note Thread not safe
 	*/
 	public  native int NETDEV_Init();
 	
 	/**
 	* DK uninitialization
 	* @return  1 means success, and any other value means failure.
 	* @note Thread not safe
 	*/
 	public static native int NETDEV_Cleanup();
 	
 	/**
 	*  User login
 	* @param [IN]  DevIP         IP Device IP
 	* @param [IN]  DevPort       Device server port
 	* @param [IN]  UserName      Username
 	* @param [IN]  Password      Password
 	* @param [OUT] oDeviceInfo   device information 
 	* @return  Returned user login ID. 0 indicates failure, and other values indicate the user ID.
 	* @note
 	*/
	public static native long NETDEV_Login(String DevIP, int DevPort, String Username, String Password,NETDEV_DEVICE_INFO_S oDeviceInfo);

	/**
	 * Netdev get stream url string.
	 *
	 * @param lpUserID     the lp user id
	 * @param dwChannelID  the dw channel id
	 * @param dwStreamType the dw stream type
	 * @return the string
	 */
	public static native String NETDEV_GetStreamUrl(long lpUserID, int dwChannelID, int dwStreamType);

	/**
	 * Netdev fast real play by url long.
	 *
	 * @param lpUerID      the lp uer id
	 * @param StreamUrl    the stream url
	 * @param oPreviewInfo the o preview info
	 * @param dwWinIndex   the dw win index
	 * @return the long
	 */
	public static native long NETDEV_FastRealPlayByUrl(long lpUerID, String StreamUrl, NETDEV_PREVIEWINFO_S oPreviewInfo, int dwWinIndex);

	/**
	 * Netdev get replay url string.
	 *
	 * @param lpUserID     the lp user id
	 * @param dwChannelID  the dw channel id
	 * @param dwStreamType the dw stream type
	 * @return the string
	 */
	public static native String NETDEV_GetReplayUrl(long lpUserID, int dwChannelID, int dwStreamType);

	/**
	 * Netdev fast play back by url long.
	 *
	 * @param lpUerID         the lp uer id
	 * @param StreamUrl       the stream url
	 * @param pstPlayBackInfo the pst play back info
	 * @param dwWinIndex      the dw win index
	 * @return the long
	 */
	public static native long NETDEV_FastPlayBackByUrl(long lpUerID, String StreamUrl, NETDEV_PLAYBACKCOND_S pstPlayBackInfo, int dwWinIndex);

	/**
	 * Netdev capture no preview int.
	 *
	 * @param lpUerID       the lp uer id
	 * @param dwChannelID   the dw channel id
	 * @param dwStreamType  the dw stream type
	 * @param pszFileName   the psz file name
	 * @param dwCaptureMode the dw capture mode
	 * @return the int
	 */
	public static native int NETDEV_CaptureNoPreview(long lpUerID,int dwChannelID, int dwStreamType,String pszFileName,int dwCaptureMode);
	/**
	*  User logout
	* @param [IN] lpUserID    用户登录User login ID
	* @return 1 means success, and any other value means failure.
	* @note
	*/
    public static native int NETDEV_Logout(long lpUerID);
    
    /**
    * Query channel capabilities
    * @param [IN]    lpUserID           User login ID
    * @param [INOUT] pdwChlCount        Number of channels
    * @return ArrayList    List of channel capabilities.
    * @note
    */
    public static native ArrayList<NETDEV_VIDEO_CHL_DETAIL_INFO_S> NETDEV_QueryVideoChlDetailList(long lpUserID, int dwChlCount);
    
    /**
    *   Get error code
    * @return Error codes
    */
    public static native int NETDEV_GetLastError();
    
    /**
    *  Modify image display ratio
    */
    public static native void NETDEV_SetRenderSurface(Surface view);
    
    /**
    * Start Live view
    * @param [IN]  lpUserID             User login ID
    * @param [IN]  oPreviewInfo       	see enumeration
    * @return  Returned user login ID. 0 indicates failure, and other values indicate the user ID.
    * @note
    */
    public  static native long NETDEV_RealPlay(long lpUerID,NETDEV_PREVIEWINFO_S oPreviewInfo, int dwWinIndex);
    
    /**
    *  Stop Live view
    * @param [IN]  lpPlayID     ID Preview ID
    * @return 1 means success, and any other value means failure.
    * @note  Stop the live view started by NETDEV_RealPlay
    */
    public  static native int NETDEV_StopRealPlay(long lpPlayID, int dwWinIndex);
    
    /**
    * Live view snapshot
    * @param [IN]  lpPlayID         Preview\playback handle
    * @param [IN]  pszFileName      File path to save images (including file name)
    * @param [IN]  dwCaptureMode    Image saving format, see #NETDEV_PICTURE_FORMAT_E
    * @return means success, and any other value means failure.
    * @note  File format suffix is not required in the file name
    */
    public static native int NETDEV_CapturePicture(long lpPlayID,String pszFileName,int dwCaptureMode);

	/**
	 * Netdev save real data int.
	 *
	 * @param lpPlayID    the lp play id
	 * @param pszFileName the psz file name
	 * @param dwFormat    the dw format
	 * @return the int
	 */
	public static native int NETDEV_SaveRealData(long lpPlayID,String pszFileName,int dwFormat);

	/**
	 * Netdev stop save real data int.
	 *
	 * @param lpPlayID the lp play id
	 * @return the int
	 */
	public static native int NETDEV_StopSaveRealData(long lpPlayID);

	/**
	 * Netdev get system time cfg int.
	 *
	 * @param lpUserID     the lp user id
	 * @param stDeviceTime the st device time
	 * @return the int
	 */
	public static native int NETDEV_GetSystemTimeCfg(long lpUserID, NETDEV_TIME_CFG_S stDeviceTime);

	/***
	 * Set System Time
	 * @param [IN] lpUserID
	 * @param [OUT] stDeviceTime
	 * @return
	 */
	public static native int NETDEV_SetSystemTimeCfg(long lpUserID, NETDEV_TIME_CFG_S stDeviceTime);

    /**
     * PTZ control operation (preview required)
     * @param [IN]  lpPlayHandle         Live preview handle
     * @param [IN]  dwPTZCommand         PTZ control commands, see #NETDEV_PTZ_E
     * @param [IN]  dwSpeed              Speed of PTZ control, which is configured according to the speed control value of different decoders. Value ranges from 1 to 9.
     * @return TRUE means success, and any other value means failure.
     * @note
     */
     public static native int NETDEV_PTZControl(long lpPlayID, int dwPTZCommand, int dwSpeed);
     
    /**
    * Get PTZ preset List 
    * @param [IN]  lpUserID         	User login ID
    * @param [IN]  dwChannelID       	Channel ID
    * @param [OUT] dwPresetIDList       Preset ID list
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_GetPTZPresetList(long lpUserID, int dwChannelID, int[] dwPresetIDList);
      
    /**
    * PTZ preset operation (preview required)  
    * @param [IN]  lpPlayHandle         Live preview handle
    * @param [IN]  dwPTZPresetCmd 		Preset Control commond
    * @param [IN]  pszPresetName     	Preset name
    * @param [IN]  dwPresetID           Preset number (starting from 0). Up to 255 presets are supported.
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_PTZPreset(long lpPlayID, int  dwPTZPresetCmd, String  szPresetName, int dwPresetID);

    /**
    * PTZ preset operation (preview not required)
    * @param [IN]  lpUserID             User login ID
    * @param [IN]  dwChannelID          Channel number
    * @param [IN]  dwPTZPresetCmd       PTZ preset operation commands, see NETDEV_PTZ_PRESETCMD_E
    * @param [IN]  pszPresetName        Preset name
    * @param [IN]  dwPresetID           Preset number (starting from 0). Up to 255 presets are supported.
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_PTZPreset_Other(long lpUserID, int dwChannelID, int  dwPTZPresetCmd, String szPresetName, int dwPresetID);

	/**
	 * Netdev get ptz preset list ex netdev ptz preset s [ ].
	 *
	 * @param lpUserID    the lp user id
	 * @param dwChannelID the dw channel id
	 * @return the netdev ptz preset s [ ]
	 */
	public static native NETDEV_PTZ_PRESET_S[] NETDEV_GetPTZPresetListEx(long lpUserID, int dwChannelID);

	/**
	 * Netdev ptz control other int.
	 *
	 * @param lpUserID     the lp user id
	 * @param dwChannelID  the dw channel id
	 * @param dwPTZCommand the dw ptz command
	 * @param dwSpeed      the dw speed
	 * @return the int
	 */
	public static native int NETDEV_PTZControl_Other(long lpUserID, int dwChannelID, int dwPTZCommand, int dwSpeed);


	/**
	 * Netdev quick search int [ ].
	 *
	 * @param lUserID      the l user id
	 * @param dwChannelID  the dw channel id
	 * @param oMonthInfo   the o month info
	 * @param oMonthStatus the o month status
	 * @return the int [ ]
	 */
	public static native int[] NETDEV_QuickSearch(long lUserID, int dwChannelID, NETDEV_MONTH_INFO_S oMonthInfo, NETDEV_MONTH_STATUS_S oMonthStatus);
    
    /**
    * Query recording files according to file type and time
    * @param [IN]  lpUserID      	User login ID
    * @param [IN]  pstFindCond  	Search condition
    * @return Recording search service number. 0 means failure. Other values are used as the handle parameters of functions like NETDEV_FindClose.
    * @note 
    */   
    public static native long NETDEV_FindFile(long lpUserID, NETDEV_FILECOND_S pstFindCond);
    
    /**
    * Obtain the information of found files one by one.
    * @param [IN]  lpFindHandle     File search handle
    * @param [OUT] pstFindData      Pointer to save file information
    * @return TRUE means success, and any other value means failure.
    * @note  A returned failure indicates the end of search.
    */
    public static native int NETDEV_FindNextFile(long lpFindHandle, NETDEV_FINDDATA_S pstFindData);

	/**
	 * Netdev set picture fluency int.
	 *
	 * @param lpUserID  the lp user id
	 * @param dwFluency the dw fluency
	 * @return the int
	 */
	public static native int NETDEV_SetPictureFluency(long lpUserID, int dwFluency);
    /**
    * Close file search and release resources
    * @param [IN] lpFindHandle  File search handle
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_FindClose(long lpFindHandle);
     
    /**
    * Play back recording by time. 
    * @param [IN] lpUserID          User login ID
    * @param [IN] pstPlayBackCond   Pointer to playback-by-time structure, see LPNETDEV_PLAYBACKCOND_S
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native long NETDEV_PlayBackByTime(long lpUserID, NETDEV_PLAYBACKCOND_S pstPlayBackInfo, int dwWinIndex);
    
    /**
    * Stop playback service
    * @param [IN] lpPlayHandle   Playback handle
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_StopPlayBack(long lpPlayHandle, int dwWinIndex);
    
    /**
    * Control recording playback status.
    * @param [IN]  lpPlayHandle     Playback or download handle
    * @param [IN]  dwControlCode    Command for controlling recording playback status, see NETDEV_VOD_PLAY_CTRL_E
    * @param [INOUT]  lpBuffer     Pointer to input/output parameters. For playing speed, see NETDEV_VOD_PLAY_STATUS_E. The type of playing time: INT64.
    * @return TRUE means success, and any other value means failure.
    * @note When playing, pause or resume videos, set IpBuffer as NULL.
    */
    public static native int NETDEV_PlayBackControl(long lpPlayHandle, int dwControlCode, NETDEV_PLAYBACKCONTROL_S lpBuffer);
    
    /**
    * Download recordings by time
    * @param [IN]  lpUserID          	User login ID
    * @param [IN]  pstPlayBackCond   	Pointer to playback-by-time structure, see LPNETDEV_PLAYBACKCOND_S
    * @param [IN]  *pszSaveFileName    	Downloaded file save path on PC, must be an absolute path (including file name)
    * @param [IN]  dwFormat         	Recording file saving format
    * @return Download handle. 0 means failure. Other values are used as the handle parameters of functions like NETDEV_StopGetFile.
    * @note
    */
    public static native long NETDEV_DownloadFile(long lpUserID, NETDEV_PLAYBACKCOND_S lpBuffer, String szSaveFileName, int dwFormat);
    
    /**
    * Stop downloading recording files
    * @param [IN]  lpPlayHandle  Playback handle
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_StopDownloadFile(long lpPlayHandle);
    
    /**
    * Get device basic info
    * @param [IN]  lpUserID          	User login ID
    * @param [IN]  dwChannelID          Channel ID
    * @param [OUT]  stDevinfo           Device Info
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_GetDeviceInfo(long lpUserID, int dwChannelID, NETDEV_DEVICE_BASICINFO_S stDevinfo);

	/**
	 * Initialize int.
	 *
	 * @return the int
	 */
	public static native int initialize();

	/**
	 * Renderer render int.
	 *
	 * @param dwWinIndex the dw win index
	 * @return the int
	 */
	public static native int rendererRender(int dwWinIndex);

	/**
	 * Sets renderer viewport.
	 *
	 * @param w the w
	 * @param h the h
	 * @return the renderer viewport
	 */
	public static native int setRendererViewport(int w, int h);

	/**
	 * Initialize renderer int.
	 *
	 * @param dwWinIndex the dw win index
	 * @return the int
	 */
	public static native int initializeRenderer(int dwWinIndex);

	/**
	 * Scale int.
	 *
	 * @param scaleRatio the scale ratio
	 * @param x          the x
	 * @param y          the y
	 * @param dwWinIndex the dw win index
	 * @return the int
	 */
	public static native int Scale(float scaleRatio, float x, float y, int dwWinIndex);

	/**
	 * SDK initialization
	 * @return 1 means success, and any other value means failure.
	 * @note ID must be unique
	 */
	public static native int NETDEV_SetClientID(String strClientID);

	/**
	 * Decode audio data call back.
	 *
	 * @param lpVoiceComHandle the lp voice com handle
	 * @param voiceData        the voice data
	 * @param length           the length
	 * @param u32WaveFormat    the u 32 wave format
	 */
	public void DecodeAudioDataCallBack(long lpVoiceComHandle, byte[] voiceData, int length, int u32WaveFormat)
    {
    	pfDecodeAudioCallBack.DecodeAudioDataCallBack(lpVoiceComHandle, voiceData, length, u32WaveFormat);
    }
	
    /**
    * Start input voice server
    * @param [IN]  lpUserID                 User login ID
    * @param [IN]  dwChannelID              Channel ID
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native long NETDEV_StartInputVoiceSrv(long lpUserID,int dwChannelID);

	/**
	 * Netdev android start input voice srv long.
	 *
	 * @param lpUserID    the lp user id
	 * @param dwChannelID the dw channel id
	 * @return the long
	 */
	public static long NETDEV_Android_StartInputVoiceSrv(long lpUserID,int dwChannelID)
	{
		pfDecodeAudioCallBack = new DecodeAudioCallBack_PF();
		return NETDEV_StartInputVoiceSrv(lpUserID,dwChannelID);
	}
    
    /**
    * Stop input voice server
    * @param [IN]  lpVoiceComHandle         Two-way audio handle
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_StopInputVoiceSrv(long lpVoiceComHandle);

	/**
	 * Netdev android stop input voice srv int.
	 *
	 * @param lpVoiceComHandle the lp voice com handle
	 * @return the int
	 */
	public static int NETDEV_Android_StopInputVoiceSrv(long lpVoiceComHandle) {
		pfDecodeAudioCallBack.release();
		return NETDEV_StopInputVoiceSrv(lpVoiceComHandle);
	}
    
    /**
    * input voice Data
    * @param [IN]  lpVoiceComHandle         Two-way audio handle
    * @param [IN]  lpDataBuf         		Data buffer
    * @param [IN]  dwDataLen         		Data length
    * @param [IN]  pstVoiceParam         	Voice param
    * @return TRUE means success, and any other value means failure.
    * @note
    */
    public static native int NETDEV_InputVoiceData(long lpVoiceComHandle,byte[] lpDataBuf,int dwDataLen,NETDEV_AUDIO_SAMPLE_PARAM_S stVoiceParam);

	 /**
	 *    PTZ absolute move
	 * @param [IN]  lpUserID         User ID
	 * @param [IN]  dwChannelID      Channel ID
	 * @param [IN]  stPTZAbsoluteMove      PTZ absolute move info
	 * @return  1 means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_PTZAbsoluteMove(long lpUserID,int dwChannelID, NETDEV_PTZ_ABSOLUTE_MOVE_S stPTZAbsoluteMove);

	/**
	 *   Get PTZ Status
	 * @param [IN]  lpUserID         User ID
	 * @param [IN]  dwChannelID      Channel ID
	 * @param [IN]  stPTZStatus      PTZ status
	 * @return  1 means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_PTZGetStatus(long lpUserID,int dwChannelID, NETDEV_PTZ_STATUS_S stPTZStatus);

	/**
	 * Netdev get dev config int.
	 *
	 * @param iUserID        the user id
	 * @param iChannelID     the channel id
	 * @param iCommand       the command
	 * @param oOutBuffer     the o out buffer
	 * @param iOutBufferSize the out buffer size
	 * @param iBytesReturned the bytes returned
	 * @return the int
	 */
	public native int NETDEV_GetDevConfig(long iUserID, int iChannelID,
										  int iCommand, Object oOutBuffer, int iOutBufferSize,
										  int iBytesReturned);

	/**
	 * Netdev set dev config int.
	 *
	 * @param iUserID        the user id
	 * @param iChannelID     the channel id
	 * @param iCommand       the command
	 * @param oInBuffer      the o in buffer
	 * @param iInBufferSizes the in buffer sizes
	 * @return the int
	 */
	/*
	 * 设置设备的配置信息 Modify device configuration information
	 *
	 * @param [IN] iUserID 用户登录ID User login ID
	 *
	 * @param [IN] iChannelID 通道号 Channel number
	 *
	 * @param [IN] iCommand 设备配置命令,参见#NETDEV_CONFIG_COMMAND_E Device
	 * configuration commands, see #NETDEV_CONFIG_COMMAND_E
	 *
	 * @param [IN] iInBuffer 输入数据的缓冲指针 Pointer to buffer of input data
	 *
	 * @param [IN] iInBufferSize 输入数据的缓冲长度(以字节为单位) Length of input data buffer
	 * (byte)
	 *
	 * @return TRUE表示成功,其他表示失败 TRUE means success, and any other value means
	 * failure.
	 *
	 * @note
	 */
	public native int NETDEV_SetDevConfig(long iUserID, int iChannelID,
										  int iCommand, Object oInBuffer, int iInBufferSizes);


	/**
	 * 设备登录
	 * @param [IN]  pstDevLoginInfo  设备登录信息
	 * @param [OUT] pstSELogInfo     安全登录信息，包含登录失败次数及下次登录时间
	 * @return 返回值为用户ID。
	 * @note 安全登录信息此字段仅适用于使用LAPI协议登录的设备
	 * -
	 */
	public static native long NETDEV_Login_V30(NETDEV_DEVICE_LOGIN_INFO_S stDevLoginInfo, NETDEV_SELOG_INFO_S stSELogInfo);

	/**
	 * 查询视频通道信息列表  Query channel info list
	 * @param [IN]    lpUserID           用户登录句柄 User login ID
	 * @param [INOUT] pdwChlCount        通道数 Number of channels
	 * @param [OUT]   pstVideoChlList    通道能力集列表 List of channel info list
	 * @return TRUE表示成功,其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_QueryVideoChlDetailListEx(long iUserID, MutableInteger pdwChlCount, ArrayList<NETDEV_VIDEO_CHL_DETAIL_INFO_EX_S> stVideoChlList);

	/**
	 * 查询组织信息列表
	 * @param [IN] lpUserID          用户登录ID
	 * @param [IN] pstFindCond       查找组织信息列表条件
	 * @return 查询句柄,返回0表示失败，其他值作为NETDEV_FindNextOrgInfo、NETDEV_FindCloseOrgInfo等函数的参数。
	 * @note
	 */
	public static native long NETDEV_FindOrgInfoList(long iUserID, NETDEV_ORG_FIND_COND_S stFindCond);

	/**
	 * 逐个获取查找到的组织信息
	 * @param [IN]  lpFindHandle                 查找句柄
	 * @param [OUT] pstOrgInfo                   保存组织信息的指针
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note 返回失败说明查询结束 A returned failure indicates the end of search.
	 */
	public static native int NETDEV_FindNextOrgInfo(long iFindHandle, NETDEV_ORG_INFO_S stOrgInfo);

	/**
	 * 关闭查找 组织信息，释放资源
	 * @param [IN] lpFindHandle  文件查找句柄
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_FindCloseOrgInfo(long iFindHandle);

	/**
	 * 通过组织ID查询通道信息列表
	 * @param [IN] lpUserID          用户登录ID
	 * @param [IN] dwOrgID           组织ID
	 * @param [IN] dwChnType         通道类型，参见#NETDEV_CHN_TYPE_E
	 * @return 查询句柄,返回0表示失败，其他值作为NETDEV_FindNextOrgChn、NETDEV_FindCloseOrgChn等函数的参数。
	 * @note
	 */
	public static native long NETDEV_FindOrgChnList(long iUserID, int dwOrgID, int dwChnType);

	/**
	 * 逐个获取查找到的 组织通道 信息
	 * @param [IN]  lpFindHandle                 查找句柄
	 * @param [OUT] pstOrgChnInfo                保存 组织通道 信息的指针
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note 返回失败说明查询结束 A returned failure indicates the end of search.
	 */
	public static native int NETDEV_FindNextOrgChn(long iUserID, NETDEV_ORG_CHN_INFO_S stOrgChnInfo);

	/**
	 * 关闭查找 组织通道信息，释放资源
	 * @param [IN] lpFindHandle  文件查找句柄
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_FindCloseOrgChn(long iFindHandle);

	/**
	 * 通过 设备类型 查询 设备列表
	 * @param [IN] lpUserID              用户登录ID
	 * @param [IN] dwDevType             设备类型 参见#NETDEV_DEVICE_MAIN_TYPE_E
	 * @return 查询句柄,返回0表示失败，其他值作为NETDEV_FindNextOrgInfo、NETDEV_FindCloseOrgInfo等函数的参数。
	 * @note
	 */
	public static native long NETDEV_FindDevList(long iUserID, int dwDevType);

	/**
	 * 逐个获取查找到的 设备信息
	 * @param [IN]  lpFindHandle                 查找句柄
	 * @param [OUT] pstDevBasicInfo              保存 设备详细信息的指针
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note 返回失败说明查询结束 A returned failure indicates the end of search.
	 */
	public static native int NETDEV_FindNextDevInfo(long iUserID, NETDEV_DEV_BASIC_INFO_S stDevBasicInfo);

	/**
	 * 关闭查找 设备信息，释放资源
	 * @param [IN] lpFindHandle  文件查找句柄
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_FindCloseDevInfo(long iFindHandle);

	/**
	 * 通过设备ID或通道类型 查询通道信息列表
	 * @param [IN] lpUserID          用户登录ID
	 * @param [IN] dwDevID           设备ID
	 * @param [IN] dwChnType         通道类型，参见# NETDEV_CHN_TYPE_E
	 * @return 查询句柄,返回0表示失败，其他值作为NETDEV_FindNextDevChn、NETDEV_FindCloseDevChn等函数的参数。
	 * @note     1、只根据通道类型查询时，将设备ID设置为0.
	 */
	public static native long NETDEV_FindDevChnList(long iUserID, int dwDevID, int dwChnType);

	/**
	 * 逐个获取查找到的 设备通道 信息
	 * @param [IN]  lpFindHandle         查找句柄
	 * @param [OUT] lpOutBuffer          接收数据的缓冲指针
	 * @param [IN] dwOutBufferSize       接收数据的缓冲长度(以字节为单位)，不能为0
	 * @param [OUT] pdwBytesReturned     实际收到的数据长度指针，不能为NUL
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note 返回失败说明查询结束 A returned failure indicates the end of search.
	 */
	public static native int NETDEV_FindNextDevChn(long iFindHandle, NETDEV_DEV_CHN_ENCODE_INFO_S stDevChnEncodeInfo);

	/**
	 * 关闭查找 设备通道信息，释放资源
	 * @param [IN] lpFindHandle  文件查找句柄
	 * @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_FindCloseDevChn(long iFindHandle);

	/**
	 * My struct alarm call back.
	 *
	 * @param iUserID     the user id
	 * @param stAlarmInfo the st alarm info
	 * @param stAlarmData the st alarm data
	 * @param lpUserData  the lp user data
	 */
	public void myStructAlarmCallBack(long iUserID,NETDEV_STRUCT_ALARM_INFO_S stAlarmInfo,NETDEV_STRUCT_DATA_INFO_S stAlarmData, long lpUserData) {
		structAlarmMessDataCB.StructAlarmMessCallBack(iUserID, stAlarmInfo, stAlarmData, lpUserData) ;
	}

	/**
	* 注册人脸识别报警消息回调函数
	* Register callback function and receive alarm information, etc.
	* @param [IN] lpUserID                  用户登录ID User login ID
	* @param [IN] cbFaceAlarmMessCallBack   回调函数 Callback function
	* @param [IN] lpUserData                用户数据 User data
	* @return TRUE表示成功，其他表示失败 TRUE means success, and any other value means failure.
	* @note
	*/
	public static native int NETDEV_SetStructAlarmCallBack(long lpUserID, String strAlarmMessCallBack, long lUserData);

	/**
	 * Netdev android set struct alarm call back int.
	 *
	 * @param iUserID                the user id
	 * @param pstructAlarmMessDataCB the pstruct alarm mess data cb
	 * @param iUserData              the user data
	 * @return the int
	 */
	public static int NETDEV_Android_SetStructAlarmCallBack(long iUserID, StructAlarmMessCallBack pstructAlarmMessDataCB, long iUserData) {
		structAlarmMessDataCB = pstructAlarmMessDataCB;
		return NETDEV_SetStructAlarmCallBack(iUserID, "myStructAlarmCallBack", iUserData);
	}

	/**
	* LAPI告警订阅
	* @param [IN] lpUserID                                      用户登录句柄
	* @param IN LPNETDEV_LAPI_SUB_INFO_S   pstSubInfo           告警订阅请求
	* @param OUT LPNETDEV_SUBSCRIBE_SUCC_INFO_S pstSubSuccInfo  订阅成功返回信息
	* @return TRUE表示成功,其他表示失败
	* @note Type字段指定订阅类型
	*/
	public static native int NETDEV_SubscibeLapiAlarm(long lpUserID, NETDEV_LAPI_SUB_INFO_S stSubInfo, NETDEV_SUBSCRIBE_SUCC_INFO_S stSubSuccInfo);

	/**
	* 取消LAPI告警订阅
	* @param [IN] lpUserID               用户登录句柄
	* @param [IN] UINT32 udwID           告警订阅ID
	* @return TRUE表示成功,其他表示失败
	* @note
	*/
	public static native int NETDEV_UnSubLapiAlarm(long lpUserID, int udwID);

	/**
	 * 多通道开始客流量统计查询
	 * @param [IN] lpUserID                用户登录ID
	 * @param [IN] pstStatisticCond        客流量统计结构体
	 * @param [OUT] pudwSearchID           客流量查询ID
	 * @return TRUE表示成功，其他表示失败
	 */
	public static native int NETDEV_StartMultiTrafficStatistic(long lpUserID, NETDEV_MULTI_TRAFFIC_STATISTICS_COND_S pstStatisticCond, MutableInteger pudwSearchID);
	
	/**
	 * 获取客流量统计进度
	 * @param [IN]  lpUserID               用户登录ID
	 * @param [IN]  udwSearchID            客流量查询ID
	 * @param [OUT] pudwProgress           客流量统计进度
	 * @return TRUE表示成功，其他表示失败
	 */
	public static native int NETDEV_GetTrafficStatisticProgress(long lpUserID, int udwSearchID, MutableInteger pudwProgress);

	/**
	 * 停止客流量查询
	 * @param [IN] lpUserID                        用户登录ID
	 * @param [IN] udwSearchID                     客流量查询ID
	 * @return TRUE表示成功，其他表示失败
	 */
	public static native int NETDEV_StopTrafficStatistic(long lpUserID,int udwSearchID);

	/**
	 * 获取客流量统计信息列表
	 * @param [IN] lpUserID                用户登录ID
	 * @param [IN] udwSearchID             客流量查询ID
	 * @return 查询句柄(作为NETDEV_FindNextTrafficStatisticInfo, NETDEV_FindCloseTrafficStatisticInfo)，NULL表示失败
	 */
	public static native long NETDEV_FindTrafficStatisticInfoList(long lpUserID, int udwSearchID);

	/**
	 * 逐个查询获取到的客流量信息
	 * @param [IN] lpFindHandle                查找句柄
	 * @param [OUT] pstStatisticInfo           客流量查询信息
	 * @return TRUE表示成功，其他表示失败
	 */
	public static native int NETDEV_FindNextTrafficStatisticInfo(long lpFindHandle, NETDEV_TRAFFIC_STATISTICS_INFO_S pstStatisticInfo);

	/**
	 * 关闭查找，释放资源
	 * @param [IN] lpFindHandle
	 * @return TRUE表示成功，其他表示失败
	 */
	public static native int NETDEV_FindCloseTrafficStatisticInfo(long lpFindHandle);

	/**
	 * 客流量统计消息回调函数  Callback function for passenger flow statistic message
	 * @param [IN] lpUserID                用户登录句柄 User login ID
	 * @param [IN] pstPassengerFlowData    客流量数据 Passenger flow data
	 * @param [IN] lpUserData              用户数据   User data
	 * @note 无 None
	 */
	public static native int NETDEV_SetPassengerFlowStatisticCallBack(long lpUserID, String strPassengerFlowStatisticCB,long iUserData );

	/**
	 * Passenger flow statistic cb.
	 *
	 * @param lpUserID  the lp user id
	 * @param stData    the st data
	 * @param iUserData the user data
	 */
	public void passengerFlowStatisticCB(long lpUserID, NETDEV_PASSENGER_FLOW_STATISTIC_DATA_S stData, long iUserData) {
		pfPassengerFlowStatisticCallBack.PassengerFlowStatisticCallBack(lpUserID, stData, iUserData) ;
	}

	/**
	 * Netdev android set passenger flow statistic cb int.
	 *
	 * @param lpUserID               the lp user id
	 * @param strDecodeVideoCallBack the str decode video call back
	 * @param iUserData              the user data
	 * @return the int
	 */
	public static int  NETDEV_Android_SetPassengerFlowStatisticCB(long lpUserID, PassengerFlowStatisticCallBack_PF  strDecodeVideoCallBack,long iUserData){
		pfPassengerFlowStatisticCallBack = strDecodeVideoCallBack;
		return NETDEV_SetPassengerFlowStatisticCallBack(lpUserID,"passengerFlowStatisticCB",iUserData);
	}

	/**
	 * 开启声音  Enable sound
	 * @param [IN]  lpPlayHandle   预览句柄 Preview handle
	 * @return TRUE表示成功,其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_OpenSound(long lpPlayHandle);
	
	/**
	 * 关闭声音 Mute
	 * @param [IN]  lpPlayHandle   预览句柄 Preview handle
	 * @return TRUE表示成功,其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 */
	public static native int NETDEV_CloseSound(long lpPlayHandle);

	/**
	 * My decode audio data call back.
	 *
	 * @param lpPlayHandle the lp play handle
	 * @param pstWaveData  the pst wave data
	 * @param lpUserData   the lp user data
	 */
	public void myDecodeAudioDataCallBack(long lpPlayHandle,NETDEV_WAVE_DATA_S pstWaveData, long lpUserData) {
		pfDecodeAudioDataCB.NETDEV_DECODE_AUDIO_DATA_CALLBACK_PF(lpPlayHandle, pstWaveData, lpUserData);
	}

	/**
	 * 注册码流回调函数：解码后音频媒体流数据 Callback function to register audio stream (decoded media stream data)
	 * @param [IN]  lpPlayHandle                 预览\回放句柄 Preview\playback handle
	 * @param [IN]  cbPlayDecodeAudioCallBack    数据回调函数 Data callback function
	 * @param [IN]  bContinue                    是否继续进行播放操作 Whether to continue to playing operations.
	 * @param [IN]  lpUserData                   用户数据 User data
	 * @return TRUE表示成功,其他表示失败 TRUE means success, and any other value means failure.
	 * @note
	 * - 若关闭回调函数,将第二个参数置为NULL.
	 * - To shut the callback function, set the second parameter as NULL.
	 */
	public static native int NETDEV_SetPlayDecodeAudioCB(long lpUserID, String strPlayDecodeAudioCallBack, int bContinue, long lUserData);

	/**
	 * Netdev android set play decode audio cb int.
	 *
	 * @param iUserID                    the user id
	 * @param pPlayDecodeAudioCallBackCB the p play decode audio call back cb
	 * @param bContinue                  the b continue
	 * @param iUserData                  the user data
	 * @return the int
	 */
	public static int NETDEV_Android_SetPlayDecodeAudioCB(long iUserID, NETDEV_DECODE_AUDIO_DATA_CALLBACK_PF pPlayDecodeAudioCallBackCB, int bContinue, long iUserData) {
		pfDecodeAudioDataCB = pPlayDecodeAudioCallBackCB;
		if(pPlayDecodeAudioCallBackCB != null)
		{
			return NETDEV_SetPlayDecodeAudioCB(iUserID, "myDecodeAudioDataCallBack", bContinue, iUserData);
		}
		else
		{
			return NETDEV_SetPlayDecodeAudioCB(iUserID, "", bContinue, iUserData);
		}
	}

}

