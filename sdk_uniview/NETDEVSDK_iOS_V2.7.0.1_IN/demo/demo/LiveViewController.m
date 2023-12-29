
#import "LiveViewController.h"
#import "NETDEVSDK.h"
#import "UILIVECELL.h"
#import "PlaybackViewController.h"
#import "UVAirPlayerView.h"
#import "TalkManager.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>
#import "PCMPlayer.h"
#import "channelInfo.h"
#import "common.h"
#define dwSpeed   (2)    //1~9

extern LPVOID lpUserID;  // User ID
LPVOID lpStreamHandle[4];  //The video stream handle
INT32 StreamHandle2ChlId[4];
NETDEMO_DEV_LOGININFO_S gastLoginDeviceInfo;

extern int gdwLoginDeviceType;

INT32 gdwChlID;

PCMPlayer *pPcmDataPlayer;
UILIVECELL *liveCell[4] ;  //Live box to temporarily store video callback data
BOOL winHavePlay[4];

/* two way pronunciation */
LPVOID lpTwoWayPronunHandle;

#define NETDEMO_CHANNEL_NUM_MAX         128
NETDEV_VIDEO_CHL_DETAIL_INFO_S astVideoChlList[NETDEMO_CHANNEL_NUM_MAX];

TalkManager * talkManger;
VOID NETDEV_PARSE_VOICE_DATA_CALLBACK(IN LPVOID lpVoiceComHandle,
                                      IN const LPNETDEV_WAVE_DATA_S lpWaveData,
                                      IN LPVOID lpUserParam,
                                      IN INT32 dwReserved
                                      )
{
    NSData *pcmData = [NSData dataWithBytes:lpWaveData->pcData length:lpWaveData->dwDataLen];
    [talkManger playVoice:pcmData];
    
    
}

@interface LiveViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    NSMutableArray * channelList;
}
@end

@implementation LiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int i = 0; i<4; i++) {
        liveCell[i] = [[UILIVECELL alloc] init];
        liveCell[i].hasVideoData = NO;
        winHavePlay[i] = false;
        lpStreamHandle[i] = NULL;
        StreamHandle2ChlId[i] = -1;
        
        lpTwoWayPronunHandle = NULL;
    }
    
    talkManger = [[TalkManager alloc] init];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       });
    
    channelList = [NSMutableArray array];
    _tv_chlList.delegate = self;
    
    //数字放大属性设置
    _scrollView1.delegate = self;
    _scrollView1.maximumZoomScale = 2.0;//放大倍数上限为2倍
    _scrollView1.minimumZoomScale = 1.0;
    _scrollView1.zoomScale = 1.0;
    _scrollView2.delegate = self;
    _scrollView2.maximumZoomScale = 2.0;
    _scrollView2.minimumZoomScale = 1.0;
    _scrollView2.zoomScale = 1.0;
    _scrollView3.delegate = self;
    _scrollView3.maximumZoomScale = 2.0;
    _scrollView3.minimumZoomScale = 1.0;
    _scrollView3.zoomScale = 1.0;
    _scrollView4.delegate = self;
    _scrollView4.maximumZoomScale = 2.0;
    _scrollView4.minimumZoomScale = 1.0;
    _scrollView4.zoomScale = 1.0;
    if (@available(iOS 11.0, *)) {
        _scrollView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* Display a frame of image */
-(void)liveplay
{
    for(int i = 0; i < 4; i++)
    {
        //NSLog(@"liveplay");
        if(liveCell[i].hasVideoData)  //Determines whether there is data in the livecell
        {
            void* lpDisplayData = malloc(sizeof(char) * (MAX_Y_SIZE + MAX_UV_SIZE * 2));
            int dwHeight = liveCell[i].picHeight;
            int dwWidth = liveCell[i].picWith;
            long size = dwWidth * dwHeight * sizeof(char);
            
            /*Copy the YUV data to _displayData*/
            memcpy(lpDisplayData, liveCell[i].pucDataY, size);
            memcpy(lpDisplayData + size, liveCell[i].pucDataU, size / 4);
            memcpy(lpDisplayData + size * 5 / 4, liveCell[i].pucDataV, size / 4);
            
            /*Render the YUV image data in _displayData to the _playView play window through openGL*/
            if(0 == i)
            {
                [_playView displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            else if(1 == i)
            {
                [_playView2 displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            else if (2 == i)
            {
                [_playView3 displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            else
            {
                [_playView4 displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            liveCell[i].hasVideoData = NO;
            free(lpDisplayData);
        }
    }
}

/* Start Live */
- (IBAction)onStartLiveSender:(id)sender
{
    gdwChlID = _tv_chlNum.text.intValue;
    NETDEV_PREVIEWINFO_S stPreviewInfo;
    memset(&stPreviewInfo,0, sizeof(stPreviewInfo));
    stPreviewInfo.dwChannelID = gdwChlID;
    stPreviewInfo.dwLinkMode = NETDEV_TRANSPROTOCAL_RTPTCP;  //Select media transport protocol
    stPreviewInfo.dwStreamType = NETDEV_LIVE_STREAM_INDEX_AUX;  //Select live stream index
    
    #define PLAY_FPS 25//Timer，refresh and display picture for playing live
    _mytimer=[NSTimer scheduledTimerWithTimeInterval:1.0/PLAY_FPS target:self selector:@selector(liveplay) userInfo:nil repeats:YES];
    int i = 0;
    for(i = 0; i < 4; i++)
    {
        if(winHavePlay[i] == NO)
        {
            break;
        }
        if(3 == i)
        {
            NSLog(@"窗口已满，无法播放！！！");
            return;
        }
    }
    
    lpStreamHandle[i] = NETDEV_RealPlay(lpUserID, &stPreviewInfo, NULL, NULL);//Get the video stream handle
    if(NULL == lpStreamHandle[i])
    {
        NSLog(@"NETDEV_RealPlay failed");
        return;
    }
    else
    {
        winHavePlay[i] = YES;
        StreamHandle2ChlId[i] = stPreviewInfo.dwChannelID;
        NSLog(@"NETDEV_RealPlay success");
    }
    
    /* Set the callback function to get the decoded code stream */
    if(TRUE != NETDEV_SetPlayDecodeVideoCB(lpStreamHandle[i], NETDEV_DECODE_VIDEO_DATA_CALLBACK, TRUE, lpUserID))
    {
        winHavePlay[i] = NO;
        NSLog(@"Set viedo callback failed");
    }
    else{
        NSLog(@"Set viedo callback succeed");
    }
}




/* Stop Live */
- (IBAction)exit_live:(id)sender {
    
    for(int i = 0;i<4;i++)
    {
       if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
       {
           if(TRUE != NETDEV_SetPlayDecodeVideoCB(lpStreamHandle[i], NETDEV_DECODE_VIDEO_DATA_CALLBACK, FALSE, NULL))
           {
               NSLog(@"Close the video callback failed");
           }
           else
           {
               NSLog(@"Close the video callback succeed");
           }
       
            [_mytimer setFireDate:[NSDate distantFuture]];  //Close timer
            liveCell[i].hasVideoData = NO;
            [liveCell[i] freeYUVBuff];  //Release YUV structure
            if(TRUE != NETDEV_StopRealPlay(lpStreamHandle[i]))
            {
                NSLog(@"NETDEV_StopRealPlay failed");
            }
            else
            {
                winHavePlay[i] = NO;
                NSLog(@"NETDEV_StopRealPlay success");
            }
           
            lpStreamHandle[i] = NULL;
       }
    }
}


/* Snapshot */
- (IBAction)Snapshot:(id)sender
{
    if(NULL == lpUserID)
    {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *videoDirectory = [documentPath stringByAppendingPathComponent:@"Snapshot"];
    
    BOOL BIsExist = [fileManager fileExistsAtPath:videoDirectory];
    if(true != BIsExist)
    {
        BOOL res = [fileManager createDirectoryAtPath:videoDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (true == res)
        {
            NSLog(@"文件夹创建成功");
        }
        else
        {
            NSLog(@"文件夹创建失败");
        }
    }
    NSString* fileName = @"/";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd-hhmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    fileName = [fileName stringByAppendingString:dateTime];
    fileName = [videoDirectory stringByAppendingString:fileName];
    
    const char * pcFileName =[fileName UTF8String];
    
    BOOL bRet = FALSE;
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_CapturePicture(lpStreamHandle[i], pcFileName, NETDEV_PICTURE_BMP);
            }
            else
            {
                bRet = NETDEV_CaptureNoPreview(lpUserID, gdwChlID, NETDEV_LIVE_STREAM_INDEX_AUX, pcFileName, NETDEV_PICTURE_BMP);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_CapturePicture failed ");
            }
            else
            {
               NSLog(@"NETDEV_CapturePicture succeed");
            }
        }
    }
}

/* start Two way pronunciation */
- (IBAction)onStartTwoWayPronu:(id)sender {
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if(NULL == lpTwoWayPronunHandle)
            {
                lpTwoWayPronunHandle = NETDEV_StartInputVoiceSrv(lpUserID,StreamHandle2ChlId[i]);
                if(NULL == lpTwoWayPronunHandle)
                {
                    NSLog(@"NETDEV_StartInputVoiceSrv failed");
                }
                else
                {
                    [talkManger startTalk];
                    NSLog(@"NETDEV_StartInputVoiceSrv success");
                    if(TRUE != NETDEV_SetParseVoiceDataCB(lpTwoWayPronunHandle, NETDEV_PARSE_VOICE_DATA_CALLBACK, TRUE, NULL)){
                        NSLog(@"open SetParseVoiceDataCB failed,lastErrorCode : %d", NETDEV_GetLastError());
                    }
                }
            }
        }
    }
}

/* stop Two way pronunciation */
- (IBAction)stopTwoWayPronu:(id)sender {
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if(NULL != lpTwoWayPronunHandle)
            {
                if(TRUE != NETDEV_StopInputVoiceSrv(lpTwoWayPronunHandle))
                {
                    NSLog(@"NETDEV_StopInputVoiceSrv failed");
                }
                else
                {
                    NETDEV_SetParseVoiceDataCB(lpTwoWayPronunHandle, NETDEV_PARSE_VOICE_DATA_CALLBACK, FALSE, NULL);
                    [talkManger stopTalk];
                    lpTwoWayPronunHandle = NULL;
                    NSLog(@"NETDEV_StopInputVoiceSrv success");
                }
            }
        }
    }
}

/*  */
+ (void)setInputData:(char*)pcmData andLength:(size_t)pcmLength {
    NETDEV_AUDIO_SAMPLE_PARAM_S stVoiceParam ={0};
    stVoiceParam.dwChannels = 1;
    stVoiceParam.dwSampleRate = 8000;
    stVoiceParam.enSampleFormat = NETDEV_AUDIO_SAMPLE_FMT_S16;
    NETDEV_InputVoiceData(lpTwoWayPronunHandle, (LPVOID)pcmData, (INT32)pcmLength, &stVoiceParam);
}

/* Start Local Record */
- (IBAction)StartLocalRecord:(id)sender
{
    if(NULL == lpUserID)
    {
        return;
    }
    
    NSDate *ptimeDate=[NSDate date];
    NSDateFormatter  *pdateformatter=[[NSDateFormatter alloc] init];
    [pdateformatter setDateFormat:@"HH:mm:ss"];
    NSString *pstrSystem=[pdateformatter stringFromDate:ptimeDate];
    
    NSArray *pAddress =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pDocName =pAddress.firstObject;
    NSString *pPathName =[pDocName stringByAppendingPathComponent:@"Record"];
    NSString *PFileName =[pPathName stringByAppendingPathComponent:pstrSystem];
    const char *pszPath =[PFileName UTF8String];
    NSLog(@"->>>>>> %s", pszPath);

    
     BOOL bRet = FALSE;
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
             if (NULL != lpStreamHandle[i])
             {
                 bRet = NETDEV_SaveRealData(lpStreamHandle[i], pszPath, NETDEV_MEDIA_FILE_MP4);
             }
             if (TRUE != bRet)
             {
                 NSLog(@"NETDEV_SaveRealData failed ");
             }
             else
             {
                 NSLog(@"NETDEV_SaveRealData succeed");
             }
        }
    }
}

/* Stop Local Record */
- (IBAction)StopLocalRecord:(id)sender
{
   BOOL bRet = FALSE;
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            bRet = NETDEV_StopSaveRealData(lpStreamHandle[i]);
          
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_StopSaveRealData failed ");
            }
            else
            {
                NSLog(@"NETDEV_StopSaveRealData succeed");
            }
        }
    }

}

/* Set PTZpreset */
- (IBAction)PTZSet:(id)sender
{
    BOOL bRet = FALSE;
    char szPresetName[NETDEV_LEN_32] = {0};

    NSString *pstrSetText = _SetText.text;
    
    int PresetID = [pstrSetText intValue];// String to int
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZPreset(lpStreamHandle[i], NETDEV_PTZ_SET_PRESET, szPresetName, PresetID);
            }
            else
            {
                bRet = NETDEV_PTZPreset_Other(lpUserID, gdwChlID, NETDEV_PTZ_SET_PRESET, szPresetName, PresetID);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_SET_PRESET failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_SET_PRESET succeed");
            }
        }
    }
}

/* Get PTZpreset */
- (IBAction)PTZGet:(id)sender
{
    BOOL bRet = FALSE;
    if(NULL == lpUserID)
    {
        return;
    }
 
    NETDEV_PTZ_ALLPRESETS_S stPresetList = {0};
    
    bRet = NETDEV_GetPTZPresetList(lpUserID, gdwChlID,&stPresetList);
    
    if(TRUE != bRet)
    {
        NSLog(@"NETDEV_GET_PTZPRESETS failed ");
    }
    else
    {
        NSLog(@"NETDEV_GET_PTZPRESETS succeed");
        
        for(INT32 i=0;i < stPresetList.dwSize ; i++)
        {
            printf("preset: %d, preset ID: %d, preset Name: %s\n",stPresetList.dwSize, stPresetList.astPreset[i].dwPresetID,stPresetList.astPreset[i].szPresetName);
        }
    }
   
}

/* Delet PTZpreset */
- (IBAction)PTZDel:(id)sender
{
    BOOL bRet = FALSE;
    char szPresetName[NETDEV_LEN_32] = {0};
    NSString *string = _DelText.text;
    
    int PretentID = [string intValue];
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZPreset(lpStreamHandle[i], NETDEV_PTZ_CLE_PRESET, szPresetName, PretentID );
            }
            else
            {
                bRet = NETDEV_PTZPreset_Other(lpUserID, gdwChlID, NETDEV_PTZ_CLE_PRESET, szPresetName, PretentID);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_CLE_PRESET failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_CLE_PRESET succeed");
            }
        }
    }

}
/* Goto PTZpreset */
- (IBAction)PTZGoto:(id)sender
{
    BOOL bRet = FALSE;
    char szPresetName[NETDEV_LEN_32] = {0};
    NSString *string = _GoToText.text;
    
    int presetID = [string intValue];

    
    if(NULL == lpUserID)
    {
        return;
    } for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZPreset(lpStreamHandle[i], NETDEV_PTZ_GOTO_PRESET, szPresetName, presetID);
            }
            else
            {
                bRet = NETDEV_PTZPreset_Other(lpUserID, gdwChlID, NETDEV_PTZ_GOTO_PRESET, szPresetName, presetID);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_GOTO_PRESET failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_GOTO_PRESET Succeed");
            }
        }
    }
    

}

/* Set PTZ to the leftup */
- (IBAction)PTVLeftUp:(id)sender
{
    
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i],NETDEV_PTZ_LEFTUP, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_LEFTUP, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_LEFTUP failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_LEFTUP succeed");
            }
        }
    }

    
}

/* Set PTZ to the up */
- (IBAction)PTZUp:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_TILTUP, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_TILTUP, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_TILTUP failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_TILTUP succeed");
            }
        }
    }
    
}

- (IBAction)PTZRightUp:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_RIGHTUP  , dwSpeed);
                
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_RIGHTUP, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_RIGHTUP failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_RIGHTUP success");
            }
        }
    }
    
}

/* Set PTZ to the rightup */
- (IBAction)RightUp:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_RIGHTUP, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_RIGHTUP, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_RIGHTUP failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_RIGHTUP succeed");
            }
        }
    }

}

/* Set PTZ to the left */
- (IBAction)PTZLeft:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_PANLEFT, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_PANLEFT, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_PANLEFT failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_PANLEFT succeed");
            }
        }
    }

}

/* Set PTZ to the right */
- (IBAction)PTZRight:(id)sender
{
    
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_PANRIGHT, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_PANRIGHT, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_PANRIGHT failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_PANRIGHT succeed");
            }
        }
    }
    

}

/* Set PTZ to the leftdown */
- (IBAction)PTZLeftDown:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_LEFTDOWN, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_LEFTDOWN, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_LEFTDOWN ailed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_LEFTDOWN succeed");
            }
        }
    }

}

/* Set PTZ to the down */
- (IBAction)PTZDown:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_TILTDOWN, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_TILTDOWN, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_TILTDOWN failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_TILTDOWN succeed");
            }
        }
    }
}

/* Set PTZ to the rightdown */
- (IBAction)PTZRightDown:(id)sender
{
    BOOL bRet = FALSE;
    
    if(NULL == lpUserID)
    {
        return;
    }
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_RIGHTDOWN, dwSpeed);
            }
            else
            {
                bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_RIGHTDOWN, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_RIGHTDOWN failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_RIGHTDOWN succeed");
            }
        }
    }

}

/* Stop PTZ turning */
- (IBAction)AllStop:(id)sender
{
    BOOL bRet = FALSE;
    for(int i = 0;i<4;i++)
    {
        if(StreamHandle2ChlId[i] == _tv_chlNum.text.intValue)
        {
            if (NULL != lpStreamHandle[i])
            {
                bRet = NETDEV_PTZControl(lpStreamHandle[i], NETDEV_PTZ_ALLSTOP, dwSpeed);
            }
            else
            {
                 bRet = NETDEV_PTZControl_Other(lpUserID,gdwChlID,NETDEV_PTZ_ALLSTOP, dwSpeed);
            }
            
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_PTZ_ALLSTOP failed ");
            }
            else
            {
                NSLog(@"NETDEV_PTZ_ALLSTOP succeed");
            }
        }
    }

    
}


/* Query Channel*/
- (IBAction)QueryChl:(id)sender
{
    INT32 dwChlNum = NETDEMO_CHANNEL_NUM_MAX;
    NSString *strresult;
    BOOL bRet = FALSE;

    memset(&astVideoChlList, 0, sizeof(astVideoChlList));
    
    if(NULL == lpUserID)
    {
        return;
    }
    
    if(1 == gdwLoginDeviceType) /* VMS */
    {
        LPVOID lpDevFindHandle = NETDEV_FindDevList(lpUserID, 0);
        if(NULL == lpDevFindHandle)
        {
            NSLog(@"NETDEV_FindDevList failed ");
            return;
        }
        
        gastLoginDeviceInfo.dwDevNum = 0;
        int dwDevIndex = 0;
        while(true)
        {
            NETDEV_DEV_BASIC_INFO_S stDevBasicInfo = {0};
            if(TRUE != NETDEV_FindNextDevInfo(lpDevFindHandle, &stDevBasicInfo))
            {
                break;
            }
            gastLoginDeviceInfo.stDevLoginInfo[dwDevIndex].stDevBasicInfo = stDevBasicInfo;
            gastLoginDeviceInfo.stDevLoginInfo[dwDevIndex].dwDevIndex = dwDevIndex;
            gastLoginDeviceInfo.dwDevNum++;
            
            LPVOID lpChnFindHandle = NETDEV_FindDevChnList(lpUserID, stDevBasicInfo.dwDevID, NETDEV_CHN_TYPE_ENCODE);
            if(NULL == lpChnFindHandle)
            {
                return;
            }
            else
            {
                gastLoginDeviceInfo.stDevLoginInfo[dwDevIndex].dwChnNum = 0;
                while(true)
                {
                    NETDEV_DEV_CHN_ENCODE_INFO_S stDevChnEncodeInfo = {0};
                    int dwBytesReturned = 0;
                    if(TRUE == NETDEV_FindNextDevChn(lpChnFindHandle, &stDevChnEncodeInfo, sizeof(NETDEV_DEV_CHN_ENCODE_INFO_S), &dwBytesReturned))
                    {
                        printf("NETDEV_FindNextDevChn chn name = %s ,chn num is %d, support ptz is %d\n",stDevChnEncodeInfo.stChnBaseInfo.szChnName, stDevChnEncodeInfo.stChnBaseInfo.dwChannelID, stDevChnEncodeInfo.bSupportPTZ);
                        gastLoginDeviceInfo.stDevLoginInfo[dwDevIndex].vecChanInfo[gastLoginDeviceInfo.stDevLoginInfo[dwDevIndex].dwChnNum] = stDevChnEncodeInfo;
                        gastLoginDeviceInfo.stDevLoginInfo[dwDevIndex].dwChnNum++;
                    }
                    else
                    {
                        break;
                    }
                }
                NETDEV_FindCloseDevChn(lpChnFindHandle);
            }
            dwDevIndex++;
        }
        
        for(int i = 0; i < gastLoginDeviceInfo.dwDevNum; i++)
        {
            for(int j = 0; j < gastLoginDeviceInfo.stDevLoginInfo[i].dwChnNum; j++)
            {
                //demo only output online chn
                if(NETDEV_CHN_STATUS_ONLINE == gastLoginDeviceInfo.stDevLoginInfo[i].vecChanInfo[j].stChnBaseInfo.dwChnStatus)
                {
                    strresult = [NSString stringWithFormat:@"%@%d",strresult,gastLoginDeviceInfo.stDevLoginInfo[i].vecChanInfo[j].stChnBaseInfo.dwChannelID];
                    strresult = [NSString stringWithFormat:@"%@%s",strresult,", "];
                }
            }
            
        }
        
    }
    else /* IPC/VMR */
    {
        bRet = NETDEV_QueryVideoChlDetailList(lpUserID, &dwChlNum, astVideoChlList);
        if(TRUE != bRet)
        {
            NSLog(@"NETDEV_QueryVideoChlDetailList failed ");
        }
        else
        {
            for (int i = 0; i<dwChlNum; i++)
            {
                if(astVideoChlList[i].enStatus == 1)
                {
                    strresult = [NSString stringWithFormat:@"%@%d",strresult,astVideoChlList[i].dwChannelID];
                    strresult = [NSString stringWithFormat:@"%@%s",strresult,", "];
                }
            }
            
            BOOL bGetOnlineChnID = FALSE;
            for(INT32 i = 0; i < dwChlNum; i++)
            {
                printf("channel %d, status : %d",astVideoChlList[i].dwChannelID, astVideoChlList[i].enStatus);
                if (FALSE == bGetOnlineChnID)
                {
                    if(NETDEV_CHL_STATUS_ONLINE == astVideoChlList[i].enStatus)
                    {
                        gdwChlID = astVideoChlList[i].dwChannelID;
                        bGetOnlineChnID = TRUE;
                    }
                }
            }
            
            NSLog(@"NETDEV_QueryVideoChlDetailList succeed");
        }
    }

    _tv_chlList.text = strresult;
}


/* Callback function to obtain the decoded code stream*/
static void NETDEV_DECODE_VIDEO_DATA_CALLBACK(IN LPVOID lpRealHandle,
                                              IN const NETDEV_PICTURE_DATA_S *pstPictureData,
                                              IN LPVOID lpUserParam
                                              )
{
    for(int j = 0; j < 4; j++)
    {
        if(lpRealHandle == lpStreamHandle[j])
        {
            /*Copy the YUV data parse to playbackcell*/
            if ([liveCell[j].lock tryLock])
            {
                liveCell[j].picWith = pstPictureData->dwPicWidth;
                liveCell[j].picHeight = pstPictureData->dwPicHeight;
                for (int i = 0; i < pstPictureData->dwPicHeight; i++) {
                    memcpy(liveCell[j].pucDataY + i * pstPictureData->dwPicWidth, pstPictureData->pucData[0] + i * pstPictureData->dwLineSize[0], pstPictureData->dwPicWidth);
                }
                for (int i = 0; i < pstPictureData->dwPicHeight / 2; i++) {
                    memcpy(liveCell[j].pucDataU + i * pstPictureData->dwPicWidth / 2, pstPictureData->pucData[1] + i * pstPictureData->dwLineSize[1], pstPictureData->dwPicWidth / 2);
                    
                    memcpy(liveCell[j].pucDataV+ i * pstPictureData->dwPicWidth / 2, pstPictureData->pucData[2] + i * pstPictureData->dwLineSize[2], pstPictureData->dwPicWidth / 2);
                }
                liveCell[j].hasVideoData = YES;
                [liveCell[j].lock unlock];
            }
            break;
        }
    }
}

/* Click the screen blank and the keyboard disappears */
- (IBAction)KeyMiss:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark -- UIScrollVIewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == _scrollView1) {
        return _playView;
    } else if (scrollView == _scrollView2) {
        return _playView2;
    } else if (scrollView == _scrollView3) {
        return _playView3;
    } else {
        return _playView4;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    _playView.frame = _shadowView.frame;
    if (_scrollView1.zoomScale < 1.0) {
        _scrollView1.zoomScale = 1.0;
    } else if (_scrollView2.zoomScale < 1.0) {
        _scrollView2.zoomScale = 1.0;
    } else if (_scrollView3.zoomScale < 1.0) {
        _scrollView3.zoomScale = 1.0;
    } else if (_scrollView4.zoomScale < 1.0) {
        _scrollView4.zoomScale = 1.0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    _playView.frame = _shadowView.frame;
}

@end
