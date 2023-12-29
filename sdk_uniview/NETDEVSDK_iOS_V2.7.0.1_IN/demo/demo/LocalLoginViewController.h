//
//  CloudLoginViewController.h
//  demo
//
//  Created by smbapp on 17/7/22.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetDEVSDK.h"

@interface CloudLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *LocalIP;
@property (weak, nonatomic) IBOutlet UITextField *LocalPort;
@property (weak, nonatomic) IBOutlet UITextField *LocalUser;
@property (weak, nonatomic) IBOutlet UITextField *LocalPW;
@property (weak, nonatomic) IBOutlet UISegmentedControl *LoginDeviceType;

- (IBAction)Locallogin:(id)sender;
void NETDEV_AlarmMessCallBack(IN LPVOID    lpUserID,
                              IN NETDEV_ALARM_INFO_EX_S   stAlarmInfo,
                              IN LPVOID    lpUserData);
void NETDEV_AlarmMessCallBackV30(IN LPVOID lpUserID,
                                 IN LPNETDEV_REPORT_INFO_S pstReportInfo,
                                 IN LPVOID    lpBuf,
                                 IN INT32     dwBufLen,
                                 IN LPVOID    lpUserData);
void NETDEV_ExceptionCallBack(IN LPVOID    lpUserID,
                              IN INT32     dwType,
                              IN LPVOID    lpExpHandle,
                              IN LPVOID    lpUserData
                              );
@end
