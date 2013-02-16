//
//  ReyCoreMotion.m
//  GyroDemo
//
//  Created by I Mac on 11-4-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReyCoreMotion.h"


@interface ReyCoreMotion()
-(void)updateGyroMode;
-(void)updateAccelerMode;
-(void)updateUserAccelerMode;
-(void)myDelegateWithx:(float)x y:(float)y z:(float)z;
@end


@implementation ReyCoreMotion

@synthesize delegate;
@synthesize myMotionManager;
@synthesize timer;
@synthesize motionMode;

//响应精确度设置
//基础层frame转换到view层的映射
//模拟世界坐标到设备坐标
#define MAPPINGWIDTH 768    //device移动映射宽
#define MAPPINGHEIGHT 1024  //device移动映射高

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code.
		second = 1.0/60.0;
		myMotionManager = nil;
		timer = nil;
        isRunning = false;
		
		superFrame = CGRectMake(0, 
								0, 
								MAPPINGWIDTH, 
								MAPPINGHEIGHT);
		[self initCoreMotion];
		
		
    }
    return self;
}






//初始化CoreMotion
-(void)initCoreMotion
{
	myMotionManager = [[CMMotionManager alloc] init];
	[myMotionManager startGyroUpdates];
	[myMotionManager startDeviceMotionUpdates];
	[myMotionManager startAccelerometerUpdates];
}

//设置回调周期
-(void)setSecond:(NSTimeInterval)time
{
	second = time;
//    return;
}

-(void)startUpdate
{
    isRunning = YES;
    
    if (!timer) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:second 
                                                  target:self 
                                                selector:@selector(updateMyData) 
                                                userInfo:nil 
                                                 repeats:YES]
                 retain];
    }
}

-(void)stopUpdate
{
    isRunning = NO;
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

//core motion回调函数
-(void)updateMyData
{
    if (isRunning) {
        switch (motionMode) {
            case GyroMode:
                [self updateGyroMode];
                break;
            case AccelerMode:
                [self updateAccelerMode];
                break;
            case UserAccelerMode:
                [self updateUserAccelerMode];
                break;
                
            default:
                break;
        }
    }
       

}

-(void)updateGyroMode
{
    float x = myMotionManager.gyroData.rotationRate.x;
    float y = myMotionManager.gyroData.rotationRate.y;
    float z = myMotionManager.gyroData.rotationRate.z;
//    //NSLog([NSString stringWithFormat:@"accelerometerData \nx=%0.1f , \ny=%0.1f , \nz=%0.1f\n",
//           myMotionManager.gyroData.rotationRate.x,
//           myMotionManager.gyroData.rotationRate.y,
//           myMotionManager.gyroData.rotationRate.z]);
////NSLog(@"%f,%f,%f",x,y,z);
    if (fabs(x) < 0.005) {
        return;
    }
    if (fabs(y) < 0.005) {
        return;
    }
    [self myDelegateWithx:x y:y z:z];
}
-(void)updateAccelerMode
{
	CMAccelerometerData * accelerData = myMotionManager.accelerometerData;
    float x = myMotionManager.accelerometerData.acceleration.x;
    float y = myMotionManager.accelerometerData.acceleration.y;
    float z = myMotionManager.accelerometerData.acceleration.z;
    if (fabs(x) < 0.005) {
        return;
    }
    if (fabs(y) < 0.005) {
        return;
    }


	[self myDelegateWithx:x y:y z:z];
}

-(void)updateUserAccelerMode
{
	float x = myMotionManager.deviceMotion.userAcceleration.x;
    float y = myMotionManager.deviceMotion.userAcceleration.y;
    float z = myMotionManager.deviceMotion.userAcceleration.z;
    [self myDelegateWithx:x y:y z:z];
}

-(void)myDelegateWithx:(float)x y:(float)y z:(float)z
{
    //NSLog(@"delegate");
    if (delegate && [delegate respondsToSelector:@selector(ReyCoreMotionWidthx:y:z:)]) {
        [delegate ReyCoreMotionWidthx:x y:y z:z];
    }
}

-(void)setFrame:(CGRect)rect
{
	CGRect newRect =[self checkMoveRect:rect];
	if (!CGRectIsNull(newRect)) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.7];
		[super setFrame:newRect];
		[UIView commitAnimations];
	}
	
}

//设置移动范围
-(void)setSuperFrame:(CGRect)rect
{
	superFrame = rect;
	return;
}

//移动范围检查
-(CGRect)checkMoveRect:(CGRect)rect
{
	
	float superX = superFrame.origin.x;
	float superY = superFrame.origin.y;
	float superWidth = superFrame.size.width;
	float superHeight = superFrame.size.height;
	
	float newX = [self checkInRange:rect.origin.x min:superX max:superX+superWidth];
	float newY = [self checkInRange:rect.origin.y min:superY max:superY+superHeight];
	
	if (newX == rect.origin.x || newY == rect.origin.y) {
		return CGRectNull;
	}
    
	
	return CGRectMake(newX, newY, rect.size.width, rect.size.height);
    
}

//检查一个数是否超出一个区间里
-(float)checkInRange:(float )number min:(float)min max:(float)max
{
	if (number > min && number < max) {
		return number;
	}
	else if (number <= min){//最小值
		return min;
	}
	else if (number >= max)//最大值
	{
		return max;
	}
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
    
    isRunning = NO;
    if (timer) {
		[timer invalidate];
		[timer release];
	}
	
	[myMotionManager stopGyroUpdates];
	[myMotionManager stopAccelerometerUpdates];
	[myMotionManager stopDeviceMotionUpdates];
	
	[myMotionManager release];
    
    
	

	
    [super dealloc];
}

@end
