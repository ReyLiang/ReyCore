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


#import "ReyLabel_shadowExtra.h"

@interface ReyLabel_shadowExtra()
-(void)initDataWith:(UIColor *)color shadowOffsize:(CGSize)offsize blur:(float)blur;
@end

@implementation ReyLabel_shadowExtra

@synthesize RL_shadowColor;

- (id)initWithFrame:(CGRect)frame shadowColor:(UIColor *)color shadowOffsize:(CGSize)offsize blur:(float)blur
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self initDataWith:color shadowOffsize:offsize blur:blur];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame shadowColor:(UIColor *)color
{
    return [self initWithFrame:frame shadowColor:color shadowOffsize:CGSizeZero blur:0];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame shadowColor:nil shadowOffsize:CGSizeZero blur:0];
}

-(void)initDataWith:(UIColor *)color shadowOffsize:(CGSize)offsize blur:(float)blur
{
    if (color) {
        RL_shadowColor = [color retain];
    }
    else    //默认透明度75%的白色
    {
        RL_shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.75];
    }
    
    if (CGSizeEqualToSize(offsize, CGSizeZero)) {
        RL_offsize = CGSizeMake(0, 1);
    }
    else
    {
        RL_offsize = offsize;
    }
    
    if (blur == 0) {
        RL_blur = 1;
    }
    else
    {
        RL_blur = blur;
    }
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpaceRef, CGColorGetComponents(RL_shadowColor.CGColor));
    CGContextSetShadowWithColor(context, RL_offsize,  RL_blur, colorRef);
    [self drawTextInRect:rect];
    //[super drawRect:rect];
    CGColorRelease(colorRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRestoreGState(context);
}


-(void)dealloc
{
    
    [RL_shadowColor release];
    [super dealloc];
}
@end
