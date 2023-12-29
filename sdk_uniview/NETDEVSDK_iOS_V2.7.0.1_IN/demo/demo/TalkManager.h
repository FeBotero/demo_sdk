#import <Foundation/Foundation.h>

@interface TalkManager : NSObject

@property (nonatomic,copy)NSString *ip;
@property (nonatomic,assign)int port;
@property (nonatomic,copy)NSString *url;

+ (instancetype)manager;
- (void)startTalk;
- (void)stopTalk;
- (void)playVoice:(NSData *)pcmData;

@end
