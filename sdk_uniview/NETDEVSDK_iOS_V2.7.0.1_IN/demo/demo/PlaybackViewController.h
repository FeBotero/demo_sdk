//
//  MainViewController.h
//  demo


#import "UVViewController.h"
#import "NETDEVSDK.h"
#import "UVAirPlayerView.h"


@interface MainViewController : UVViewController

@property (weak, nonatomic) IBOutlet UIButton *btnStartLive;
@property (weak, nonatomic)  NSTimer * mytimer;//The timer is used to refresh the playback



- (IBAction)StartDownload:(id)sender;
- (IBAction)StopDownload:(id)sender;
@property (weak, nonatomic) IBOutlet UVAirPlayerView *PlayView;
@property (strong, nonatomic) IBOutlet UVAirPlayerView *PlayView2;
@property (strong, nonatomic) IBOutlet UVAirPlayerView *PlayView3;
@property (strong, nonatomic) IBOutlet UVAirPlayerView *PlayView4;
@property (strong, nonatomic) IBOutlet UITextField *PlayBackchl;
@property (strong, nonatomic) IBOutlet UITextField *SearchResult;
@property (strong, nonatomic) IBOutlet UITextView *SearchVideoResult;
@property (strong, nonatomic) IBOutlet UITextField *playlistnums;
@property (strong, nonatomic) IBOutlet UITextField *stopchlnum;
-(void) Playbackplay;
@property (weak, nonatomic) IBOutlet UITextField *startTimeInput;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end
