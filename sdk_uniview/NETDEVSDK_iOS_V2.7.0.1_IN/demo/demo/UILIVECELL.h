//
//  UILIVECELL.h
//  demo


#import <UIKit/UIKit.h>
#define MAX_Y_SIZE (4096 * 3072)
#define MAX_UV_SIZE (MAX_Y_SIZE / 4)

@interface UILIVECELL : NSObject
@property(nonatomic, assign)unsigned int liveCellId;

@property(nonatomic, assign)int liveIndex;

/**
 *    Cell state
 */
//@property(nonatomic, assign)UVLiveCellStatus cellStatus;

/**
 *    Channel information
 */
//@property(nonatomic, strong)UVChannelInfoBean *channelInfo;

/**
 *    Lock
 */
@property (nonatomic, strong) NSLock *lock;

/**
 *    whether there is YUV data
 */
@property(nonatomic, assign)BOOL hasVideoData;

/**
 *    YUV width
 */
@property(nonatomic, assign)int picWith;

/**
 *    YUV height
 */
@property(nonatomic, assign)int picHeight;

/**
 *    Y data for YUV
 */
@property(nonatomic, assign)char *pucDataY;

/**
 *    U data for YUV
 */
@property(nonatomic, assign)char *pucDataU;

/**
 *    V data for YUV
 */
@property(nonatomic, assign)char *pucDataV;


/**
 *    Scaling of live
 */
@property(nonatomic, assign)float liveScale;

/**
 *    Live center
 */
@property(nonatomic, assign)CGPoint liveCenterPoint;

/**
 *    whether is in two-way audio state
 */
@property(nonatomic, assign)BOOL isMicro;

/**
 *    whether is in recording state
 */
@property(nonatomic, assign)BOOL isRecording;

/**
 *    whether audio is playing
 */
@property(nonatomic, assign)BOOL isPlayAudio;

/**
 *    mp4 tool
 */
//@property(nonatomic, strong)UVMp4 *mp4Util;

/**
 *    frame rate
 */
@property(nonatomic, assign)int frameRate;

- (void)startRecording;

- (void)stopRecording;

- (void)writeMP4DataBytes:(unsigned char*)dataBytes dataLength:(unsigned int)dataLength videoFormat:(int)videoFormat keyFrame:(bool)isKey stamptime:(long long)time;

//  Release YUV data
- (void)freeYUVBuff;
@end
