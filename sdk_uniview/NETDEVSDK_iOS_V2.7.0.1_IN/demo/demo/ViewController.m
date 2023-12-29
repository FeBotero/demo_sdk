 //
//  ViewController.m
//  demo
//


#import "ViewController.h"
#import "PlaybackViewController.h"
#import "AlarmInfoViewController.h"
#import "NetDEVSDK.h"

//LPVOID  lpUserID;//User ID

BOOL isbNoaccountFlag;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Go to master page */
- (void)gotoMain
{
    MainViewController *pViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"Tab"];
   UINavigationController *pNavCtrol = [[UINavigationController alloc] initWithRootViewController:pViewCtrl];
    
   [self presentViewController:pNavCtrol animated:YES completion:nil];
}

/* Click the blank space to remove the virtual keyboard */
- (IBAction)dismissKeyboard:(id)sender
{
   [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
