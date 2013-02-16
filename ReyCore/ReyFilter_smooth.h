/*************************************************
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com
 
 File name:	ReyFilter_smooth.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/11/22
 
 Description:
 
 进行平滑处理
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 *************************************************/

#import <Foundation/Foundation.h>


//平滑
@interface ReyFilter_smooth : NSObject
{
    NSData * m_imageData;
    
    CGSize m_imageSize;
}

@property (nonatomic , retain) NSData * m_imageData;

-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize;
-(NSData *)getNewImageData;
@end
