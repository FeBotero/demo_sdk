
#import "AlarmInfoViewController.h"
#import "UVViewController.h"
#import "LocalLoginViewController.h"

#import "LiveViewController.h"
#import "NETDEVSDK.h"
#import "UILIVECELL.h"
#import "PlaybackViewController.h"
#import "UVAirPlayerView.h"


extern LPVOID lpUserID;
extern LPVOID lpStreamHandle;
extern NSString* m_strAlarm;
@interface AlarmInfoViewController ()

-(void)setAlarmInfo:(NSString*)strAlarmInfo;
@end

@implementation AlarmInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAlarmInfo:(NSString*)strAlarmInfo
{
   // _m_objAlarmInfo.sert = strAlarmInfo;
   
    return;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)TouchAlarm:(id)sender
{
    if(nil == m_strAlarm  )
    {
        return;
    }
    
    _m_objAlarmInfo.text = [NSString stringWithFormat:@"%@", m_strAlarm];
}
- (IBAction)findfile:(id)sender
{
    NETDEV_MONTH_INFO_S pstMonthInfo;
    NETDEV_MONTH_STATUS_S pstMonthStatus;
    pstMonthInfo.udwYear = 2019;
    pstMonthInfo.udwMonth = 5;
    pstMonthInfo.udwPosition = 1;
    NETDEV_QuickSearch(lpUserID,1,&pstMonthInfo,&pstMonthStatus);
    
    NSString *strresult;
    strresult = [NSString stringWithFormat:@"%s","Day nums is : "];
    strresult = [NSString stringWithFormat:@"%@%u",strresult,pstMonthStatus.udwDayNumInMonth];
    strresult = [NSString stringWithFormat:@"%@%s",strresult,"\n"];
    
    for(INT32 i = 0;i<pstMonthStatus.udwDayNumInMonth;i++)
    {
        strresult = [NSString stringWithFormat:@"%@%s",strresult,"video statu is : "];
        strresult = [NSString stringWithFormat:@"%@%u",strresult,pstMonthStatus.szVideoStatus[i]];
        strresult = [NSString stringWithFormat:@"%@%s",strresult,"\n"];
    }
    _findresult.text = strresult;
}
-(void)viewWillAppear:(BOOL)animated {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
- (IBAction)GetTime:(id)sender
{
    NETDEV_TIME_CFG_S pstSystemTimeInfo;
    INT32 Rit = NETDEV_GetSystemTimeCfg(lpUserID,&pstSystemTimeInfo);
    
    NSString *strresult;
    strresult = [NSString stringWithFormat:@"%d",pstSystemTimeInfo.stTime.dwYear];
    strresult = [NSString stringWithFormat:@"%@%s",strresult,"-"];
    strresult = [NSString stringWithFormat:@"%@%d",strresult,pstSystemTimeInfo.stTime.dwMonth];
    strresult = [NSString stringWithFormat:@"%@%s",strresult,"-"];
    strresult = [NSString stringWithFormat:@"%@%d",strresult,pstSystemTimeInfo.stTime.dwDay];
    strresult = [NSString stringWithFormat:@"%@%s",strresult," "];
    strresult = [NSString stringWithFormat:@"%@%d",strresult,pstSystemTimeInfo.stTime.dwHour];
    strresult = [NSString stringWithFormat:@"%@%s",strresult,":"];
    strresult = [NSString stringWithFormat:@"%@%d",strresult,pstSystemTimeInfo.stTime.dwMinute];
    strresult = [NSString stringWithFormat:@"%@%s",strresult,":"];
    strresult = [NSString stringWithFormat:@"%@%d",strresult,pstSystemTimeInfo.stTime.dwSecond];
    _timeshow.text = strresult;
}

@end
