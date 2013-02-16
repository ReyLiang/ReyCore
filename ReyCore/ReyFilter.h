/*************************************************
 
 Copyright (C), 2010-2020, Rey.
 
 File name:	ReyFilter.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/11/22
 
 Description:
 
 图片滤镜类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 *************************************************/

#import <Foundation/Foundation.h>

@interface ReyFilter : NSObject

//=============
//基础函数
+(NSData *)getDataFromImage:(UIImage *)image;
+(UIImage *)getImageFromData:(NSData *)data imageSize:(CGSize)imageSize;
//=============


//=============
//功能函数

//TODO: 反色
+(UIImage *)ReyFilter_Inverse:(UIImage *)image;

//TODO: 平滑
+(UIImage *)ReyFilter_Smooth:(UIImage *)image;

//TODO: 霓虹
+(UIImage *)ReyFilter_RainBow:(UIImage *)image;

//TODO: 霓虹
+(UIImage *)ReyFilter_Sharpen:(UIImage *)image sharpNum:(float)sharpNum;

//=============
@end
