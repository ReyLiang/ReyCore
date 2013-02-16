//
//  1.m
//  ReyCore
//
//  Created by Rey on 12-11-22.
//
//

#import "ReyARBG.h"

@implementation ReyARBG


//TODO:
+(ReyImagePoint)getPointFromData:(NSData *)imageData
                      pointIndex:(CGPoint)pointIndex
                       imageSize:(CGSize)imageSize
{
    int bitmapBytesPerRow = imageSize.width*4;
    
    NSUInteger index = pointIndex.x* 4 + (pointIndex.y * bitmapBytesPerRow);
    
    const unsigned char * bytes = (const unsigned char *)[imageData bytes];
    
    ReyImagePoint point = {0};
    point.alpha = bytes[index];
    point.red = bytes[index+1];
    point.green = bytes[index+2];
    point.blue = bytes[index+3];
    
//    NSLog(@"%d,%d,%d,%d",bytes[index],bytes[index+1],bytes[index+2],bytes[index+3]);
    
    return point;
}

+(ReyImagePoint)getPointFromData:(NSData *)imageData
                           index:(int)index
                       imageSize:(CGSize)imageSize
{
    int bitmapBytesPerRow = imageSize.width;
    
    int x = index%bitmapBytesPerRow;
    int y = index/bitmapBytesPerRow;
    
    return [ReyARBG getPointFromData:imageData pointIndex:CGPointMake(x,y) imageSize:imageSize];
}

+(void)printPoint:(ReyImagePoint)point
{
    NSLog(@"a=%d,r=%d,g=%d,b=%d",point.alpha,point.red,point.green,point.blue);
}
@end