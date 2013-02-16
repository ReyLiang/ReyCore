//
//  ReyPopupView_circleItem.m
//  PopupTest
//
//  Created by rey liang on 12-1-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyPopupView_circleItem.h"
#import <QuartzCore/QuartzCore.h>


@implementation ReyPopupView_circleItem

@synthesize delegate;

//动画周期
#define CIRCLE_ANIMATION_DURATION  0.2f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    CGPathRelease(showPath);
    CGPathRelease(hidePath);
    [super dealloc];
}

//TODO: 添加动画
//TODO: view: 需要添加动画的view
//TODO: pathCenter: 图片运动轨迹的圆心
//TODO: starangle: 开始角度
//TODO: endangle: 结束角度
//TODO: randius: 轨迹圆半径
//TODO: isClockWise: 是否为逆时针
-(void)addMoveAnimationWithPathCenter:(CGPoint)pathCenter 
              startangle:(float)starangle 
               endangle:(float)endangle 
                randius:(float)randius
            isClockWise:(bool)isClockWise
{
    
    
    m_startangle = starangle;
    m_endangle = endangle;
    //轨迹的圆心
    //相对self.frame.origin的点
    float pathCenterX = pathCenter.x;
    //-y,由于iphone左上角为(0,0)
    float pathCenterY = pathCenter.y;
    
    showPath = CGPathCreateMutable();
    
    CGPathAddArc(showPath, NULL, pathCenterX, pathCenterY, randius, starangle, endangle, isClockWise);
    
    hidePath = CGPathCreateMutable();
    
    CGPathAddArc(hidePath, NULL, pathCenterX, pathCenterY, randius, endangle, starangle,  !isClockWise);
   
    
    
    
}


//开始显示动画
-(void)startShowAnimation
{
    CAKeyframeAnimation * keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrame.path = showPath;
    keyFrame.calculationMode =  kCAAnimationPaced;
    //    keyFrame.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1.0], nil];
    keyFrame.duration = CIRCLE_ANIMATION_DURATION;
    keyFrame.fillMode = kCAFillModeForwards;
    keyFrame.removedOnCompletion = NO;
    keyFrame.delegate = self;
    keyFrame.repeatCount	= 1;//FLT_MAX;
    
    [self.layer addAnimation:keyFrame forKey:@"CircleAnimation"];
    
    self.userInteractionEnabled = NO;
    
    isShowAnimation = YES;
}

//开始隐藏动画
-(void)startHideAnimation
{
    CAKeyframeAnimation * keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrame.path = hidePath;
    keyFrame.calculationMode =  kCAAnimationPaced;
    //    keyFrame.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:1.0], nil];
    keyFrame.duration = CIRCLE_ANIMATION_DURATION;
    keyFrame.fillMode = kCAFillModeForwards;
    keyFrame.removedOnCompletion = NO;
    keyFrame.delegate = self;
    keyFrame.repeatCount	= 1;//FLT_MAX;
    
    [self.layer addAnimation:keyFrame forKey:@"CircleAnimation"];
    
    self.userInteractionEnabled = NO;
    
    isShowAnimation = NO;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (isShowAnimation) {
            //设置view动画结束后,要停留的点
            self.center = CGPathGetCurrentPoint(showPath);
            isShowAnimation = NO;
            
            if (delegate && [delegate respondsToSelector:@selector(circleItemShowAnimationFinished:)]) {
                [delegate circleItemShowAnimationFinished:self];
            }
            
        }
        else
          {
            self.center = CGPathGetCurrentPoint(hidePath);
            if (delegate && [delegate respondsToSelector:@selector(circleItemHideAnimationFinished:)]) {
                [delegate circleItemHideAnimationFinished:self];
            }
          }
        [self.layer removeAllAnimations];
        self.userInteractionEnabled = YES;
    }


}


@end
