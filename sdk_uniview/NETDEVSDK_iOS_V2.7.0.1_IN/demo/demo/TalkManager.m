#import "TalkManager.h"
#import "PCMPlayer.h"

@interface TalkManager ()
@property (nonatomic, strong) PCMPlayer *aqplayer;
@end

@implementation TalkManager

+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    if ( self = [super init]) {
    }
    return self;
}

- (void)startTalk {
    _aqplayer = [[PCMPlayer alloc] init];
}

- (void)stopTalk {
    [self->_aqplayer stop];
    _aqplayer = nil;
}

- (void)playVoice:(NSData *)pcmData {
        [self->_aqplayer playWithData:pcmData];
}

@end
