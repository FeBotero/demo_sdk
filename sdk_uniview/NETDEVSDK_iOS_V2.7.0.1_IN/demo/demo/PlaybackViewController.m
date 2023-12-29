
#import "PlaybackViewController.h"
#import "NetDEVSDK.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AVFoundation/AVFoundation.h>
#import "PCMPlayer.h"
#import "UILIVECELL.h"
#import "UVAirPlayerView.h"

extern LPVOID lpUserID;  // User ID
 INT32 PlaySpeed ;
LPVOID lpStreamHandle[4];  //The video stream handle
LPVOID lpDownloadhandle[255];
NETDEV_FINDDATA_S m_astVodFile[100];  //Video info found, array size can be modified as needed
LPVOID Talkhandle;
PCMPlayer *pPcmDataPlayer;
UILIVECELL *Playbackplay[4] ;  //Playback box used to temporarily store video callback data
INT32 Channel;
BOOL winHavePlay[4];

@interface MainViewController ()<UIScrollViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView3;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView4;

@end

@implementation MainViewController
{
    UIDatePicker *myDatePicker;
    UIView *bgView;
    NSTimeInterval _startTime;
    NSTimeInterval _endSelectTime;
    BOOL _isSelectStartTime;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onExitSender:)];
    self.navigationController.navigationItem.rightBarButtonItem = right;
    
    for(int i = 0;i <4;i++)
    {
        Playbackplay[i] = [[UILIVECELL alloc] init];
        Playbackplay[i].hasVideoData = NO;
        winHavePlay[i] = false;
        lpStreamHandle[i] = NULL;
        lpDownloadhandle[i] = NULL;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });

    
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
    
    // Do any additional setup after loading the view.
}
#pragma mark -- UIScrollVIewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == _scrollView1) {
        return _PlayView;
    } else if (scrollView == _scrollView2) {
        return _PlayView2;
    } else if (scrollView == _scrollView3) {
        return _PlayView3;
    } else {
        return _PlayView4;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

#pragma mark - sender


/*
 Play the playback process：
 1、find video to get file info, call the file to get video stream handle ulStreamHandle；
 2、Call NETDEV_SetPlayDecodeVideoCB to set the callback function to obtain the decoded code stream (YUV format)；
 3、in the callback function, the YUV data that stores one frame of image to be resolved；
 4、Set the timer, use openGL method to render the YUV data of a frame image to the screen, and periodically refresh to form video
 
 */

/* Search by time */
- (IBAction)onSearchRecordSender:(id)sender
{
    Channel = _PlayBackchl.text.intValue;
    NETDEV_FILECOND_S stFileCond = {0};
    stFileCond.dwChannelID = Channel;;
    LPVOID dwFileHandle = 0;
    memset(m_astVodFile,0,sizeof(m_astVodFile));
    
    NSString *strSearchResult = @"BeginTime                    EndTime";
    strSearchResult= [NSString stringWithFormat:@"%@%s",strSearchResult,"\n"];
    _SearchVideoResult.text = strSearchResult;
    
    /* UTC time. */
    if(_startTime == 0 || _endSelectTime == 0)
    {
        stFileCond.tBeginTime = time(NULL) - 24*3600;
        stFileCond.tEndTime = time(NULL);
    }
    else
    {
        stFileCond.tBeginTime = _startTime;
        stFileCond.tEndTime = _endSelectTime;
    }
    
    /*Add video retrieval conditions, such as by motion detection events*/
    //stFileCond.dwFileType = NETDEV_EVENT_STORE_TYPE_MOTIONDETECTION;
    
    dwFileHandle = NETDEV_FindFile(lpUserID,&stFileCond);

    if(NULL == dwFileHandle)
    {
        NSLog(@"Search record failed.");
        _SearchResult.text =@"failed";
        _SearchVideoResult.text = strSearchResult;
        return;
    }
    else
    {
        _SearchResult.text =@"Succeed";
        
        BOOL bRet = TRUE;
        int i = 0;
        while(bRet && i < 100)
        {
            NETDEV_FINDDATA_S stVodFile = {0};//Recording query data
            bRet = NETDEV_FindNextFile(dwFileHandle, &stVodFile);  //Get info about found files one by one
            if(TRUE != bRet)
            {
                NSLog(@"NETDEV_FindNextFile record failed.");
                break;
            }
            else
            {
                /* Save each recording found */
                strncpy(m_astVodFile[i].szFileName, stVodFile.szFileName, sizeof(m_astVodFile[i].szFileName) - 1);
                m_astVodFile[i].tBeginTime = stVodFile.tBeginTime;
                m_astVodFile[i].tEndTime = stVodFile.tEndTime;
                m_astVodFile[i].byFileType = stVodFile.byFileType;
                
                struct tm *pTime = localtime((time_t*)&stVodFile.tBeginTime);
                NSString *strBeginLocalTime = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d/%d/%d %d:%d:%d",pTime->tm_year + 1900,pTime->tm_mon+1,pTime->tm_mday,pTime->tm_hour,pTime->tm_min,pTime->tm_sec]];
                
                struct tm *pTime1 = localtime((time_t*)&stVodFile.tEndTime);
                NSString *strEndLocalTime = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%d/%d/%d %d:%d:%d",pTime1->tm_year + 1900,pTime1->tm_mon+1,pTime1->tm_mday,pTime1->tm_hour,pTime1->tm_min,pTime1->tm_sec]];
                
                NSString *str= [NSString stringWithFormat:@"%d-- %@--  %@",i,strBeginLocalTime,strEndLocalTime];
                strSearchResult= [NSString stringWithFormat:@"%@%@",strSearchResult,str];
                strSearchResult= [NSString stringWithFormat:@"%@%s",strSearchResult,"\n"];
                NSLog(@"video%d:%@---%@",i,strBeginLocalTime,strEndLocalTime);  //print out the time period of the query video, and provide a choice for the time playing interface
                i++;
            }
        }
        _SearchVideoResult.text = strSearchResult;
    }
    
    NETDEV_FindClose(dwFileHandle);  //Close file search and release resources
}

-(void)viewWillAppear:(BOOL)animated {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
/* Playback by time */
- (IBAction)onPlayBackbytimeSender:(id)sender
{
    INT32 PlayNumber = _playlistnums.text.intValue;
    if(NULL == lpUserID ||
       PlayNumber >= sizeof(m_astVodFile)/sizeof(NETDEV_FINDDATA_S) ||
       PlayNumber < 0)
    {
        return;
    }
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
        NETDEV_PLAYBACKCOND_S stPlayBackByTimeInfo = {0};  //Parameters of play back by time
        
        /* Assume to play the first recording found */
        stPlayBackByTimeInfo.tBeginTime = m_astVodFile[PlayNumber].tBeginTime;  //Refer to the interface for searching by time to set the value
        stPlayBackByTimeInfo.tEndTime = m_astVodFile[PlayNumber].tEndTime;  // Refer to the interface for searching by time to set the value
        if(0 == stPlayBackByTimeInfo.tBeginTime ||
           0 == stPlayBackByTimeInfo.tEndTime){
            NSLog(@"NETDEV_PlayBackByTime，BeginTime or EndTime is 0");
	    return;
        }
    stPlayBackByTimeInfo.dwChannelID = Channel;  //Consistent with the channel in the search video
        stPlayBackByTimeInfo.dwLinkMode = NETDEV_TRANSPROTOCAL_RTPTCP;  //Media transport protocol
    stPlayBackByTimeInfo.dwPlaySpeed = NETDEV_PLAY_STATUS_1_FORWARD;
    #define PLAY_FPS 25//Timer，refresh and display picture for playing live
        _mytimer=[NSTimer scheduledTimerWithTimeInterval:1.0/PLAY_FPS target:self selector:@selector(Playbackplay) userInfo:nil repeats:YES];
        
        lpStreamHandle[i] = NETDEV_PlayBackByTime(lpUserID, &stPlayBackByTimeInfo);  //Play back recording files by time
        if(NULL == lpStreamHandle[i])
        {
            NSLog(@"NETDEV_PlayBackByTimeo failed.");
        }
        else
        {
            NSLog(@"NETDEV_PlayBackByTime succeed.");
            if(TRUE != NETDEV_SetPlayDecodeVideoCB(lpStreamHandle[i], NETDEV_DECODE_Playback_DATA_CALLBACK, TRUE, lpUserID))
            {
                NSLog(@"NETDEV_DECODE_Playback_DATA_CALLBACK failed");
            }
            else
            {
                winHavePlay[i] = YES;
                NSLog(@"NETDEV_DECODE_Playback_DATA_CALLBACK succeed");
            }

        }
          BOOL bRet = NETDEV_PlayBackControl(lpStreamHandle[i], NETDEV_PLAY_CTRL_GETPLAYSPEED, &PlaySpeed);//Get paly speed
        if (TRUE != bRet)
        {
            winHavePlay[i] = NO;
            NSLog(@"NETDEV_PLAY_CTRL_GETPLAYSPEED failed.");
        }
    
}


static void NETDEV_DECODE_Playback_DATA_CALLBACK(IN LPVOID lpRealHandle,
                                              IN const NETDEV_PICTURE_DATA_S *pstPictureData,
                                              IN LPVOID lpUserParam
                                              )
{
    for(int j = 0; j < 4; j++)
    {
        if(lpRealHandle == lpStreamHandle[j])
        {
            /*Copy the YUV data parse to livecell*/
            if ([Playbackplay[j].lock tryLock])
            {
                Playbackplay[j].picWith = pstPictureData->dwPicWidth;
                Playbackplay[j].picHeight = pstPictureData->dwPicHeight;
                for (int i = 0; i < pstPictureData->dwPicHeight; i++) {
                    memcpy(Playbackplay[j].pucDataY + i * pstPictureData->dwPicWidth, pstPictureData->pucData[0] + i * pstPictureData->dwLineSize[0], pstPictureData->dwPicWidth);
                }
                for (int i = 0; i < pstPictureData->dwPicHeight / 2; i++) {
                    memcpy(Playbackplay[j].pucDataU + i * pstPictureData->dwPicWidth / 2, pstPictureData->pucData[1] + i * pstPictureData->dwLineSize[1], pstPictureData->dwPicWidth / 2);
                    
                    memcpy(Playbackplay[j].pucDataV + i * pstPictureData->dwPicWidth / 2, pstPictureData->pucData[2] + i * pstPictureData->dwLineSize[2], pstPictureData->dwPicWidth / 2);
                }
                Playbackplay[j].hasVideoData = YES;
                [Playbackplay[j].lock unlock];
                break;
            }
        }

    }
}

-(void)Playbackplay
{
    for(int i = 0;i<4;i++)
    {
        if(Playbackplay[i].hasVideoData)  //Determines whether there is data in the livecell
        {
            void* lpDisplayData = malloc(sizeof(char) * (MAX_Y_SIZE + MAX_UV_SIZE * 2));
            int dwHeight = Playbackplay[i].picHeight;
            int dwWidth = Playbackplay[i].picWith;
            long size = dwWidth * dwHeight * sizeof(char);
            
            /*Copy the YUV data to _displayData*/
            memcpy(lpDisplayData, Playbackplay[i].pucDataY, size);
            memcpy(lpDisplayData + size, Playbackplay[i].pucDataU, size / 4);
            memcpy(lpDisplayData + size * 5 / 4, Playbackplay[i].pucDataV, size / 4);
            
            /*Render the YUV image data in _displayData to the _playView play window through openGL*/
            //[_PlayView displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            if(0 == i)
            {
                [_PlayView displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            else if(1 == i)
            {
                [_PlayView2 displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            else if (2 == i)
            {
                [_PlayView3 displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            else
            {
                [_PlayView4 displayYUV420pData:lpDisplayData width:dwWidth height:dwHeight];
            }
            Playbackplay[i].hasVideoData = NO;
            free(lpDisplayData);
        }
    }
}



/*Stop Playback*/
- (IBAction)StopPlaybacksender
{
    INT32 StopNum = _stopchlnum.text.intValue - 1;
    if(NULL == lpUserID)
    {
        return;
    }
    
    if(NULL == lpStreamHandle[StopNum])
    {
        return;
    }
    
    BOOL bRet = NETDEV_StopPlayBack(lpStreamHandle[StopNum]);
    if (TRUE != bRet)
    {
        NSLog(@"NETDEV_StopPlayBack failed.");
    }
    else
    {
        NSLog(@"NETDEV_StopPlayBack succeed.");
    }
    
    lpStreamHandle[StopNum] = NULL;
    Playbackplay[StopNum].hasVideoData = NO;
    winHavePlay[StopNum] = NO;
    return;
}

/*Pause Playback*/
- (IBAction)PlayCtrlPausesender
{
    INT32 PauseNum = _stopchlnum.text.intValue - 1;
    if(NULL == lpUserID)
    {
        return ;
    }
    
    if(NULL == lpStreamHandle[PauseNum])
    {
        NSLog(@"PlayCtrlPausesender lpStreamHandle is NULL");
        return ;
    }
        
    BOOL bRet = NETDEV_PlayBackControl(lpStreamHandle[PauseNum], NETDEV_PLAY_CTRL_PAUSE, NULL);
    if(TRUE != bRet)
    {
        NSLog(@"NETDEV_PLAY_CTRL_PAUSE failed.");
    }
    else
    {
        NSLog(@"NETDEV_PLAY_CTRL_PAUSE succeed.");
    }
    return;
}

/* Play Resume */
- (IBAction)PlayCtrlResumesender
{
    if(NULL == lpUserID)
    {
        return;
    }
    
    INT32 ResumeNum = _stopchlnum.text.intValue - 1;

    if(NULL == lpStreamHandle[ResumeNum])
    {
        NSLog(@"PlayCtrlResumesender lpStreamHandle is NULL");
        return;
    }
    BOOL bRet1 = NETDEV_PlayBackControl(lpStreamHandle[ResumeNum],  NETDEV_PLAY_CTRL_SETPLAYSPEED, &PlaySpeed);
        
    if(TRUE != bRet1)
    {
        NSLog(@"NETDEV_PLAY_CTRL_SETPLAYSPEED failed.");
    }
    else
    {
        NSLog(@"NETDEV_PLAY_CTRL_SETPLAYSPEED succeed.");
    }
        
    BOOL bRet = NETDEV_PlayBackControl(lpStreamHandle[ResumeNum], NETDEV_PLAY_CTRL_RESUME, NULL);
    if(TRUE != bRet)
    {
        NSLog(@"NETDEV_PLAY_CTRL_RESUME failed.");
    }
    else
    {
        NSLog(@"NETDEV_PLAY_CTRL_RESUME succuss.");
    }

    return;
}

/* Backward */
- (IBAction)PlayBackwardsender
{
    INT32 BackwardNum = _stopchlnum.text.intValue - 1;
    
    if(NULL == lpStreamHandle[BackwardNum])
    {
        NSLog(@"PlayBackwardsender lpStreamHandle is NULL");
        return;
    }
    
    INT32 enSpeed = 0;
    BOOL bRet = NETDEV_PlayBackControl(lpStreamHandle[BackwardNum], NETDEV_PLAY_CTRL_GETPLAYSPEED, &enSpeed);//Get play speed
    if (TRUE != bRet)
    {
        NSLog(@"NETDEV_PLAY_CTRL_GETPLAYSPEED failed.");
    }
    
    switch (enSpeed) {
        case NETDEV_PLAY_STATUS_1_FORWARD:
            enSpeed = NETDEV_PLAY_STATUS_1_BACKWARD;
            break;
        case NETDEV_PLAY_STATUS_1_BACKWARD:
            enSpeed = NETDEV_PLAY_STATUS_2_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_2_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_4_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_4_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_8_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_8_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_16_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_16_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_16_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_16_FORWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_8_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_8_FORWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_4_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_4_FORWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_2_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_2_FORWARD_IFRAME:
            enSpeed =NETDEV_PLAY_STATUS_1_FORWARD;
        default:
            break;
        }
        
        
        bRet = NETDEV_PlayBackControl(lpStreamHandle[BackwardNum], NETDEV_PLAY_CTRL_SETPLAYSPEED, &enSpeed);//Set play speed
        if(TRUE != bRet)
        {
            NSLog(@"Set  Backward failed.");
        }
}

/* Forward */
- (IBAction)Playforwardsender
{
    INT32 ForwardwordNum = _stopchlnum.text.intValue - 1;
    
    if(NULL == lpStreamHandle[ForwardwordNum])
    {
        NSLog(@"Playforwardsender lpStreamHandle is NULL");
        return;
    }
    
    INT32 enSpeed = 0;
        
    BOOL bRet = NETDEV_PlayBackControl(lpStreamHandle[ForwardwordNum], NETDEV_PLAY_CTRL_GETPLAYSPEED, &enSpeed);  //Get play speed
    
    if(TRUE != bRet)
    {
        NSLog(@"NETDEV_PLAY_CTRL_GETPLAYSPEED failed.");
    }
    
    switch (enSpeed) {
        case NETDEV_PLAY_STATUS_1_FORWARD:
            enSpeed = NETDEV_PLAY_STATUS_2_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_2_FORWARD_IFRAME:
                enSpeed = NETDEV_PLAY_STATUS_4_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_4_FORWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_8_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_8_FORWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_16_FORWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_16_FORWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_16_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_16_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_8_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_8_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_4_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_4_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_2_BACKWARD_IFRAME;
            break;
        case NETDEV_PLAY_STATUS_2_BACKWARD_IFRAME:
            enSpeed = NETDEV_PLAY_STATUS_1_BACKWARD;
            break;
        case NETDEV_PLAY_STATUS_1_BACKWARD:
            enSpeed =NETDEV_PLAY_STATUS_1_FORWARD;
        default:
            break;
        }
        
        bRet = NETDEV_PlayBackControl(lpStreamHandle[ForwardwordNum], NETDEV_PLAY_CTRL_SETPLAYSPEED, &enSpeed);  //Set play speed
        if(TRUE != bRet)
        {
            NSLog(@"Set forward failed.");
        }
        else
        {
            NSLog(@"Set forward succeed.");
        }
}

/* Start Downloading Vedio */
- (IBAction)StartDownload:(id)sender
{
    INT32 FileNum = _playlistnums.text.intValue;
    if(NULL == lpUserID ||
       FileNum >= sizeof(m_astVodFile)/sizeof(NETDEV_FINDDATA_S) ||
       FileNum < 0)
    {
        return;
    }
    
    NSDate *ptimeDate=[NSDate date];
    NSDateFormatter  *pdateformatter=[[NSDateFormatter alloc] init];
    [pdateformatter setDateFormat:@"HH:mm:ss"];
    NSString *pstrSystem=[pdateformatter stringFromDate:ptimeDate];

    NETDEV_PLAYBACKCOND_S  stPlayBackCond = {0};
    BOOL bRet = FALSE;
            
    NSArray *pAddress =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pDocName =pAddress.firstObject;
    NSString *pPathName =[pDocName stringByAppendingPathComponent:@"Playback"];
    NSString *PFileName =[pPathName stringByAppendingPathComponent:pstrSystem];
    const char *pszPath =[PFileName UTF8String];
    NSLog(@"->>>>>> %s", pszPath);
            
    stPlayBackCond.dwChannelID = Channel;
    stPlayBackCond.tBeginTime = m_astVodFile[FileNum].tBeginTime;
    stPlayBackCond.tEndTime = m_astVodFile[FileNum].tEndTime;
    if(0 == stPlayBackCond.tBeginTime ||
       0 == stPlayBackCond.tEndTime){
            NSLog(@"NETDEV_GetFileByTime，BeginTime or EndTime is 0");
            return;
    }
    stPlayBackCond.dwDownloadSpeed = NETDEV_DOWNLOAD_SPEED_EIGHT;
    stPlayBackCond.dwFileType = NETDEV_TYPE_STORE_TYPE_ALL;
    stPlayBackCond.dwLinkMode = NETDEV_TRANSPROTOCAL_RTPTCP;
    stPlayBackCond.hPlayWnd = NULL;
        
    lpDownloadhandle[FileNum] = NETDEV_GetFileByTime(lpUserID,  &stPlayBackCond, pszPath , NETDEV_MEDIA_FILE_MP4);
    NSString *title;
    if(FALSE == lpDownloadhandle[FileNum])
    {
        title = @"Download failed";
        NSLog(@"NETDEV_GetFileByTime failed ");
    }
    else
    {
        title = @"Start downloading...";
        NSLog(@"NETDEV_GetFileByTime succeed");
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}

/* Stop Downloading Vedio */
- (IBAction)StopDownload:(id)sender
{
    INT32 FileNum = _playlistnums.text.intValue;
    if(NULL == lpUserID)
    {
        return;
    }
    if (NULL == lpDownloadhandle[FileNum])
    {
        return;
    }
    BOOL bRet = NETDEV_StopGetFile(lpDownloadhandle[FileNum]);
    if (TRUE != bRet)
    {
        NSLog(@"NETDEV_StopGetFile failed.");
    }
    else
    {
        lpDownloadhandle[FileNum] = NULL;
        NSLog(@"NETDEV_StopGetFile succeed");
    }
}


- (void)initDatePickerView {
    UIView *coverBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 350)];
    coverBgView.center = self.view.center;
    coverBgView.backgroundColor = [UIColor grayColor];
    myDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, coverBgView.bounds.size.width, 300)];
    [coverBgView addSubview:myDatePicker];
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, coverBgView.bounds.size.width, 50)];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmSelectedTime) forControlEvents:UIControlEventTouchUpInside];
    [coverBgView addSubview:confirmBtn];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView addSubview:coverBgView];
    
    // 设置日期选择控件的地区
//    [myDatePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [myDatePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_SC"]];
    
    //默认为当天。
    [myDatePicker setCalendar:[NSCalendar currentCalendar]];
    //    设置DatePicker的时区。
    
    //    默认为设置为：[datePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //    设置DatePicker的日期。
    
    //    默认设置为:
    
    [myDatePicker setDate:[NSDate date]];
    
    //    minimumDate设置DatePicker的允许的最小日期。
    
    //    maximumDate设置DatePicker的允许的最大日期
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:10];//设置最大时间为：当前时间推后10天
    
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [comps setDay:0];//设置最小时间为：当前时间
    
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
//    [myDatePicker setMaximumDate:maxDate];
    
//    [myDatePicker setMinimumDate:minDate];
    
    [self.view addSubview:bgView];
}

- (IBAction)startBeginTime:(id)sender {
    _isSelectStartTime = YES;
    [self initDatePickerView];
}

- (IBAction)endTimeBtn:(id)sender {
    _isSelectStartTime = NO;
    [self initDatePickerView];
}

- (void)confirmSelectedTime {
    NSTimeInterval time = [myDatePicker.date timeIntervalSince1970];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeString = [formatter stringFromDate:myDatePicker.date];
    if (_isSelectStartTime) {
        _startTime = time;
        _startTimeLabel.text = timeString;
    } else {
        _endSelectTime = time;
        _endTimeLabel.text = timeString;
    }
    [bgView removeFromSuperview];
    
}

@end
