
#import "LocalLoginViewController.h"
#import "NetDEVSDK.h"
#import "AlarmInfoViewController.h"
#import "PlaybackViewController.h"
LPVOID  lpUserID;

NSString* m_strAlarm;

typedef struct NETDEMO_ALARM_INFO
{
    INT32 ulAlarmType;
    CHAR *pcReportAlarm;
}NETDEMO_ALARM_INFO;

int gdwLoginDeviceType = 0;   /* IPC/NVR is 0,  VMS is 1*/

static NETDEMO_ALARM_INFO gastNETDemoAlarmInfo[] = \
{\
    {NETDEV_ALARM_MOVE_DETECT,"move detect"},\
    {NETDEV_ALARM_MOVE_DETECT_RECOVER,"Motion detection alarm recover"},\
    {NETDEV_ALARM_VIDEO_LOST,"video lost"},\
    {NETDEV_ALARM_VIDEO_LOST_RECOVER,"Video loss alarm recover"},\
    {NETDEV_ALARM_VIDEO_TAMPER_DETECT,"video tamper detect"},\
    {NETDEV_ALARM_VIDEO_TAMPER_RECOVER,"Tampering detection alarm recover"},\
    {NETDEV_ALARM_INPUT_SWITCH,"input switch"},\
    {NETDEV_ALARM_INPUT_SWITCH_RECOVER,"Boolean input alarm recover"},\
    {NETDEV_ALARM_TEMPERATURE_HIGH,"temperature high"},\
    {NETDEV_ALARM_TEMPERATURE_LOW,"temperature low"},\
    {NETDEV_ALARM_TEMPERATURE_RECOVER,"Temperature alarm recover"},\
    {NETDEV_ALARM_AUDIO_DETECT,"audio detect"},\
    {NETDEV_ALARM_AUDIO_DETECT_RECOVER,"Audio detection alarm recover"},\
    {NETDEV_ALARM_SERVER_FAULT,"server failure"},\
    {NETDEV_ALARM_SERVER_NORMAL,"server failure recover"},\
    
    {NETDEV_ALARM_REPORT_DEV_ONLINE,"device online"},\
    {NETDEV_ALARM_REPORT_DEV_OFFLINE,"device offline"},\
    {NETDEV_ALARM_REPORT_DEV_REBOOT,"device reboot"},\
    {NETDEV_ALARM_REPORT_DEV_SERVICE_REBOOT,"device service reboot"},\
    {NETDEV_ALARM_REPORT_DEV_CHL_ONLINE,"device chn online"},\
    {NETDEV_ALARM_REPORT_DEV_CHL_OFFLINE,"device chl offline"},\
    {NETDEV_ALARM_REPORT_DEV_DELETE_CHL,"device delete chl"},\
    
    {NETDEV_ALARM_NET_FAILED,"network failed"},\
    {NETDEV_ALARM_NET_TIMEOUT,"network timeout"},\
    {NETDEV_ALARM_SHAKE_FAILED,"shake failed"},\
    {NETDEV_ALARM_STREAMNUM_FULL,"stream num full"},\
    {NETDEV_ALARM_STREAM_THIRDSTOP,"stream third stop"},\
    {NETDEV_ALARM_FILE_END,"File ended"},\
    {NETDEV_ALARM_RTMP_CONNECT_FAIL,"RTMP connect fail"},\
    {NETDEV_ALARM_RTMP_INIT_FAIL,"RTMP init fail"},\
    //{NETDEV_ALARM_STREAM_DOWNLOAD_OVER,"vms gb stream download finished"},\
    
    {NETDEV_ALARM_DISK_ERROR,"device disk error"},\
    {NETDEV_ALARM_SYS_DISK_ERROR,"system disk error"},\
    {NETDEV_ALARM_DISK_ONLINE,"device disk online"},\
    {NETDEV_ALARM_SYS_DISK_ONLINE,"system disk online"},\
    {NETDEV_ALARM_DISK_OFFLINE,"device disk offline"},\
    {NETDEV_ALARM_SYS_DISK_OFFLINE,"system disk offline"},\
    {NETDEV_ALARM_DISK_ABNORMAL,"disk abnormal"},\
    {NETDEV_ALARM_DISK_ABNORMAL_RECOVER,"disk abnormal recover"},\
    {NETDEV_ALARM_DISK_STORAGE_WILL_FULL,"disk storage will pull"},\
    {NETDEV_ALARM_DISK_STORAGE_WILL_FULL_RECOVER,"disk storage will full recover"},\
    {NETDEV_ALARM_DISK_STORAGE_IS_FULL,"device disk storage is full"},\
    {NETDEV_ALARM_SYS_DISK_STORAGE_IS_FULL,"system disk storage is full"},\
    {NETDEV_ALARM_DISK_STORAGE_IS_FULL_RECOVER,"disk storage is full recover"},\
    {NETDEV_ALARM_DISK_RAID_DISABLED_RECOVER,"disk raid disabled recover"},\
    {NETDEV_ALARM_DISK_RAID_DEGRADED,"device disk raid degraded"},\
    {NETDEV_ALARM_SYS_DISK_RAID_DEGRADED,"system disk raid degraded"},\
    {NETDEV_ALARM_DISK_RAID_DISABLED,"device disk raid disabled"},\
    {NETDEV_ALARM_SYS_DISK_RAID_DISABLED,"system raid disabled"},\
    {NETDEV_ALARM_DISK_RAID_DEGRADED_RECOVER,"disk raid degraded recover"},\
    {NETDEV_ALARM_STOR_GO_FULL,"device storage full"},\
    {NETDEV_ALARM_SYS_STOR_GO_FULL,"system storage full"},\
    {NETDEV_ALARM_ARRAY_NORMAL,"device disk raid normal"},\
    {NETDEV_ALARM_SYS_ARRAY_NORMAL,"system disk raid normal"},\
    {NETDEV_ALARM_DISK_RAID_RECOVERED,"disk raid recovered"},\
    {NETDEV_ALARM_STOR_ERR,"device store error"},\
    {NETDEV_ALARM_SYS_STOR_ERR,"system storage error recover"},\
    {NETDEV_ALARM_STOR_ERR_RECOVER,"storage error recover"},\
    {NETDEV_ALARM_STOR_DISOBEY_PLAN,"store error"},\
    {NETDEV_ALARM_STOR_DISOBEY_PLAN_RECOVER,"storage disobey plan recover"},\
    
    {NETDEV_ALARM_BANDWITH_CHANGE,"device export bandwidth change"},\
    {NETDEV_ALARM_VIDEOENCODER_CHANGE,"device stream config change"},\
    {NETDEV_ALARM_IP_CONFLICT,"ip conflict"},\
    {NETDEV_ALARM_IP_CONFLICT_CLEARED,"ip conflict cleared"},\
    {NETDEV_ALARM_NET_OFF,"network disconnect"},\
    {NETDEV_ALARM_NET_RESUME_ON,"network disconnect recover"},\
    
    {NETDEV_ALARM_ILLEGAL_ACCESS,"device illegal access"},\
    {NETDEV_ALARM_SYS_ILLEGAL_ACCESS,"system illegal access"},\
    {NETDEV_ALARM_LINE_CROSS,"line cross"},\
    {NETDEV_ALARM_OBJECTS_INSIDE,"inside"},\
    {NETDEV_ALARM_FACE_RECOGNIZE,"face recognize"},\
    {NETDEV_ALARM_IMAGE_BLURRY,"image blurry"},\
    {NETDEV_ALARM_SCENE_CHANGE,"scene change"},\
    {NETDEV_ALARM_SMART_TRACK,"smart track"},\
    {NETDEV_ALARM_LOITERING_DETECTOR,"loitering detector"},\
    {NETDEV_ALARM_BANDWIDTH_CHANGE,"Bandwidth change"},\
    {NETDEV_ALARM_ALLTIME_FLAG_END,"all time falg end"},\
    {NETDEV_ALARM_MEDIA_CONFIG_CHANGE,"meida config change"},\
    {NETDEV_ALARM_REMAIN_ARTICLE,"remain article"},\
    {NETDEV_ALARM_PEOPLE_GATHER,"people gather"},\
    {NETDEV_ALARM_ENTER_AREA,"enter area"},\
    {NETDEV_ALARM_LEAVE_AREA,"leave area"},\
    {NETDEV_ALARM_ARTICLE_MOVE,"article move"},\
    {NETDEV_ALARM_SMART_FACE_MATCH_LIST,"face recognize blacklist"},\
    {NETDEV_ALARM_SMART_FACE_MATCH_LIST_RECOVER,"face recognize blacklist recovery"},\
    {NETDEV_ALARM_SMART_FACE_MISMATCH_LIST,"face recognize unmatch"},\
    {NETDEV_ALARM_SMART_FACE_MISMATCH_LIST_RECOVER,"face recognize unmatch recovery"},\
    {NETDEV_ALARM_SMART_VEHICLE_MATCH_LIST,"vehicle recognize match"},\
    {NETDEV_ALARM_SMART_VEHICLE_MATCH_LIST_RECOVER,"vehicle recognize match recovery"},\
    {NETDEV_ALARM_SMART_VEHICLE_MISMATCH_LIST,"vehicle recognize unmatch"},\
    {NETDEV_ALARM_SMART_VEHICLE_MISMATCH_LIST_RECOVER,"vehicle recognize unmatch recovery"},\
    {NETDEV_ALARM_IMAGE_BLURRY_RECOVER,"image blurry recover"},\
    {NETDEV_ALARM_SMART_TRACK_RECOVER,"smart track recover"},\
    {NETDEV_ALARM_SMART_READ_ERROR_RATE,"smart read error rate"},\
    {NETDEV_ALARM_SMART_SPIN_UP_TIME,"smart spin up time"},\
    {NETDEV_ALARM_SMART_START_STOP_COUNT,"smart start stop count"},\
    {NETDEV_ALARM_SMART_REALLOCATED_SECTOR_COUNT,"smart reallocated sector count"},\
    {NETDEV_ALARM_SMART_SEEK_ERROR_RATE,"smart seek error rate"},\
    {NETDEV_ALARM_SMART_POWER_ON_HOURS,"smart power on hours"},\
    {NETDEV_ALARM_SMART_SPIN_RETRY_COUNT,"smart spin retry count"},\
    {NETDEV_ALARM_SMART_CALIBRATION_RETRY_COUNT,"smart calibration replay count"},\
    {NETDEV_ALARM_SMART_POWER_CYCLE_COUNT,"smart power cycle count"},\
    {NETDEV_ALARM_SMART_POWEROFF_RETRACT_COUNT,"smart power off retract count"},\
    {NETDEV_ALARM_SMART_LOAD_CYCLE_COUNT,"smart load cycle count"},\
    {NETDEV_ALARM_SMART_TEMPERATURE_CELSIUS,"smart temperature celsius"},\
    {NETDEV_ALARM_SMART_REALLOCATED_EVENT_COUNT,"smart reallocated event count"},\
    {NETDEV_ALARM_SMART_CURRENT_PENDING_SECTOR,"smart current pending sector"},\
    {NETDEV_ALARM_SMART_OFFLINE_UNCORRECTABLE,"smart offline uncorrectable"},\
    {NETDEV_ALARM_SMART_UDMA_CRC_ERROR_COUNT,"smart udma crc error count"},\
    {NETDEV_ALARM_SMART_MULTI_ZONE_ERROR_RATE,"smart multi zone error rate"},\
    {NETDEV_ALARM_RESOLUTION_CHANGE,"resolution change"},\
    {NETDEV_ALARM_MANUAL,"manual"},\
    {NETDEV_ALARM_ALARMHOST_COMMON,"alarm host commmon"},\
    {NETDEV_ALARM_DOORHOST_COMMON,"door host commmon"},\
    {NETDEV_ALARM_FACE_NOT_MATCH,"face not match"},\
    {NETDEV_ALARM_FACE_MATCH_SUCCEED,"face match succeed"},\
    
    //{NETDEV_ALARM_VEHICLE_BLACK_LIST,"vehicle blacklist"},\

    
};

void NETDEV_AlarmMessCallBackV30(IN LPVOID lpUserID,
                                 IN LPNETDEV_REPORT_INFO_S pstReportInfo,
                                 IN LPVOID    lpBuf,
                                 IN INT32     dwBufLen,
                                 IN LPVOID    lpUserData)
{
    INT64 dwAlarmTime = 0;
    NSString* strAlarmInfo = [[NSString alloc] init];
    
    dwAlarmTime = pstReportInfo->stAlarmInfo.tAlarmTimeStamp;
    for(int i = 0; i < sizeof(gastNETDemoAlarmInfo) / sizeof(NETDEMO_ALARM_INFO); i++)
    {
        if (pstReportInfo->stAlarmInfo.dwAlarmType == gastNETDemoAlarmInfo[i].ulAlarmType)
        {
            strAlarmInfo = [NSString stringWithFormat:@"%s", gastNETDemoAlarmInfo[i].pcReportAlarm];
        }
    }
    if(strAlarmInfo.length == 0)
    {
        return;
    }
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dwAlarmTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString* strDate = [formatter stringFromDate:confromTimesp];
    strDate = [strDate stringByAppendingString:@" "];
    strDate = [strDate stringByAppendingString:strAlarmInfo];
    strDate = [strDate stringByAppendingString:@"\n\n"];
    NSLog(strDate);
    
    if (nil == m_strAlarm)
    {
        m_strAlarm = strDate;
    }
    else
    {
        m_strAlarm = [m_strAlarm stringByAppendingString:strDate];
    }
}

void NETDEV_ExceptionCallBack(IN LPVOID    lpUserID,
                                           IN INT32     dwType,
                                           IN LPVOID    lpExpHandle,
                                           IN LPVOID    lpUserData
                                           )
{
    if( NETDEV_EXCEPTION_REPORT_ALARM_INTERRUPT == dwType)
    {
        /* re-register alarm */
        NETDEV_ALARM_SUB_INFO_S stSubscribeInfo = {0};
        stSubscribeInfo.dwAlarmType = NETDEV_SUBSCRIBE_ALARM_TYPE_COM;
        BOOL bRet = NETDEV_SetAlarmCallBack_V30(lpUserID, NETDEV_AlarmMessCallBackV30, 0);
        if(TRUE != bRet)
        {
            NSLog(@"re-register alarm callback Failed ");
        }
        else
        {
            NSLog(@"re-register alarm callback Success");
        }
    }
}





@interface CloudLoginViewController ()


@end

@implementation CloudLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
- (IBAction)onBackGroundViewClicked:(id)sender {
    [self.LocalIP resignFirstResponder];
    [self.LocalPort resignFirstResponder];
    [self.LocalUser resignFirstResponder];
    [self.LocalPW resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)Locallogin:(id)sender
{
    BOOL bRet = FALSE;
    [self.view endEditing:YES];
    
    char *pszIPAddr = (char*)[_LocalIP.text UTF8String];
    char *pszUserName = (char*)[_LocalUser.text UTF8String];
    char *pszPassword = (char*) [_LocalPW.text UTF8String];
    int iPort  = [_LocalPort.text intValue];
    
    NETDEV_DEVICE_LOGIN_INFO_S stDevLoginInfo = {0};
    strncpy(stDevLoginInfo.szIPAddr, pszIPAddr, sizeof(stDevLoginInfo.szIPAddr));
    stDevLoginInfo.dwPort = iPort;
    strncpy(stDevLoginInfo.szUserName, pszUserName, sizeof(stDevLoginInfo.szUserName));
    strncpy(stDevLoginInfo.szPassword, pszPassword, sizeof(stDevLoginInfo.szPassword));
    
    NETDEV_SELOG_INFO_S stSELogInfo = {0};
    
    //select login protocols
    switch (_LoginDeviceType.selectedSegmentIndex) {
        case 0:
            gdwLoginDeviceType = 0;
            stDevLoginInfo.dwLoginProto = NETDEV_LOGIN_PROTO_ONVIF;
            break;
        case 1:
            gdwLoginDeviceType = 1;
            stDevLoginInfo.dwLoginProto = NETDEV_LOGIN_PROTO_PRIVATE;
            break;
        default:
            break;
    }
    
    lpUserID = NETDEV_Login_V30(&stDevLoginInfo, &stSELogInfo);
    if(NULL== lpUserID )
    {
        NSLog(@"NETDEV_Login_V30 failure:error:%d",NETDEV_GetLastError());
        return ;
    }
    
    NSLog(@"NETDEV_Login_V30 success");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL bRet = FALSE;

        bRet = NETDEV_SetAlarmCallBack_V30(lpUserID, NETDEV_AlarmMessCallBackV30, 0);
        if(TRUE != bRet)
        {
            NSLog(@"NETDEV_SetAlarmCallBack_V30 Failed ");
        }
        else
        {
            NSLog(@"NETDEV_SetAlarmCallBack_V30 Success");
        }
    });

    [self gotoMain];
    
}

- (void)gotoMain
{
    MainViewController *pViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"Tab"];
    UINavigationController *pNavCtrol = [[UINavigationController alloc] initWithRootViewController:pViewCtrl];
    
    [self presentViewController:pNavCtrol animated:YES completion:nil];
}
@end
