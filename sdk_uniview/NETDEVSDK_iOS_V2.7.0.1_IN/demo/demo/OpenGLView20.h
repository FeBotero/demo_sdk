//
//  OpenGLView20.h
// dome
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>

@interface OpenGLView20 : UIView {
    /**
     OpenGL drawing context
     */
    EAGLContext* _glContext;
    
    /**
     Frame buffer
     */
    GLuint _framebuffer;
    
    /**
     Render buffer
     */
    GLuint _renderBuffer;
    
    /**
     Shader handle
     */
    GLuint _program;
    
    /**
     YUV texture array
     */
    GLuint _textureYUV[3];
    
    /**
     Video width
     */
    GLuint _videoW;
    
    /**
     Video height
     */
    GLuint _videoH;
    
    GLsizei _viewScale;
    
    BOOL _offScreen;
    
#ifdef DEBUG
    struct timeval _time;
    NSInteger _frameRate;
#endif
}
#pragma mark -  Interface
- (void)displayYUV420pData:(void*)data width:(NSInteger)w height:(NSInteger)h;
- (void)setVideoSize:(GLuint)width height:(GLuint)height;

/**
 Clear picture
 */
- (void)clearFrame;

- (void)render;

/**
 Set magnification scale; x and y sets the center point of area to magnify on screen
 */
- (void)scaleWithScaleRatio:(GLfloat)scaleRatio x:(GLfloat)x y:(GLfloat)y;

@end
