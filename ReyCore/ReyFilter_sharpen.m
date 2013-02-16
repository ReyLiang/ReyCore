//
//  ReyFilter_ sharpen.m
//  ReyCore
//
//  Created by Rey on 12-11-23.
//
//

#import "ReyFilter_sharpen.h"
#import "ReyARBG.h"


@implementation ReyFilter_sharpen

@synthesize m_imageData;




-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize sharpNum:(float)sharpNum
{
    self = [super init];
    if (self) {
        m_imageData = [imageData retain];
        m_imageSize = imageSize;
        m_sharpNum = sharpNum;
    }
    return self;
}

-(void)dealloc
{
    [m_imageData release];
    [super dealloc];
}

-(ReyImagePoint)getSmoothPoint:(int)index
{
    int bitmapBytesPerRow = m_imageSize.width;
//    int bitmapRow = m_imageSize.height;
    
    int x = index%bitmapBytesPerRow;
    int y = index/bitmapBytesPerRow;
    int matrixHalf = 1;
    
    
    //点在图片边上
    //行
    if ( x < matrixHalf ||
        y < matrixHalf) {
        return [ReyARBG getPointFromData:m_imageData index:index imageSize:m_imageSize];
    }
    
    
    ReyImagePoint point = [ReyARBG getPointFromData:m_imageData
                                         pointIndex:CGPointMake(x, y)
                                          imageSize:m_imageSize];
    
    ReyImagePoint point1 = [ReyARBG getPointFromData:m_imageData
                                          pointIndex:CGPointMake(x-1, y-1)
                                           imageSize:m_imageSize];
    

    
    
    
    int r = fabs(point.red - point1.red) * m_sharpNum + point.red;
    int g = fabs(point.green - point1.green) * m_sharpNum + point.green;
    int b = fabs(point.blue - point1.blue) * m_sharpNum + point.blue;
    Byte a = point.alpha;
    
//    NSLog(@"%d,%d,%d",r,g,b);
    
    
    
    
    ReyImagePoint newPoint;
    newPoint.alpha = a;
    newPoint.red = r;
    newPoint.green = g;
    newPoint.blue = b;
    
    return newPoint;
}

-(NSData *)getNewImageData
{
    
    NSMutableData * newData = [[NSMutableData alloc] init];
    
    for (int i = 0 ; i<m_imageSize.width * m_imageSize.height; i++) {
        
        
        ReyImagePoint point = [self getSmoothPoint:i];
        
        [newData appendBytes:&point.alpha length:sizeof(char)];
        [newData appendBytes:&point.red length:sizeof(char)];
        [newData appendBytes:&point.green length:sizeof(char)];
        [newData appendBytes:&point.blue length:sizeof(char)];
        
    }
    
    
    return [newData autorelease];
}


@end
