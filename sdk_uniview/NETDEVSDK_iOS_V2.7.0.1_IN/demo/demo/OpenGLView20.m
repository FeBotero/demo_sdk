
#import "OpenGLView20.h"


enum AttribEnum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTURE,
    ATTRIB_COLOR,
};

enum TextureType {
    TEXY = 0,
    TEXU,
    TEXV,
    TEXC
};

const GLfloat coordVertices_init[] = {
    0.0f, 0.0f,
    1.0f, 0.0f,
    0.0f,  1.0f,
    1.0f,  1.0f,
};

//#define PRINT_CALL 1

@interface OpenGLView20 ()
{
    GLfloat coordVertices[8];
}

/**
 Init YUV textures
 */
- (void)setupYUVTexture;

/**
 Create buffer
 @return  TRUE for success, FALSE for failure
 */
- (BOOL)createFrameAndRenderBuffer;

/**
 destroy buffer
 */
- (void)destoryFrameAndRenderBuffer;

// Load shader
/**
 Init YUV textures
 */
- (void)loadShader;

/**
 Compile shader code
 @param shader         code
 @param shaderType     type
 @return  The successful return of shader Failure Return - 1
 */
- (GLuint)compileShader:(NSString*)shaderCode withType:(GLenum)shaderType;

/**
 render
 */
- (void)render;
@end

@implementation OpenGLView20

- (BOOL)doInit
{
    CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;
    //eaglLayer.opaque = YES;
    
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat,
                                    //[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking,
                                    nil];
    self.contentScaleFactor = [UIScreen mainScreen].scale;
    _viewScale = [UIScreen mainScreen].scale;
    
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //[self debugGlError];
    
    if (!_glContext || ![EAGLContext setCurrentContext:_glContext]) {
        return NO;
    }
    
    [self setupYUVTexture];
    [self loadShader];
    glUseProgram(_program);
    
    GLuint textureUniformY = glGetUniformLocation(_program, "SamplerY");
    GLuint textureUniformU = glGetUniformLocation(_program, "SamplerU");
    GLuint textureUniformV = glGetUniformLocation(_program, "SamplerV");
    glUniform1i(textureUniformY, 0);
    glUniform1i(textureUniformU, 1);
    glUniform1i(textureUniformV, 2);
    
    memcpy(coordVertices, coordVertices_init, sizeof(coordVertices));
    
    return YES;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (![self doInit]) {
            self = nil;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (![self doInit]) {
            self = nil;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    #define SHADOW_VIEW_TAG    10025
    /*Special treatment: zoom quality optimization, rendering size, use the actual size, do not use transform zoom*/
    UIView *shadowView = [self.superview viewWithTag:SHADOW_VIEW_TAG];
    if (shadowView) {
        self.frame = shadowView.frame;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized(self)
        {
            [EAGLContext setCurrentContext:_glContext];
            [self destoryFrameAndRenderBuffer];
            [self createFrameAndRenderBuffer];
        }
        
    });
    
}

- (void)setupYUVTexture
{
    if (_textureYUV[TEXY]) {
        glDeleteTextures(3, _textureYUV);
    }
    glGenTextures(3, _textureYUV);
    if (!_textureYUV[TEXY] || !_textureYUV[TEXU] || !_textureYUV[TEXV]) {
        NSLog(@"<<<<<<<<<<<<Creat texture failed!>>>>>>>>>>>>");
        return;
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXY]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXU]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXV]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
}

- (void)render
{
    [EAGLContext setCurrentContext:_glContext];
    CGSize size = self.bounds.size;
    glViewport(1, 1, size.width * _viewScale - 2, size.height * _viewScale - 2);
    static const GLfloat squareVertices[] = {
        -1.0f, 1.0f,
        1.0f,  1.0f,
        -1.0f, -1.0f,
        1.0f,  -1.0f,
    };
    
    // Update attribute values
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    
    glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, 0, 0, coordVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTURE);
    
    // Draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - Set openGL
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (BOOL)createFrameAndRenderBuffer
{
    glGenFramebuffers(1, &_framebuffer);
    glGenRenderbuffers(1, &_renderBuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    if (![_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer]) {
        NSLog(@"Attach Rendering buffer failed");
    }
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Create a buffer error 0x%x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    return YES;
}

- (void)destoryFrameAndRenderBuffer
{
    if (_framebuffer) {
        glDeleteFramebuffers(1, &_framebuffer);
    }
    
    if (_renderBuffer) {
        glDeleteRenderbuffers(1, &_renderBuffer);
    }
    
    _framebuffer = 0;
    _renderBuffer = 0;
}

#define FSH @"varying lowp vec2 TexCoordOut;\
\
uniform sampler2D SamplerY;\
uniform sampler2D SamplerU;\
uniform sampler2D SamplerV;\
\
void main(void)\
{\
mediump vec3 yuv;\
lowp vec3 rgb;\
\
yuv.x = texture2D(SamplerY, TexCoordOut).r;\
yuv.y = texture2D(SamplerU, TexCoordOut).r - 0.5;\
yuv.z = texture2D(SamplerV, TexCoordOut).r - 0.5;\
\
rgb = mat3( 1,       1,         1,\
0,       -0.39465,  2.03211,\
1.13983, -0.58060,  0) * yuv;\
\
gl_FragColor = vec4(rgb, 1);\
\
}"

#define VSH @"attribute vec4 position;\
attribute vec2 TexCoordIn;\
varying vec2 TexCoordOut;\
\
void main(void)\
{\
gl_Position = position;\
TexCoordOut = TexCoordIn;\
}"

/**
 Load shader
 */
- (void)loadShader
{
    /**
     1
     */
    GLuint vertexShader = [self compileShader:VSH withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:FSH withType:GL_FRAGMENT_SHADER];
    
    /**
     2
     */
    _program = glCreateProgram();
    glAttachShader(_program, vertexShader);
    glAttachShader(_program, fragmentShader);
    
    /**
     Binding needs to be before link
     */
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_TEXTURE, "TexCoordIn");
    
    glLinkProgram(_program);
    
    /**
     3
     */
    GLint linkSuccess;
    glGetProgramiv(_program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_program, sizeof(messages), 0, &messages[0]);
        NSString* messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"<<<<The shader connection failed %@>>>", messageString);
        //exit(1);
    }
    
    if (vertexShader)
        glDeleteShader(vertexShader);
    if (fragmentShader)
        glDeleteShader(fragmentShader);
}

- (GLuint)compileShader:(NSString*)shaderString withType:(GLenum)shaderType
{
    if (!shaderString) {
        NSLog(@"Error loading shader");
        exit(1);
    }
    else {
        NSLog(@"shader code-->%@", shaderString);
    }
    
    /**
     2
     */
    GLuint shaderHandle = glCreateShader(shaderType);
    
    /**
     3
     */
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    /**
     4
     */
    glCompileShader(shaderHandle);
    
    /**
     5
     */
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString* messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

#pragma mark - Interface

- (void)displayYUV420pDataY:(void*)dataY dataU:(void*)dataU dataV:(void *)dataV width:(NSInteger)w height:(NSInteger)h
{
    //_pYuvData = data;
    if (_offScreen || !self.window) {
        return;
    }
    @synchronized(self)
    {
        if (w != _videoW || h != _videoH) {
            [self setVideoSize:w height:h];
        }
        [EAGLContext setCurrentContext:_glContext];
        
        glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXY]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_RED_EXT, GL_UNSIGNED_BYTE, dataY);
        
        //[self debugGlError];
        
        glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXU]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w / 2, h / 2, GL_RED_EXT, GL_UNSIGNED_BYTE, dataU);
        
        // [self debugGlError];
        
        glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXV]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w / 2, h / 2, GL_RED_EXT, GL_UNSIGNED_BYTE, dataV);
        
        //[self debugGlError];
        
        [self render];
        
        free(dataY);
        free(dataU);
        free(dataV);
        dataY = NULL;
        dataU = NULL;
        dataV = NULL;
    }
}

GLuint BindTexture(GLuint texture, const char *pucBuffer, GLuint w , GLuint h)
{
    glBindTexture ( GL_TEXTURE_2D, texture );
    //CheckGLError("glBindTexture");
    
    glTexImage2D ( GL_TEXTURE_2D, 0, GL_LUMINANCE, w, h, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, pucBuffer);
    //CheckGLError("glTexImage2D");
    
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    // CheckGLError("glTexParameteri");
    
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    //CheckGLError("glTexParameteri");
    
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    // CheckGLError("glTexParameteri");
    
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    // CheckGLError("glTexParameteri");
    
    return texture;
}


- (void)displayYUV420pData:(void*)data width:(NSInteger)w height:(NSInteger)h
{
    //_pYuvData = data;
    if (_offScreen || !self.window) {
        return;
    }
    @synchronized(self)
    {
        if (w != _videoW || h != _videoH) {
            [self setVideoSize:w height:h];
        }
        [EAGLContext setCurrentContext:_glContext];
#if 0
        glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXY]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, GL_RED_EXT, GL_UNSIGNED_BYTE, data);
        
        //[self debugGlError];
        
        glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXU]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w / 2, h / 2, GL_RED_EXT, GL_UNSIGNED_BYTE, data + w * h);
        
        // [self debugGlError];
        
        glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXV]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w / 2, h / 2, GL_RED_EXT, GL_UNSIGNED_BYTE, data + w * h * 5 / 4);
        
        //[self debugGlError];
#else
        BindTexture(_textureYUV[TEXY],data,w,h);
        BindTexture(_textureYUV[TEXU],data + w * h,w/2,h/2);
        BindTexture(_textureYUV[TEXV],data + w * h * 5/4,w/2,h/2);
        [self render];
#endif
       // data = NULL;
    }
    
}


- (void)setVideoSize:(GLuint)width height:(GLuint)height
{
    _videoW = width;
    _videoH = height;
    
#if 0
    void* blackData = malloc(width * height * 1.5);
    if (blackData) {
        //bzero(blackData, width * height * 1.5);
        memset(blackData, 0x0, width * height * 1.5);
    }
    
    [EAGLContext setCurrentContext:_glContext];
    glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXY]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width, height, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData);
    glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXU]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width / 2, height / 2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height);
    
    glBindTexture(GL_TEXTURE_2D, _textureYUV[TEXV]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width / 2, height / 2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height * 5 / 4);
    
    free(blackData);
    blackData = NULL;
#endif
}

- (void)clearFrame
{
    if ([self window]) {
        [EAGLContext setCurrentContext:_glContext];
        glClearColor(0.859, 0.859, 0.859, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
        [_glContext presentRenderbuffer:GL_RENDERBUFFER];
    }
    
}

/**
 4 coordinates are placed in coord (each coordinate is 2 values), so the coord length is 8
 
  Mapping relation :
 
 Top left corner of video(x1,y1)      Top right corner of video(x2,y2)
 
 
 Bottom left corner of video(x3,y3)   Bottom right corner of video(x4,y4)
 
When 1:1 is displayed, the X，Y relationship is
 
 0,1                     1,1
 
 0,0                     1,0
 
 
 As long as you set this value, you can zoom in and out any content in the video
 
 
Pass the values in this sequence: upper left corner, upper right corner, lower left corner, and lower right corner
 

 x, y is between 0.0-1.0f
 
 **/
- (void)setPositionWithCoord:(GLfloat *)coord {
    int length = 8; //(int)sizeof(coordVertices)/GLfloat;
    if(coord != NULL) {
        for(int i = 0; i < length; i++) {
            GLfloat value = *(coord);
            if(i % 2 == 1) {
                //  Because of the corresponding relationship between texture and video, it needs to be processed
                value = 1 - value;
            }
            coordVertices[i] = value;
            coord++;
        }
    }
    //    Update zoom area
    glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, 0, 0, coordVertices);
    
    glEnableVertexAttribArray(ATTRIB_TEXTURE);
}


/**
 Set magnification scale; x and y sets the center point of area to magnify on screen
 **/
- (void)scaleWithScaleRatio:(GLfloat)scaleRatio x:(GLfloat)x y:(GLfloat)y //Set magnification scale,
{
    //ELYTDLog(@"scaleRation:%f ,x=%f,y=%f", scaleRatio, x, y);
    GLfloat coord[8];
    if(scaleRatio <= 1.0f) {
        NSLog(@"scaleRatio==1.0f");
        memcpy(coordVertices, coordVertices_init, sizeof(coord));
        //   Update zoom area
        glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, 0, 0, coordVertices);
        
        glEnableVertexAttribArray(ATTRIB_TEXTURE);
        return; //  Note that since you have given the initial value at this point, you do not need to call SetPosition again and the function will return directly
        
    } else {
        //  Calculate proportion relation
        float deltaX = (1.0f / scaleRatio) / 2;
        float deltaY = (1.0f / scaleRatio) / 2;
        
        
        // Calculate four point coordinates, the given point is the center point
        /**
         
         
         **/
        
        float leftX, leftY;
        leftX = x - deltaX; // Top left corner X
        leftY = y + deltaY; //  Top left corner Y
        
        if(leftX < 0.0f) {
            // X, Y is too far left, move to the right
            leftX = 0.0f;
        }
        else if((x + deltaX  )> 1.0f) {
            //  X, Y is too far right, move to the left
            leftX = 1.0f - 2*deltaX;
        }
        
        if(leftY > 1.0f) {
            // Y is too upper
            leftY = 1.0f;
        }
        else if((y - deltaY ) < 0.0f) {
            //Y is too down
            leftY = 0.0f + 2*deltaY;
        }
        
        coord[0] = leftX; //  Top left corner
        coord[1] = leftY;
        
        coord[2] = leftX + 2*deltaX; //  Top right corner
        coord[3] = leftY;
        
        coord[4] = leftX; //  Bottom left corner
        coord[5] = leftY - 2*deltaY;
        
        coord[6] = leftX + 2*deltaX; //  Bottom right corner
        coord[7] = leftY - 2*deltaY;
        
        for(int i=0;i<8;i++)
        {
            if(coord[i]<0.0f)
            {
                coord[i]=0.0f;
            }
            else if(coord[i]>1.0f)
            {
                coord[i]=1.0f;
            }
        }
            }
    
    [self setPositionWithCoord:coord];
}

@end
