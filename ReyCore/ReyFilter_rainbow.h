/*************************************************
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com
 
 File name:	ReyFilter_rainbow.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/11/22
 
 Description:
 
 霓虹效果
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 *************************************************/
#import <Foundation/Foundation.h>

//霓虹
@interface ReyFilter_rainbow : NSObject
{
    NSData * m_imageData;
    
    CGSize m_imageSize;
}

@property (nonatomic , retain) NSData * m_imageData;

-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize;
-(NSData *)getNewImageData;
@end
