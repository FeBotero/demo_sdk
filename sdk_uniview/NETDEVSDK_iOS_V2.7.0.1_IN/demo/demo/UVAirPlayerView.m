
#import "UVAirPlayerView.h"
@interface UVAirPlayerView()

@end


@implementation UVAirPlayerView
{
    UIPanGestureRecognizer *_pan;
    
    UIPinchGestureRecognizer *_pinch;
    
    CGPoint _startPoint;
    
    float recordScale;
    
    CGPoint recordCenterPoint;
}
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}
- (void)setPanGestureRecognizersWithIsRecord:(BOOL)isRecord
{
    if (isRecord)
    {
        [self addPanGestureRecognizer];
    }else
    {
        [self removePanGestureRecognizer];
    }
}

- (void)addPanGestureRecognizer
{
    [self removePanGestureRecognizer];
    //  Slow dragging gesture
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //  Pinch gesture
    _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchPress:)];
    
    [self addGestureRecognizer:_pinch];
    [self addGestureRecognizer:_pan];
    
}
- (void)removePanGestureRecognizer{
    [self removeGestureRecognizer:_pinch];
    [self removeGestureRecognizer:_pan];
    _pinch = nil;
    _pan = nil;
}

//  Zoom gestures
- (void)handlePinchPress:(UIPinchGestureRecognizer *)sender
{
    
    
    UIPinchGestureRecognizer *Gsr = (UIPinchGestureRecognizer*)sender;
    
    static BOOL isEnlargeZooming = NO;
    CGFloat scale = 0;
    if([Gsr state] == UIGestureRecognizerStateBegan)
    {
        isEnlargeZooming = YES;
    }
    
    if([Gsr state] == UIGestureRecognizerStateChanged && isEnlargeZooming)
    {
        scale = Gsr.scale;
        if(scale < 1)
        {
            recordScale = 1;
        }else if (scale > 1)
        {
            recordScale = 1.5;
        }
        
        recordCenterPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self scaleWithScaleRatio:recordScale x:0.5 y:0.5];
    }
    
    /*Set the lastscale to 1 when your finger leaves the screen*/
    if([Gsr state] == UIGestureRecognizerStateEnded)
    {
        isEnlargeZooming = NO;
    }
    
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    //  if digital zoom is enabled
    if ([sender state] == UIGestureRecognizerStateBegan)
    {
        _startPoint = [sender locationInView:self];
    }
    
    if ([sender state] == UIGestureRecognizerStateChanged && recordScale> 1)
    {
        CGPoint movePoint = [sender locationInView:self];
        float x = movePoint.x;
        float y = movePoint.y;
        float dx = x - _startPoint.x;
        float dy = y - _startPoint.y;
        CGPoint cp = CGPointMake(recordCenterPoint.x + dx,  recordCenterPoint.y + dy);
        
        float viewWidth = self.frame.size.width;
        float viewHeight = self.frame.size.height;
        float newWidth = viewWidth * recordScale;
        float newHeight = viewHeight * recordScale;
        
        if (cp.x < viewWidth / 2)
        {
            cp.x = viewWidth / 2;
        }
        if (cp.y < viewHeight / 2)
        {
            cp.y = viewHeight / 2;
        }
        if (cp.x > newWidth - viewWidth / 2)
        {
            cp.x = newWidth - viewWidth / 2;
        }
        if (cp.y > newHeight - viewHeight / 2)
        {
            cp.y = newHeight - viewHeight / 2;
        }
        
        recordCenterPoint = cp;
        [self scaleWithScaleRatio:recordScale x:(1-cp.x/newWidth) y:(cp.y/newHeight)];
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded)
    {
        
    }
    
}
@end
