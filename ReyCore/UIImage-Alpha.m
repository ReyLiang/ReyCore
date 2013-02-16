//
//  UIImage-RawData.m
//  test
//
//  Created by jeff on 3/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage-Alpha.h"
#import <CoreGraphics/CoreGraphics.h>

CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    

    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    //malloc不初始化,calloc初始化,解决透明图片不正常问题
    bitmapData = calloc(sizeof(char), bitmapByteCount);
    //    bitmapData = malloc( bitmapByteCount );
    

//    printf("bitmapData is %d\n",bitmapData);
    if (bitmapData == NULL) 
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
//        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );

    return context;
}

@implementation UIImage(Alpha)
- (NSData *)ARGBData
{
    CGContextRef cgctx = CreateARGBBitmapContext(self.CGImage);
    if (cgctx == NULL) 
        return nil;

    size_t w = CGImageGetWidth(self.CGImage);
    size_t h = CGImageGetHeight(self.CGImage);
    CGRect rect = {{0,0},{w,h}}; 
    CGContextDrawImage(cgctx, rect, self.CGImage); 
    
    void *data = CGBitmapContextGetData (cgctx);
    
//    printf("data is %d\n",data);
    CGContextRelease(cgctx); 
    if (!data)
        return nil;
    
    size_t dataSize = 4 * w * h; // ARGB = 4 8-bit components
    
    NSData * newData = [NSData dataWithBytes:data length:dataSize];
    free(data);
    return newData;
}    
- (BOOL)isPointTransparent:(CGPoint)point pointScale:(int) pointScale
{
    NSData *rawData = [self ARGBData];  // See about caching this
    if (rawData == nil)
        return NO;
    
    //＊2是为了实现iphone4中，每个点对应2个像素造成的像素和点不对应
    float scale = [[UIScreen mainScreen] scale];
    size_t bpp = 4;
    size_t bpr = self.size.width*scale * pointScale * 4;
    
    NSUInteger index = point.x *scale * pointScale * bpp + (point.y *scale* pointScale * bpr);
    NSUInteger toatl = self.size.height *scale * pointScale * bpr;
    char *rawDataBytes = (char *)[rawData bytes];


    //防止超出边界。
    if (index >=toatl ) {
        return YES;
    }
    ////NSLog(@"####%d",toatl);
    return rawDataBytes[index] == 0;

    
}
@end
