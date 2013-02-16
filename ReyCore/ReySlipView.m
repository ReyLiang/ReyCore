//
//  ReySlipView.m
//  ReyCore
//
//  Created by rey liang on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReySlipView.h"


@interface ReySlipView()

-(CGSize)checkdistance:(NSSet * )touches;
-(void)checkSlip:(NSSet *)touches;
-(void)checkDirection:(NSSet *)touches;

@end

@implementation ReySlipView


@synthesize delegate;
@synthesize m_timer;
@synthesize state;

#define X_MIN_DISTANCE 100

#define Y_MIN_DISTANCE 100

#define SAFE_DISTANCE 5

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        state = ReySlipViewStateNone;
        direction = ReySlipViewFromNone;
        beginPoint = CGPointZero;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)dealloc
{
    if (m_timer) {
        [m_timer invalidate];
        [m_timer release];
    }
    [super dealloc];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * touchArry = [touches allObjects];
    UITouch * touch = [touchArry objectAtIndex:0];
    beginPoint = [touch locationInView:self];
    
    state = ReySlipViewStateStart;
    
    
    [super touchesBegan:touches withEvent:event];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self checkDirection:touches];
    [self checkSlip:touches];
    
    [super touchesMoved:touches withEvent:event];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    

    
    [m_timer invalidate];
    m_timer = NULL;
    
    beginPoint = CGPointZero;
    [super touchesEnded:touches withEvent:event];

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [m_timer invalidate];
    m_timer = NULL;
    beginPoint = CGPointZero;
    [super touchesEnded:touches withEvent:event];

}


//检查移动距离是否到达最小呼出值
-(CGSize)checkdistance:(NSSet * )touches
{
    NSArray * touchArry = [touches allObjects];
    UITouch * touch = [touchArry objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    
    return CGSizeMake(point.x - beginPoint.x, point.y - beginPoint.y);
}

-(void)checkDirection:(NSSet *)touches
{

    
    NSArray * touchArry = [touches allObjects];
    UITouch * touch = [touchArry objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    CGPoint lastPoint = [touch previousLocationInView:self];
    
    float width = point.x - lastPoint.x;
    float height = point.y - lastPoint.y;
    
    
    //处于安全移动距离,不处理
    if (fabsf(width) < SAFE_DISTANCE && fabsf(height) < SAFE_DISTANCE) {
        
        return;
    }
    
    //当滑动角度接近45度时,会出现direction判断不准确.
    //如果让其判断准确,则灵敏度下降
    //原因是由于width和height的值相近.
    
    ReySlipViewFromDirection newDriction = direction;
    
    if (fabsf(width) > fabsf(height)) {//判断为横向移动
        if (fabsf(height) <= Y_MIN_DISTANCE) {
            if (width < 0) {//向左
                newDriction = ReySlipViewFromRight;
            }
            else    //向右
              {
                newDriction = ReySlipViewFromLeft;
              }
        }
    }
    else    //判断为纵向移动
      {
        if (fabsf(width) <= Y_MIN_DISTANCE) {
            if (height < 0) {//向上
                newDriction = ReySlipViewFromDown;
            }
            else    //向下
              {
                newDriction = ReySlipViewFromUp;
              }
        }
      }
    
    
    //方向改变重置
    if (newDriction != direction || direction == ReySlipViewFromNone) {
        beginPoint = lastPoint;
        direction = newDriction;
        [m_timer invalidate];
        [m_timer release];
        m_timer = NULL;
    }
    
}

-(void)checkSlip:(NSSet *)touches
{
    CGSize distancePoint = [self checkdistance:touches];
    
    switch (direction) {
        case ReySlipViewFromLeft:
        case ReySlipViewFromRight:
        {
            if (fabsf(distancePoint.height) <= Y_MIN_DISTANCE) {
                
                if (fabsf(distancePoint.width) > X_MIN_DISTANCE) {
                    
                    if (!m_timer) {
                        m_timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delegateSelector) userInfo:nil repeats:YES] retain];
                    }
                }
            }
            break;
        } 
            
        case ReySlipViewFromUp:
        case ReySlipViewFromDown:
        {
            if (fabsf(distancePoint.width) <= X_MIN_DISTANCE) {
                
                if (fabsf(distancePoint.height) > Y_MIN_DISTANCE) {
                    
                    if (!m_timer) {
                        m_timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(delegateSelector) userInfo:nil repeats:YES] retain];
                    }
                }
            }
            break;
        } 
        case ReySlipViewFromNone:   //不处理
            break;
            
            
    }
    


}

-(void)delegateSelector
{
    if (delegate && [delegate respondsToSelector:@selector(slipCompleted: FromDirection:)]) {
        
        [delegate slipCompleted:self FromDirection:direction];
        
    }
}



@end
