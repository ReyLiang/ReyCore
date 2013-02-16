//
//  ReyInterchangeView_moveItem.m
//  PopupTest
//
//  Created by rey liang on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyInterchangeView_moveItem.h"
#import "ReyAnimation.h"

@interface ReyInterchangeView_moveItem()

-(void)resetCenter:(CGSize)newDistance;
-(CGSize)getMoveDistanceWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;

@end

@implementation ReyInterchangeView_moveItem

@synthesize delegate;
@synthesize m_nowCenterPoint;
@synthesize m_canItercanged;
@synthesize m_interchangeTag;


#define ROCKER_DURATION 0.3

#define ROCKER_ANGLE 17.0*M_PI/180.0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_canItercanged = NO;
        m_interchangeTag = 0;
    }
    return self;
}


-(void)dealloc
{
    [super dealloc];
}

-(void)didMoveToSuperview
{
    borderWidth = self.superview.frame.size.width;
    borderHeight = self.superview.frame.size.height;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_canItercanged) {
        m_nowCenterPoint = self.center;
        if (delegate && [delegate respondsToSelector:@selector(moveItemMoveStart:)]) {
            [delegate moveItemMoveStart:self];
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_canItercanged) {
        UITouch * touch = [[touches allObjects] objectAtIndex:0];
        CGPoint nowPoint = [touch locationInView:self.superview]; 
        CGPoint lastPoint = [touch previousLocationInView:self.superview];
        
        //移动item
        CGSize distance = [self getMoveDistanceWithStartPoint:lastPoint EndPoint:nowPoint];
        [self resetCenter:distance];
        
    }
    
    
    [super touchesMoved:touches withEvent:event];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (m_canItercanged) {
        
        if (delegate && [delegate respondsToSelector:@selector(moveItemMoveEnd:)]) {
            [delegate moveItemMoveEnd:self];
        }
        
        self.center = m_nowCenterPoint;
    }
    
    [super touchesEnded:touches withEvent:event];
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (m_canItercanged) {
        
        if (delegate && [delegate respondsToSelector:@selector(moveItemMoveEnd:)]) {
            [delegate moveItemMoveEnd:self];
        }
        
        self.center = m_nowCenterPoint;
    }
    
    [super touchesCancelled:touches withEvent:event];
    
}


-(void)setM_canItercanged:(_Bool)aM_canItercanged
{
    if (aM_canItercanged) {//互换模式
        [ReyAnimation SetRockerKeyAnimation:self 
                                   delegate:self 
                                        key:@"Interchange" 
                                   duration:ROCKER_DURATION 
                                      angle:ROCKER_ANGLE 
                                  direction:ReyAnimationRockDirectionLeft];
    }
    else
      {
        [self.layer removeAllAnimations];
      }
    m_canItercanged = aM_canItercanged;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [ReyAnimation SetRockerKeyAnimation:self 
                                   delegate:self 
                                        key:@"Interchange" 
                                   duration:ROCKER_DURATION 
                                      angle:ROCKER_ANGLE 
                                  direction:ReyAnimationRockDirectionLeft];
    }
}


-(void)resetCenter:(CGSize)distance
{
    float centerX = self.center.x + distance.width;
    float centerY = self.center.y + distance.height;
    CGPoint newCenter = CGPointMake(centerX, centerY);
    
    
    //检查是否移出边界
    if (centerX < 0) {
        centerX = 0;
    }
    else if(centerX > borderWidth)
      {
        centerX = borderWidth;
      }
    
    if (centerY < 0) {
        centerY = 0;
    }
    else if(centerY > borderHeight)
      {
        centerY = borderHeight;
      }
    
    self.center = CGPointMake(centerX, centerY);
}

//TODO: 获得2点之间距离
-(CGSize)getMoveDistanceWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint
{
    float width = endPoint.x - startPoint.x;
    float height = endPoint.y - startPoint.y;
    
    return CGSizeMake(width, height);
}


@end
