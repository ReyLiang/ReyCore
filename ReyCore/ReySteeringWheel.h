/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyCustomAlert.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/2/7 
 
 Description: 
 
 重力感应模拟方向盘
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import <Foundation/Foundation.h>
#import "ReyCoreMotion.h"


@protocol ReySteeringWheelDelegate;

//极品14,重力感应控制方向
//设备重力感应所处的按键发送状态
typedef enum 
{
    ReySteeringWheelMotionStateNone = 0,//直行,不按任何按键 -7~7度
    ReySteeringWheelMotionStateSmallQuick,//小角度转弯 7~15度 -7~-15度
    ReySteeringWheelMotionStateMiddleQuick,//15~35度 -15~-35度
    ReySteeringWheelMotionStateQuick,//每隔一段时间,快速点击某个按键
    ReySteeringWheelMotionStateLong//保持按键处于按下状态
}ReySteeringWheelMotionState;

//主要为了适配极品14
//需要发送的按键列表
typedef enum 
{
    ReySteeringWheelDirectionNone = -1,//直行
    ReySteeringWheelDirectionLeft = 0,//箭头左
    ReySteeringWheelDirectionRight//箭头右
}ReySteeringWheelDirection;

@interface ReySteeringWheel : NSObject
    <ReyCoreMotionDelegate>
{
    //重力感应
    ReyCoreMotion * coreMotion;
    
    ReySteeringWheelDirection lastDirection;
    ReySteeringWheelMotionState lastMotionState;

    
    id<ReySteeringWheelDelegate> delegate;
    
    
    //周期循环的timer
    NSTimer * circleTimer;
    
    float circleInterval;
    
    //调用stopCircle的计数标识
    //-2代表在none区域,等待状态改变
    //-1代表状态切换,进行循环
    long circleCount;
    
    //标记当前circle的周期
    int circleTag;
    
}

@property (nonatomic , retain) ReyCoreMotion * coreMotion;
@property (nonatomic , assign) id<ReySteeringWheelDelegate> delegate;

@property (nonatomic) ReySteeringWheelDirection lastDirection;
@property (nonatomic) ReySteeringWheelMotionState lastMotionState;


@property (nonatomic , retain) NSTimer * circleTimer;

-(id)initWithMotionMode:(ReyCoreMotionMode)motionMode;

-(id)initWithMotionMode:(ReyCoreMotionMode)motionMode interval:(float)interval;

-(void)startCoreMotion;
-(void)stopCoreMotion;


@end


@protocol ReySteeringWheelDelegate <NSObject>

//转向周期开始
-(void)ReySteeringWheelStartCircle:(ReySteeringWheel *)steeringWheel 
                       motionState:(ReySteeringWheelMotionState)state 
                         direction:(ReySteeringWheelDirection)direction;

//转向周期结束
-(void)ReySteeringWheelStopCircle:(ReySteeringWheel *)steeringWheel
                      motionState:(ReySteeringWheelMotionState)state 
                        direction:(ReySteeringWheelDirection)direction;

//获得时时的陀螺仪数据
-(void)ReySteeringWheelCoreMotion:(float)x y:(float)y z:(float)z;

//停止获取转向回调
-(void)ReySteeringWheelCoreMotionDidStop:(ReySteeringWheel *)steeringWheel;

@end
