#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PCMPlayer : NSObject

// 播放
- (void)playWithData:(NSData *)data;
- (void) stop;

@end
