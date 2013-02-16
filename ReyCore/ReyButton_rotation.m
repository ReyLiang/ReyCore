//
//  MyClass.m
//  ReyCore
//
//  Created by rey liang on 12-2-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyButton_rotation.h"
#import "ReyAnimation.h"

@implementation ReyButton_rotation

//最大偏转角度
#define MAX_ANGLE 15

//最小偏转角度
#define MIN_ANGLE 5

//动画时间
#define ANIMATION_DURATION 10

- (id)initWithFrame:(CGRect)frame 
        centerState:(ReyButtonRotationState)centerState
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        switch (centerState) {
            case ReyButtonRotationStateLeft:
          {
            self.layer.anchorPoint = CGPointMake(0, 0.5);

            break;
          }
            case ReyButtonRotationStateUp:
          {
            self.layer.anchorPoint = CGPointMake(0.5, 0);
            break;
          }
            case ReyButtonRotationStateRight:
          {
            self.layer.anchorPoint = CGPointMake(1, 0.5);

            break;
          }
            case ReyButtonRotationStateDown:
          {
            self.layer.anchorPoint = CGPointMake(0.5, 1);

            break;
          }
        }
        
        self.frame = frame;

        
    }
    return self;
}


-(void)dealloc
{
    
    
    [super dealloc];
}

-(float)getAngle
{
    

    srandomdev();
    
    float angle = random()% MAX_ANGLE;
    if (angle < MIN_ANGLE) {
        angle = MIN_ANGLE;
    }
    //NSLog(@"rocker  %f",angle);
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
//            //NSLog(@"angle %f duration %f",angle,duration);
            [ReyAnimation SetRockerKeyAnimation:self delegate:self key:@"Rocker" duration:duration angle:angle];
        }
    }
}


@end
