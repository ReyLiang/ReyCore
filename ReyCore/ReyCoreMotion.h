//
//  ReyCoreMotion.h
//  GyroDemo
//
//  Created by I Mac on 11-4-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

typedef enum CoreMotionMode {
	GyroMode,//陀螺仪模式
	AccelerMode,//重力感应
	UserAccelerMode,//体态模式,用于体态游戏
}ReyCoreMotionMode;

@protocol ReyCoreMotionDelegate <NSObject>

-(void)ReyCoreMotionWidthx:(float)x y:(float)y z:(float)z;

@end

@interface ReyCoreMotion : NSObject {
    
    id<ReyCoreMotionDelegate> delegate;
    
    //陀螺仪
	CMMotionManager * myMotionManager;
	
	//回调函数Timer
	NSTimer * timer;
	
	//要设定,否则无法回调
	//回调函数Timer执行周期
	float second;
	
	//可移动范围
	CGRect superFrame;
	
	//取值标准
	ReyCoreMotionMode motionMode;
    
    bool isRunning;
}
@property (nonatomic , assign)id<ReyCoreMotionDelegate> delegate;
@property (nonatomic , retain) CMMotionManager * myMotionManager;

@property (nonatomic , retain) NSTimer * timer;
@property (nonatomic , assign) ReyCoreMotionMode motionMode;

//初始化CoreMotion
-(void)initCoreMotion;

//设置回调周期
-(void)setSecond:(NSTimeInterval)time;

//设置移动范围
-(void)setSuperFrame:(CGRect)rect;

//移动范围检查
-(CGRect)checkMoveRect:(CGRect)rect;

//检查一个数是否超出一个区间里
-(float)checkInRange:(float )number min:(float)min max:(float)max;

-(void)startUpdate;

-(void)stopUpdate;

@end
