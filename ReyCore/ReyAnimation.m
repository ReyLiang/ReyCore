//
//  ReyAnimation.m
//  PopupTest
//
//  Created by rey liang on 12-1-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyAnimation.h"


@implementation ReyAnimation

+(CAAnimation *)GetOpacityAnimation:(float)fromValue toValue:(float)toValue
{
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.fromValue = [NSNumber numberWithFloat:fromValue];
    anim.toValue = [NSNumber numberWithFloat:toValue];
    anim.fillMode = kCAFillModeForwards;
    return anim;
}


+(CAAnimation *)GetPointMoveBasicAnimation:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    basicAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    basicAnimation.fillMode = kCAFillModeForwards;
    
    return basicAnimation;
}

//旋转
+(CAAnimation *)GetRotationBasicAnimation:(float)fromAngle toAngle:(float)toAngle
{
    CABasicAnimation * Animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    Animation.fromValue = [NSNumber numberWithFloat:fromAngle];
    Animation.toValue = [NSNumber numberWithFloat:toAngle];

    Animation.fillMode = kCAFillModeForwards;
    
    return Animation;
}

//旋转角度
+(CAAnimation *)GetRockerKeyAnimation:(float)angle direction:(ReyAnimationRockDirection)direction
{
    CAKeyframeAnimation * Animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    sranddev();
    
    switch (direction) {
        case ReyAnimationRockDirectionRandom://随机
      {
        int tag = random()%2;
        if (tag) {
            Animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:-angle],
                                [NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:angle],
                                [NSNumber numberWithFloat:-0], nil];
        }
        else
          {
            Animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:angle],
                                [NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:-angle],
                                [NSNumber numberWithFloat:-0], nil];
          }
        break;
      }
        case ReyAnimationRockDirectionLeft://先左转
      {
        Animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                            [NSNumber numberWithFloat:-angle],
                            [NSNumber numberWithFloat:0],
                            [NSNumber numberWithFloat:angle],
                            [NSNumber numberWithFloat:-0], nil];
        break;
      }
        case ReyAnimationRockDirectionRight://先右转
      {
        Animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                            [NSNumber numberWithFloat:angle],
                            [NSNumber numberWithFloat:0],
                            [NSNumber numberWithFloat:-angle],
                            [NSNumber numberWithFloat:-0], nil];
        break;
      }

    }
    

    
    Animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:0.25],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:0.75],
                          [NSNumber numberWithFloat:1], nil];;
    Animation.fillMode = kCAFillModeForwards;
    
    return Animation;
}

+(CAAnimation *)GetTransform3DBasicAnimation:(CATransform3D)startTransform3D 
                                         end:(CATransform3D)endTransform3D
{
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnimation.fromValue = [NSValue valueWithCATransform3D:startTransform3D];
    basicAnimation.toValue = [NSValue valueWithCATransform3D:endTransform3D];
    basicAnimation.fillMode = kCAFillModeForwards;
    
    return basicAnimation;
}

+(CAAnimation *)GetAffineTransformBasicAnimation:(CGAffineTransform)startAffineTransform 
                                             end:(CGAffineTransform)endAffineTransform
{
    
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnimation.fromValue = [NSValue valueWithCGAffineTransform:startAffineTransform];
    basicAnimation.toValue = [NSValue valueWithCGAffineTransform:endAffineTransform];
    basicAnimation.fillMode = kCAFillModeForwards;
    
    return basicAnimation;
}


//shakeCount: 摇摆次数
+(CAAnimation *)GetPointMoveKeyAnimationWithShake:(int)shakeCount shakeDirection:(bool)isVertical startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    //标记摇摆方向
    int tagX = 1;
    int tagY = 0;
    
    //标记摇摆方向
    int tag = 1;
    
    if (isVertical) {
        tagX = 0;
        tagY = 1;
    }
    
    
    
    //用于摇摆的时间百分比.
    float shakeTime = 0.1;
    
    //用于移动的时间百分比
    float time = 1 - shakeCount * shakeTime;
    
    NSMutableArray * keyTimes = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0],
                                 [NSNumber numberWithFloat:time], nil];
    
    for (int i = 0; i < shakeCount; i ++) {
        [keyTimes addObject:[NSNumber numberWithFloat:time + shakeTime * i]];
    }
    
    
    
    NSMutableArray * values = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:startPoint],nil];
    
    
    for (int i = 0; i < shakeCount; i ++) {
        
        float move = tag * 10;//tag * ran %20;
        //NSLog(@"move %f point %f",move,endPoint.x + tagX * move);
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(endPoint.x + tagX * move , endPoint.y + tagY * move)]];
        tag = - tag;
    }
    
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(endPoint.x, endPoint.y)]];
    
    //NSLog(@"COUNT %d,%d",[keyTimes count],[values count]);
    
    CAKeyframeAnimation * Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    Animation.keyTimes = keyTimes;
    Animation.values = values;
    Animation.fillMode = kCAFillModeForwards;
    
    return Animation;
}


//TODO: 放大缩小的animation
//shakeCount颤抖次数
//scalesize是缩放后的长度比缩放前的
//isFromView YES,从view缩放,NO,缩放到view大小
+(CAAnimation *)GetKeyAnimationWithScale:(CGSize)scaleSize
                             transform3D:(CATransform3D)transform
                              isFromView:(BOOL)isFromView
{
    
    NSMutableArray * keyTimes = [[NSMutableArray alloc] init];
    
    NSMutableArray * values = [[NSMutableArray alloc] init];
    
    
    [keyTimes addObject:[NSNumber numberWithInt:0]];
    [keyTimes addObject:[NSNumber numberWithInt:1]];
    
    CATransform3D maxTransform = CATransform3DScale(transform,scaleSize.width, scaleSize.height,1);
    
    if (isFromView) {
        [values addObject:[NSValue valueWithCATransform3D:transform]];
        [values addObject:[NSValue valueWithCATransform3D:maxTransform]];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:maxTransform]];
        [values addObject:[NSValue valueWithCATransform3D:transform]];
        
    }
    
    
    
    CAKeyframeAnimation * Animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    Animation.keyTimes = keyTimes;
    Animation.values = values;
    Animation.fillMode = kCAFillModeForwards;
    
    [keyTimes release];
    [values release];
    
    return Animation;
    
}

//TODO: 放大缩小的animation,带位移
//scaleRect是缩放后的长度比缩放前的倍数,及位移差
//isFromView YES,从view缩放,NO,缩放到view大小
+(CAAnimation *)GetKeyAnimationWithScaleRect:(CGRect)scaleRect
                             transform3D:(CATransform3D)transform
                              isFromView:(BOOL)isFromView
{
    
    NSMutableArray * keyTimes = [[NSMutableArray alloc] init];
    
    NSMutableArray * values = [[NSMutableArray alloc] init];
    
    
    [keyTimes addObject:[NSNumber numberWithInt:0]];
    [keyTimes addObject:[NSNumber numberWithInt:1]];
    
    CATransform3D maxTransform = CATransform3DScale(transform,scaleRect.size.width, scaleRect.size.height,1);
    CATransform3D newTransform = CATransform3DTranslate(maxTransform, scaleRect.origin.x, scaleRect.origin.y, 0);
    
    
    if (isFromView) {
        [values addObject:[NSValue valueWithCATransform3D:transform]];
        [values addObject:[NSValue valueWithCATransform3D:newTransform]];
    }
    else
    {
        [values addObject:[NSValue valueWithCATransform3D:newTransform]];
        [values addObject:[NSValue valueWithCATransform3D:transform]];
        
    }
    
    
    
    CAKeyframeAnimation * Animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    Animation.keyTimes = keyTimes;
    Animation.values = values;
    Animation.fillMode = kCAFillModeForwards;
    
    [keyTimes release];
    [values release];
    
    return Animation;
    
}


+(void)SetPointMoveBasicAnimation:(UIView *)targetView 
                         delegate:(id)delegate 
                              key:(NSString *)key
                         duration:(float)duration
                       startPoint:(CGPoint)startPoint 
                         endPoint:(CGPoint)endPoint
{
    CAAnimation * animation = [ReyAnimation GetPointMoveBasicAnimation:startPoint endPoint:endPoint];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.repeatCount	= 1;
    animation.removedOnCompletion = NO;
    [targetView.layer addAnimation:animation forKey:key];
}


+(void)SetPointMoveShakeAnimation:(UIView *)targetView 
                         delegate:(id)delegate 
                              key:(NSString *)key
                       shakeCount:(int)shakeCount
                       isVertical:(bool)isVertical
                         duration:(float)duration
                       startPoint:(CGPoint)startPoint 
                         endPoint:(CGPoint)endPoint
{
    CAAnimation * animation = [ReyAnimation GetPointMoveKeyAnimationWithShake:shakeCount shakeDirection:isVertical startPoint:startPoint endPoint:endPoint];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.repeatCount	= 1;
    [targetView.layer addAnimation:animation forKey:key];
}

+(void)SetRockerKeyAnimation:(UIView *)targetView 
                    delegate:(id)delegate 
                         key:(NSString *)key
                    duration:(float)duration
                       angle:(float)angle 
                   direction:(ReyAnimationRockDirection)direction
{
    CAAnimation * animation = [ReyAnimation GetRockerKeyAnimation:angle direction:direction];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.repeatCount	= 1;
    [targetView.layer addAnimation:animation forKey:key];
}

+(void)SetRockerKeyAnimation:(UIView *)targetView 
                    delegate:(id)delegate 
                         key:(NSString *)key
                    duration:(float)duration
                       angle:(float)angle 
{
    [ReyAnimation SetRockerKeyAnimation:targetView delegate:delegate key:key duration:duration angle:angle direction:ReyAnimationRockDirectionRandom];
}


+(void)SetScaleKeyAnimation:(UIView *)targetView
                   delegate:(id)delegate
                        key:(NSString *)key
                   duration:(float)duration
                  scaleSize:(CGSize)scaleSize
{
    CAAnimation * animation = [ReyAnimation GetKeyAnimationWithScale:scaleSize transform3D:targetView.layer.transform isFromView:YES];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount	= 1;
    [targetView.layer addAnimation:animation forKey:key];
    
}


+(void)SetScaleKeyAnimation:(UIView *)targetView
                   delegate:(id)delegate
                        key:(NSString *)key
                   duration:(float)duration
                  scaleSize:(CGSize)scaleSize
                 isFromView:(BOOL)isFromView
{
    CAAnimation * animation = [ReyAnimation GetKeyAnimationWithScale:scaleSize transform3D:targetView.layer.transform isFromView:isFromView];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount	= 1;    
    [targetView.layer addAnimation:animation forKey:key];
    
}

+(void)SetFlipKeyAnimation:(UIView *)targetView
                  delegate:(id)delegate
                       key:(NSString *)key
                      time:(float)time
{
    CAAnimation * animation = [ReyAnimation GetKeyAnimationWithScale:CGSizeMake(0.5, 0.5) transform3D:targetView.layer.transform isFromView:NO];
    animation.delegate = nil;
    animation.duration = 0.1*time;
    animation.removedOnCompletion = NO;
    animation.repeatCount	= 1;
    animation.beginTime = 0;
    
    CAAnimation * animation1 = [ReyAnimation GetKeyAnimationWithScale:CGSizeMake(1.1, 1.1) transform3D:targetView.layer.transform isFromView:YES];
    animation1.delegate = nil;
    animation1.duration = 0.05*time;
    animation1.removedOnCompletion = NO;
    animation1.repeatCount	= 1;
    animation1.beginTime = 0.1*time;
    
    CAAnimation * animation2 = [ReyAnimation GetKeyAnimationWithScale:CGSizeMake(1.1, 1.1) transform3D:targetView.layer.transform isFromView:NO];
    animation2.delegate = nil;
    animation2.duration = 0.05*time;
    animation2.removedOnCompletion = NO;
    animation2.repeatCount	= 1;
    animation2.beginTime = 0.15*time;
    
    CAAnimation * animation3 = [ReyAnimation GetKeyAnimationWithScale:CGSizeMake(0.9, 0.9) transform3D:targetView.layer.transform isFromView:YES];
    animation3.delegate = nil;
    animation3.duration = 0.03*time;
    animation3.removedOnCompletion = NO;
    animation3.repeatCount	= 1;
    animation3.beginTime = 0.2*time;
    
    CAAnimation * animation4 = [ReyAnimation GetKeyAnimationWithScale:CGSizeMake(0.9, 0.9) transform3D:targetView.layer.transform isFromView:NO];
    animation4.delegate = nil;
    animation4.duration = 0.05*time;
    animation4.removedOnCompletion = NO;
    animation4.repeatCount	= 1;
    animation4.beginTime = 0.23*time;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animation,animation1,animation2,animation3,animation4, nil];
    group.delegate = delegate;
    group.duration = 0.28*time;
    group.removedOnCompletion = NO;
    group.repeatCount	= 1;
    group.fillMode = kCAFillModeForwards;
    //    group.timeOffset = 0.23;
    
    
    [targetView.layer addAnimation:group forKey:key];
}


+(void)SetScaleRectKeyAnimation:(UIView *)targetView
                       delegate:(id)delegate
                            key:(NSString *)key
                       duration:(float)duration
                      scaleRect:(CGRect)scaleRect
                     isFromView:(BOOL)isFromView
{
    CAAnimation * animation = [ReyAnimation GetKeyAnimationWithScaleRect:scaleRect
                                                             transform3D:targetView.layer.transform
                                                              isFromView:isFromView];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount	= 1;
    [targetView.layer addAnimation:animation forKey:key];
    
}

+(void)SetRotationBasicAnimation:(UIView *)targetView
                        delegate:(id)delegate
                             key:(NSString *)key
                        duration:(float)duration
                       fromAngle:(float)fromAngle
                         toAngle:(float)toAngle
{
    CAAnimation * animation = [ReyAnimation GetRotationBasicAnimation:fromAngle toAngle:toAngle];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount	= 1;
    [targetView.layer addAnimation:animation forKey:key];
    
}

+(void)SetOpacityBasicAnimation:(UIView *)targetView
                        delegate:(id)delegate
                             key:(NSString *)key
                        duration:(float)duration
                       fromValue:(float)fromValue
                         toValue:(float)toValue
{
    CAAnimation * animation = [ReyAnimation GetOpacityAnimation:fromValue toValue:toValue];
    animation.delegate = delegate;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount	= 1;
    [targetView.layer addAnimation:animation forKey:key];
    
}

@end
