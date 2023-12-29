
#import "UVViewController.h"
#import "MBProgressHUD.h"

#define UV_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@interface UVViewController ()
{
    MBProgressHUD *_hub;
}
@end

@implementation UVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(UV_IOS_VERSION>=7.f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showProgress
{
    [self hideProgress];
    _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)hideProgress
{
    if(_hub != nil)
    {
        [_hub removeFromSuperview];
        [_hub hide:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
