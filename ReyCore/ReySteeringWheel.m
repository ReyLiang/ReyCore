//
//  ReySteeringWheel.m
//  ReyCore
//
//  Created by rey liang on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReySteeringWheel.h"

@implementation ReySteeringWheel

//陀螺仪上数据
//0~1标识0度~180度
#define SMALLQUCIK_ANGLE    0.107
#define MIDDLEQUCIK_ANGLE   0.196
#define QUCIK_ANGLE         0.419
#define LONG_ANGLE          0.53

//从陀螺仪更新数据的周期
#define UPADATE_INTERVAL        0.001

//响应时间的周期
#define SMALLQUCIK_INTERVAL     10
#define MIDDLEQUCIK_INTERVAL    15
#define QUCIK_INTERVAL          30
#define LONG_INTERVAL           FLT_MAX

@synthesize coreMotion;
@synthesize lastDirection,lastMotionState;
@synthesize delegate;
@synthesize circleTimer;



-(id)initWithMotionMode:(ReyCoreMotionMode)motionMode interval:(float)interval 
{
    self = [super init];
    if (self) {
        circleInterval = interval;
        coreMotion = [[ReyCoreMotion alloc] init];
        coreMotion.motionMode = motionMode;
        coreMotion.delegate = self;
        [coreMotion setSecond:circleInterval]; 
        
        lastDirection = ReySteeringWheelDirectionNone;
        lastMotionState = ReySteeringWheelDirectionNone;
    }
    return self;
}


-(id)initWithMotionMode:(ReyCoreMotionMode)motionMode
{
    self = [self initWithMotionMode:motionMode interval:UPADATE_INTERVAL];
    return self;
}

-(void)dealloc
{
    [coreMotion stopUpdate];
    [coreMotion release];
    
    [circleTimer invalidate];
    [circleTimer release];
    [super dealloc];
}



-(void)startCoreMotion
{
    [coreMotion startUpdate];
    circleCount = -2;
    circleTimer = [[NSTimer scheduledTimerWithTimeInterval:UPADATE_INTERVAL target:self selector:@selector(circleMotion) userInfo:nil repeats:YES] retain];
    
}

-(void)stopCoreMotion
{
    circleCount = -2;
    [coreMotion stopUpdate];
    
    if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelCoreMotionDidStop:)])
      {
        [delegate ReySteeringWheelCoreMotionDidStop:self];
      }
}

-(void)circleMotion
{
    if (-2 == circleCount) {
//        //NSLog(@" -2 circleMotion");
        return;
    }
    
    if (-1 == circleCount) {//等待一个循环周期
//        //NSLog(@" -1 circleMotion");
    }
    else if (0 == circleCount)
      {
//        //NSLog(@" 0 circleMotion");
        if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelStartCircle:
                                                               motionState: 
                                                               direction:)])
          {
            [delegate ReySteeringWheelStartCircle:self 
                                     motionState:lastMotionState 
                                       direction:lastDirection];
        }
        
        if (lastMotionState == ReySteeringWheelMotionStateNone) {
            circleCount = -2;
            return;
        }
        
      }
    else if (circleTag == circleCount)
      {
//        //NSLog(@" %d ,%d , %d circleMotion",circleTag,lastMotionState,lastDirection);
        if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelStopCircle:
                                                               motionState: 
                                                               direction:)]) 
          {
            [delegate ReySteeringWheelStopCircle:self 
                                     motionState:lastMotionState 
                                       direction:lastDirection];
          }
        circleCount = -1;
        return;
      }
    
    circleCount ++;
}

-(void)ReyCoreMotionWidthx:(float)x y:(float)y z:(float)z
{
    if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelCoreMotion:
                                                           y:z:)]) 
      {
        [delegate ReySteeringWheelCoreMotion:x y:y z:z];
      }
    
    
    float fabsY = fabsf(y);
    ReySteeringWheelMotionState nowMotionState = ReySteeringWheelMotionStateNone;
    ReySteeringWheelDirection nowDirection = ReySteeringWheelDirectionNone;
    
    //判断按键状态
    if (fabsY > LONG_ANGLE) {//50度
        nowMotionState = ReySteeringWheelMotionStateLong;
        circleTag = LONG_INTERVAL;
        //        //NSLog(@"@@@@@@  MotionStateLong");
    }
    else if (fabsY > QUCIK_ANGLE)//35度
      {
        nowMotionState = ReySteeringWheelMotionStateQuick;
        circleTag = QUCIK_INTERVAL / (circleInterval / UPADATE_INTERVAL);
      }
    else if (fabsY > MIDDLEQUCIK_ANGLE)//15度
      {
        nowMotionState = ReySteeringWheelMotionStateMiddleQuick;
        circleTag = MIDDLEQUCIK_INTERVAL / (circleInterval / UPADATE_INTERVAL);
      }
    else if (fabsY > SMALLQUCIK_ANGLE)//7度
      {
        nowMotionState = ReySteeringWheelMotionStateSmallQuick;
        circleTag = SMALLQUCIK_INTERVAL / (circleInterval / UPADATE_INTERVAL);
        //        //NSLog(@"$$$$$$$$  MotionStateQuick");
      }
    else 
      {
        nowMotionState = ReySteeringWheelMotionStateNone;
        
        circleCount = -2;
        if (lastDirection != ReySteeringWheelDirectionNone && 
            lastMotionState != ReySteeringWheelMotionStateNone)
          {
            if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelStopCircle:
                                                                   motionState: 
                                                                   direction:)]) 
              {
                [delegate ReySteeringWheelStopCircle:self 
                                         motionState:ReySteeringWheelMotionStateNone 
                                           direction:lastDirection];
              }
          }
        lastMotionState = nowMotionState;
        
        return;
      }
    
    
    
    //没有变化
    if (nowMotionState == lastMotionState) {
        return;
    }
//    //NSLog(@"~~~~~~~~start~~~~~~~");
//    //NSLog(@"state %d",nowMotionState);
    
    //motionstate变化跨度大
    //一次跨过1个以上的角度判断区
//    if (fabsf(nowMotionState - lastMotionState) > 1) {
//        //NSLog(@"\n\n\n\n\n\n\n\nwaring !!!! %f , now = %d , last = %d\n\n\n\n\n\n\n\n", fabsf(nowMotionState - lastMotionState),nowMotionState,lastMotionState);
////        abort();
//    }
    
    
    
    //判断按键类型
    if (x>0) {
        
        //左
        if (y < -SMALLQUCIK_ANGLE) 
          {
            nowDirection = ReySteeringWheelDirectionLeft;
          }
        else if(y >SMALLQUCIK_ANGLE)//右
          {
            nowDirection = ReySteeringWheelDirectionRight;
          }
        
    }
    else if(x < -0)
      {
        //右
        if (y < -SMALLQUCIK_ANGLE) 
          {
            nowDirection = ReySteeringWheelDirectionRight;
          }
        else if(y >SMALLQUCIK_ANGLE)//左
          {
            nowDirection = ReySteeringWheelDirectionLeft;
          }
        
      }
    else //忽略
      {
        //不被响应
        //NSLog(@"%f,%f,%f",x,y,z);
        //NSLog(@"### %f",x);
        return;
      }
    

    
    
    if (nowDirection != lastDirection) {
        
        //方向改变
        if (lastDirection != ReySteeringWheelDirectionNone) {
            if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelStopCircle:
                                                                   motionState: 
                                                                   direction:)]) 
              {
                [delegate ReySteeringWheelStopCircle:self 
                                         motionState:lastMotionState 
                                           direction:lastDirection];
              }
        }
        else
          {
            //NSLog(@"############## 方向为 none");
          }
        lastDirection = nowDirection;
    }
    
    //结束上一区域操作
  {
    if (delegate && [delegate respondsToSelector:@selector(ReySteeringWheelStopCircle:
                                                           motionState: 
                                                           direction:)]) 
      {
        [delegate ReySteeringWheelStopCircle:self 
                                 motionState:lastMotionState 
                                   direction:lastDirection];
      }
    
    circleCount = -2;
  }
    
    
    
    lastMotionState = nowMotionState;
    
    
    circleCount = -1;
//    //NSLog(@"~~~~~~~~end~~~~~~~");
    return;
    
}

#pragma mark -

@end
