
#import "MyDeviceViewController.h"
#import "NetDEVSDK.h"
#import "PlaybackViewController.h"
#import "LocalLoginViewController.h"
#import "common.h"

LPVOID  lpUserID;  //User ID
extern INT32 gdwChlID;
extern int gdwLoginDeviceType;
extern NETDEMO_DEV_LOGININFO_S gastLoginDeviceInfo;

NSString* strDeviceSN;
extern BOOL isbNoaccountFlag;

@interface MyDeviceViewController ()

@end

@implementation MyDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)gotoMain
{
    MainViewController *pViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"Tab"];
    UINavigationController *pNavCtrol = [[UINavigationController alloc] initWithRootViewController:pViewCtrl];
    
    [self presentViewController:pNavCtrol animated:YES completion:nil];
}

/*Logout*/
- (IBAction)Logout:(id)sender
{
    if(TRUE != NETDEV_Logout(lpUserID))
    {
        NSLog(@"NETDEV_Logout failure");
    }
    else
    {
        NSLog(@"NETDEV_Logout success");
    }
    gdwLoginDeviceType = 0;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/* Get Device Channel Information */
- (IBAction)GetDeviceChlInfo:(id)sender
{
    BOOL bRet = FALSE;
    if(NULL == lpUserID)
    {
        return;
    }
    
    NETDEV_DEVICE_BASICINFO_S stDeviceInfo = {0};
    INT32 dwOutBufferSize = sizeof(stDeviceInfo);
    
    bRet = NETDEV_GetDevConfig(lpUserID, gdwChlID, NETDEV_GET_DEVICECFG , &stDeviceInfo, dwOutBufferSize, &dwOutBufferSize);
    
    if(TRUE != bRet)
    {
        NSLog(@"Get Device Info Failed ");
    }
    else
    {
        NSLog(@"Get Device Info Success");
       
        printf("DevName: %s, DevAdd: %s, DevModel: %s, FirmwareVersion:%s, DevSerailNum: %s",stDeviceInfo.szDeviceName, stDeviceInfo.szMacAddress,stDeviceInfo.szDevModel,stDeviceInfo.szFirmwareVersion,stDeviceInfo.szSerialNum);
       
    }

}

@end
