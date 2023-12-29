//
//  ViewController.h
//  demo
//


#import "UVViewController.h"
#import <ntsid.h>

@interface ViewController : UVViewController

@property (weak, nonatomic) IBOutlet UITextField *txtIp;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UITextField *txtPort;
- (IBAction)onLoginSender:(id)sender;
@end

