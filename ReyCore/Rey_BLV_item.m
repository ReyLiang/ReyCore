//
//  Rey_BLV_item.m
//  ReyBreakLoad
//
//  Created by Rey on 12-11-18.
//  Copyright (c) 2012年 Rey. All rights reserved.
//

#import "Rey_BLV_item.h"
#import "ReyAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation Rey_BLV_item

@synthesize m_delegate;

#define DURATION_PER 0.1


- (id)initWithFrame:(CGRect)frame superSize:(CGSize)superSize showImg:(UIImage *)showImg
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_superSize = superSize;
        [self setImage:showImg];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame superSize:(CGSize)superSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_superSize = superSize;
    }
    return self;
}

-(void)dealloc
{
    [m_imgView release];
    [super dealloc];
}

-(void)setImage:(UIImage *)image
{
    
    if (!m_imgView) {
        m_imgView = [[UIImageView alloc] initWithImage:image];
        m_imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:m_imgView];
    }
    else
    {
        m_imgView.image = image;
    }

}

-(void)startAnimation
{
    float y = m_superSize.height+ self.frame.size.height/2;
    CGPoint endPoint = CGPointMake(self.center.x, y);
    
//    NSLog(@"%d,%@",self.tag,NSStringFromCGPoint(endPoint));
    
    float duration = (y - self.center.y)/100*DURATION_PER;
    
    [ReyAnimation SetPointMoveBasicAnimation:self delegate:self key:nil duration:duration startPoint:self.center endPoint:endPoint];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        
        if (m_delegate) {
            [m_delegate Rey_BLV_itemAnimationFinished:self];
        }
        
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    }
}

@end
