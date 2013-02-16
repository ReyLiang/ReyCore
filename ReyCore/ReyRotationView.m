//
//  ReyRotationView.m
//  PopupTest
//
//  Created by rey liang on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyRotationView.h"
#import "ReyAnimation.h"


@interface ReyRotationView()

-(float)getAngle;

@end

@implementation ReyRotationView

@synthesize imageButton;

//为了效果好看,圆心外移特定单位
#define CENTER_SPACE 10

//最大偏转角度
#define MAX_ANGLE 15

//最小偏转角度
#define MIN_ANGLE 5

//动画时间
#define ANIMATION_DURATION 10

- (id)initWithFrame:(CGRect)frame 
        centerState:(ReyRotationViewCenterState)centerState 
           imgsArry:(NSArray *)imgsArry
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //初始化,旋转点和背景图片frame
        CGRect imageBtnFrame;
        switch (centerState) {
            case ReyRotationViewCenterStateLeft:
          {
            self.layer.anchorPoint = CGPointMake(0, 0.5);
            imageBtnFrame = CGRectMake(CENTER_SPACE , 
                                        0, 
                                        frame.size.width - CENTER_SPACE, 
                                        frame.size.height);
            break;
          }
            case ReyRotationViewCenterStateUp:
          {
            self.layer.anchorPoint = CGPointMake(0.5, 0);
            imageBtnFrame = CGRectMake(0 , 
                                        CENTER_SPACE , 
                                        frame.size.width , 
                                        frame.size.height - CENTER_SPACE);
            break;
          }
            case ReyRotationViewCenterStateRight:
          {
            self.layer.anchorPoint = CGPointMake(1, 0.5);
            imageBtnFrame = CGRectMake(0 , 
                                        0, 
                                        frame.size.width - CENTER_SPACE, 
                                        frame.size.height);
            break;
          }
            case ReyRotationViewCenterStateDown:
          {
            self.layer.anchorPoint = CGPointMake(0.5, 1);
            imageBtnFrame = CGRectMake(0 , 
                                        0, 
                                        frame.size.width , 
                                        frame.size.height - CENTER_SPACE);
            break;
          }
        }
        
        imageButton = [[UIButton alloc] initWithFrame:imageBtnFrame];
        [imageButton setBackgroundImage:[imgsArry objectAtIndex:0] forState:UIControlStateNormal];
        [imageButton setBackgroundImage:[imgsArry objectAtIndex:1] forState:UIControlStateHighlighted];
        [self addSubview:imageButton];

        self.frame = frame;
    }
    return self;
}

-(void)dealloc
{

    [imageButton release];

    [super dealloc];
}

-(float)getAngle
{
    
    srandomdev();
    
    float angle = random()% MAX_ANGLE;
    if (angle < MIN_ANGLE) {
        angle = MIN_ANGLE;
    }
//    //NSLog(@"%f",angle);
    return angle * M_PI/180.0;
}

-(float)getDuration:(float)angle
{
    float maxAngle = MAX_ANGLE * M_PI / 180.0;
    
    return angle * ANIMATION_DURATION / maxAngle;
}

-(void)startRocker
{
    isRocker = YES;
    float angle = [self getAngle];
    float duration = [self getDuration:angle];
    [ReyAnimation SetRockerKeyAnimation:self delegate:self key:@"Rocker" duration:duration angle:angle];
}

-(void)stopRocker
{
    isRocker = NO;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (isRocker) {
            float angle = [self getAngle];
            float duration = [self getDuration:angle];
            //NSLog(@"angle %f duration %f",angle,duration);
            [ReyAnimation SetRockerKeyAnimation:self delegate:self key:@"Rocker" duration:duration angle:angle];
        }
    }
}


@end
