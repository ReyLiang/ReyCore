/*************************************************
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com
 
 File name:	ReyARBG.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/11/22
 
 Description:
 
 获取图片的arbg值
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 *************************************************/

#import <Foundation/Foundation.h>

typedef struct {
    unsigned char alpha;
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    
    
}ReyImagePoint;

@interface ReyARBG : NSObject

//TODO: 取值按照argb取
+(ReyImagePoint)getPointFromData:(NSData *)imageData
                      pointIndex:(CGPoint)pointIndex
                       imageSize:(CGSize)imageSize;

//TODO: 取值按照argb取
+(ReyImagePoint)getPointFromData:(NSData *)imageData
                           index:(int)index
                       imageSize:(CGSize)imageSize;

//测试用
+(void)printPoint:(ReyImagePoint)point;
@end


