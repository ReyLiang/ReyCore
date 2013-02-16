//
//  ReyRocker.m
//  ReyCore
//
//  Created by rey liang on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyRockerEvent.h"


@interface ReyRockerEvent()

-(void)checkMoveInRect:(CGPoint )point;
-(void)sendDirection:(ReyRockerEventDirection)aDirection;
-(bool)checkInMinCircle:(CGPoint)point;
-(CGPoint)checkInMaxCircle:(CGPoint)point;
@end

@implementation ReyRockerEvent

@synthesize bgImageView;
@synthesize moveImageView;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame bgImage:(UIImage *)bgImage moveImage:(UIImage *)moveImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        direction = ReyRockerEventNone;
        m_centerX = frame.size.width/2;
        m_centerY = frame.size.height/2;
        
        bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        bgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:bgImageView];
        
        
        //初始化MoveImageView
        moveImageView = [[UIImageView alloc] initWithImage:moveImage];
        moveImageView.frame = CGRectMake(0, 0, moveImage.size.width, moveImage.size.height);
        moveImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:moveImageView];
    }
    return self;
}

-(void)dealloc
{
    
    [bgImageView release];
    [moveImageView release];
    [super dealloc];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet * eventSet = [event touchesForView:self];
    NSArray * eventArry = [eventSet allObjects];
    
    //只支持单点触摸
    CGPoint point = [[eventArry objectAtIndex:0] locationInView:self];
    moveImageView.center = point;
    [self checkMoveInRect:point];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet * touchSet = [event touchesForView:self];
    NSArray * touchArry = [touchSet allObjects];
    CGPoint point = [[touchArry objectAtIndex:0] locationInView:self];
    CGPoint newPoint = [self checkInMaxCircle:point];
    
    moveImageView.center = newPoint;
    [self checkMoveInRect:newPoint];
    [super touchesMoved:touches withEvent:event];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendDirection:ReyRockerEventNone];
    moveImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendDirection:ReyRockerEventNone];
    moveImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [super touchesCancelled:touches withEvent:event];
}

-(void)checkMoveInRect:(CGPoint )point
{
    //在小圆内的移动不处理
    if ([self checkInMinCircle:point]) {
        [self sendDirection:ReyRockerEventNone];
        return;
    }
    
    
    int angle =[self getLessangle:point.x y:point.y];
    int quad = [self getQuadrant:point.x-m_centerX y:m_centerY-point.y];
    int symbol = -1;
    
    if ((m_centerY - point.y)*(point.x - m_centerX) > 0) {
        symbol = 1;
    }
    direction = quad + symbol * angle;
    if (direction == 9) {
        direction =1;
    }
    [self sendDirection:direction];
    return;
}

//发送方向消息
-(void)sendDirection:(ReyRockerEventDirection)aDirection
{
    if (delegate && [delegate respondsToSelector:@selector(ReyRockerEventClicked: direction:)]) {
        [delegate ReyRockerEventClicked:self direction:aDirection];
    }
}

//在小圆内的移动不处理
-(bool)checkInMinCircle:(CGPoint)point
{
    float x = point.x - m_centerX;
    float y = m_centerY - point.y;
    
    //在半径为r大小的圆内不处理移动
    float r = moveImageView.frame.size.width*1/2;
    
    
    if ((x*x+y*y) < (r*r)) {
        return YES;
    }
    
    return NO;
    
}

//检测moveImageView是否超出边界
-(CGPoint)checkInMaxCircle:(CGPoint)point
{
    
    float x = point.x - m_centerX;
    float y = m_centerY - point.y;
    float r = self.frame.size.width/2 - moveImageView.frame.size.width/2;
    
    //平方值
    float x2 = x*x;
    float y2 = y*y;
    float r2 = r*r;
    
    
    if (x2 + y2 <= r2) {
        return point;
    }
    
    //求该点所对应的原始点
    float a = y/x;
    float newX ;
    float newY ;
    //公式 y=ax;
    //x^2 + y^2 = r^2
    
    newX = sqrtf(r2/(1+a*a));
    if (x<0) {
        newX = -newX;
    }
    newY = a*newX;
    return CGPointMake(newX+m_centerX, m_centerY-newY);
}

//获得点在以m_centerX,m_centerY为原点的坐标系中所在象限
-(int)getQuadrant:(float)x y:(float)y
{
    if (x>=0) {
        if (y>=0) {
            return 2;
        }
        else
          {
            return 4;
          }
    }
    else
      {
        if (y >= 0) {
            return 8;
        }
        else
          {
            return 6;
          }
      }
}

//判断角度是否小于M_PI_4
-(int)getLessangle:(float )x y:(float)y
{
    
    float length = sqrtf((x-m_centerX)*(x-m_centerX) + (y-m_centerY)*(y-m_centerY));
    
    float sinV = fabsf(x-m_centerX)/length;
    float du = fabsf(asinf(sinV));
//    //NSLog(@"x = %f y = %f du =%f",x,y,du);
    if (du <= (M_PI_4/2)) {//贴近y轴
                           //        //NSLog(@"度数小于22.5");
        return -1;
    }
    else if(du <(M_PI_2-M_PI_4/2))//斜方向
      {
        //        //NSLog(@"度数小于22.5 小于77.5");
        return 0;
      }
    else //贴近x轴
      {
        //        //NSLog(@"度数大于77.5");
        return 1;
      }
    
}

@end
