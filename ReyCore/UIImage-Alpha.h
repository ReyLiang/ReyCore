/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	UIImage-Alpha.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/7 
 
 Description: 
 
 不规则图片点的判断
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 2012/1/7 Rey 使其兼容ios普通屏幕和Retina屏幕
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@interface UIImage(Alpha)
- (NSData *)ARGBData;
- (BOOL)isPointTransparent:(CGPoint)point pointScale:(int) pointScale ;
@end
