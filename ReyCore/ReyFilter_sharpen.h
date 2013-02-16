/*************************************************
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com
 
 File name:	ReyFilter_sharpen.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/11/22
 
 Description:
 
 进行锐化处理
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 *************************************************/

#import <Foundation/Foundation.h>

//锐化
@interface ReyFilter_sharpen : NSObject
{
    NSData * m_imageData;
    
    CGSize m_imageSize;
    
    float m_sharpNum;
}

@property (nonatomic , retain) NSData * m_imageData;

-(id)initWithImage:(NSData *)imageData imageSize:(CGSize)imageSize sharpNum:(float)sharpNum;
-(NSData *)getNewImageData;
@end
