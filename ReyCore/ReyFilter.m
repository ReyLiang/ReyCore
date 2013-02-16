/*************************************************
 
 Copyright (C), 2010-2020, Rey.
 
 File name:	ReyFilter.m
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/11/22
 
 Description:
 
 图片滤镜类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 *************************************************/

#import "ReyFilter.h"
#import "ReyARBG.h"
#import "ReyFilter_smooth.h"
#import "ReyFilter_rainbow.h"
#import "ReyFilter_sharpen.h"

@implementation ReyFilter

+(NSData *)getDataFromImage:(UIImage *)image
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(image.CGImage);
    size_t pixelsHigh = CGImageGetHeight(image.CGImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    //malloc不初始化,calloc初始化,解决透明图片不正常问题
    bitmapData = calloc(sizeof(char), bitmapByteCount);
//    bitmapData = malloc(bitmapByteCount);
    
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
    
    CGRect rect = CGRectMake(0, 0,pixelsWide,pixelsHigh);
    CGContextDrawImage(context, rect, image.CGImage);
    
    void *data = CGBitmapContextGetData (context);
    
    
    
    CGContextRelease(context);
    if (!data)
        return nil;
    
    size_t dataSize = 4 * pixelsWide * pixelsHigh; // ARGB = 4 8-bit components
    
    NSData * newData = [NSData dataWithBytes:data length:dataSize];
    free(data);
    
    
    
    return newData;
}

+(UIImage *)getImageFromData:(NSData *)data imageSize:(CGSize)imageSize
{
    
    void * bitmapData = (void *)[data bytes];
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    
    size_t pixelsWide = imageSize.width;
    size_t pixelsHigh = imageSize.height;
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
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
    }
    CGColorSpaceRelease( colorSpace );
    
    CGImageRef newnew = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage * newImg = [UIImage imageWithCGImage:newnew];
    
    CGImageRelease(newnew);
    
    return newImg;
}


//+(NSData *)getDataFromImage:(UIImage *)image
//{
//    NSData * imgData = UIImagePNGRepresentation(image);
//    
//    if (!imgData) {
//        imgData = UIImageJPEGRepresentation(image, 1);
//    }
//    
//    return imgData;
//}
//
//+(UIImage *)getImageFromData:(NSData *)data imageSize:(CGSize)imageSize
//{
//    
//    UIImage * newImg = [UIImage imageWithData:data];
//    
//    return newImg;
//}


//TODO: 反色
+(UIImage *)ReyFilter_Inverse:(UIImage *)image
{
    NSData * imgData = [self getDataFromImage:image];
    const unsigned char *rawDataBytes = (const unsigned char *)[imgData bytes];
    
    NSMutableData * newData = [[NSMutableData alloc] init];
    
    for (int i = 0 ; i<[imgData length]; i=i+4) {
        
        Byte a = rawDataBytes[i];
        Byte r = rawDataBytes[i+1];
        Byte g = rawDataBytes[i+2];
        Byte b = rawDataBytes[i+3];
        
        Byte rr = 255^r;
        Byte gg = 255^g;
        Byte bb = 255^b;
        
        [newData appendBytes:&a length:sizeof(char)];
        [newData appendBytes:&rr length:sizeof(char)];
        [newData appendBytes:&gg length:sizeof(char)];
        [newData appendBytes:&bb length:sizeof(char)];
        
    }
    
    //CGImage的宽度是实际像素
    UIImage * newImg = [self getImageFromData:newData imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                           CGImageGetHeight(image.CGImage))];
    [newData release];
    
    return newImg;
}

//TODO: 平滑
+(UIImage *)ReyFilter_Smooth:(UIImage *)image
{
    NSData * imgData = [self getDataFromImage:image];
    
    ReyFilter_smooth * smooth = [[ReyFilter_smooth alloc] initWithImage:imgData
                                                              imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                                   CGImageGetHeight(image.CGImage))];
    NSData * newData = [smooth getNewImageData];
    
    //CGImage的宽度是实际像素
    UIImage * newImg = [self getImageFromData:newData imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                           CGImageGetHeight(image.CGImage))];
    [smooth release];
    
    return newImg;
    
}


//TODO: 霓虹
+(UIImage *)ReyFilter_RainBow:(UIImage *)image
{
    NSData * imgData = [self getDataFromImage:image];
    
    ReyFilter_rainbow * rainbow = [[ReyFilter_rainbow alloc] initWithImage:imgData
                                                                 imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                                      CGImageGetHeight(image.CGImage))];
    NSData * newData = [rainbow getNewImageData];
    
    //CGImage的宽度是实际像素
    UIImage * newImg = [self getImageFromData:newData imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                           CGImageGetHeight(image.CGImage))];
    [rainbow release];
    
    return newImg;
    
}

//TODO: 霓虹
+(UIImage *)ReyFilter_Sharpen:(UIImage *)image sharpNum:(float)sharpNum
{
    NSData * imgData = [self getDataFromImage:image];
    
    ReyFilter_sharpen * sharpen = [[ReyFilter_sharpen alloc] initWithImage:imgData
                                                                 imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                                      CGImageGetHeight(image.CGImage))
                                                                  sharpNum:0.25];
    NSData * newData = [sharpen getNewImageData];
    
    //CGImage的宽度是实际像素
    UIImage * newImg = [self getImageFromData:newData imageSize:CGSizeMake(CGImageGetWidth(image.CGImage),
                                                                           CGImageGetHeight(image.CGImage))];
    [sharpen release];
    
    return newImg;
    
}


@end
