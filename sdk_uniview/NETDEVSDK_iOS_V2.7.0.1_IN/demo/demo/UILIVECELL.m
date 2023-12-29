
#import "UILIVECELL.h"
@implementation UILIVECELL
- (char *)pucDataY
{
    
    if (_pucDataY == nil)
    {
        _pucDataY = malloc(MAX_Y_SIZE * sizeof(char));
    }
    
    return _pucDataY;
}

- (char *)pucDataU
{
    
    if (_pucDataU == nil)
    {
        _pucDataU = malloc(MAX_UV_SIZE * sizeof(char));
    }
    
    return _pucDataU;
}

- (char *)pucDataV
{
    
    if (_pucDataV == nil)
    {
        _pucDataV = malloc(MAX_UV_SIZE * sizeof(char));
    }
    
    return  _pucDataV;
}

- (void)freeYUVBuff
{
    if (_pucDataY != NULL)
    {
        free(_pucDataY);
        _pucDataY=NULL;
    }
    if (_pucDataU != NULL)
    {
        free(_pucDataU);
        _pucDataU=NULL;
    }
    if (_pucDataV != NULL)
    {
        free(_pucDataV);
        _pucDataV=NULL;
    }
}
-(id)init
{
    if (self = [super init])
    {
        _liveCellId = (unsigned int)self;
        _liveIndex = -1;
        
        _lock = [[NSLock alloc]init];
        
        _frameRate = 25;
    }
    return self;
}

@end
