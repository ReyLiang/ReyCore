/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyLabel_shadowExtra.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/11/24 
 
 Description: 
 
 UILablel.底层画阴影.可设定阴影颜色
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <Foundation/Foundation.h>
#import "ReyLabel_shadow.h"

@interface ReyLabel_shadowExtra : ReyLabel_shadow
{
    UIColor * RL_shadowColor;
    CGSize RL_offsize;
    float RL_blur;
}

@property (nonatomic , retain) UIColor * RL_shadowColor;

- (id)initWithFrame:(CGRect)frame shadowColor:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame shadowColor:(UIColor *)color shadowOffsize:(CGSize)offsize blur:(float)blur;
@end
