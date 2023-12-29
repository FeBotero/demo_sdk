//
//  LiveViewController.h
//  demo



#import <UIKit/UIKit.h>
#import "UVViewController.h"
#import "OpenGLView20.h"
#import "UVAirPlayerView.h"
@interface LiveViewController : UIViewController

@property (weak, nonatomic) IBOutlet UVAirPlayerView *playView;//Play window, which inherits the OpenGLView20 method
@property (weak, nonatomic) IBOutlet UVAirPlayerView *playView2;

@property (weak, nonatomic) IBOutlet UVAirPlayerView *playView3;
@property (weak, nonatomic) IBOutlet UVAirPlayerView *playView4;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet UIView *shadowView1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIView *shadowView2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView3;
@property (weak, nonatomic) IBOutlet UIView *shadwoView3;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView4;
@property (weak, nonatomic) IBOutlet UIView *shadowView4;

@property (weak, nonatomic)  NSTimer * mytimer;//Timer, used to refresh the playback

- (IBAction)exit_live:(id)sender;
- (IBAction)Snapshot:(id)sender;
- (IBAction)StartLocalRecord:(id)sender;
- (IBAction)StopLocalRecord:(id)sender;
- (IBAction)PTZSet:(id)sender;
- (IBAction)PTZGet:(id)sender;
- (IBAction)PTZDel:(id)sender;
- (IBAction)PTZGoto:(id)sender;
- (IBAction)PTZUp:(id)sender;
- (IBAction)PTZLeft:(id)sender;
- (IBAction)PTZRight:(id)sender;
- (IBAction)PTZLeftDown:(id)sender;
- (IBAction)PTZDown:(id)sender;
- (IBAction)PTZRightDown:(id)sender;
- (IBAction)RightUp:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *channel;
@property (weak, nonatomic) IBOutlet UITextField *SetText;
@property (weak, nonatomic) IBOutlet UITextField *DelText;
@property (weak, nonatomic) IBOutlet UITextField *GoToText;



- (IBAction)QueryChl:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *tv_chlList;
@property (strong, nonatomic) IBOutlet UITextField *tv_chlNum;

-(void) liveplay;//Play stream

+ (void)setInputData:(char*)pcmData andLength:(size_t)pcmLength;

@end
