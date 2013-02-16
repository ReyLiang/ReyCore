//
//  ReyPullView_moveBtn.m
//  PopupTest
//
//  Created by rey liang on 12-1-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyPullView_moveBtn.h"
#import "ReyAnimation.h"

@interface ReyPullView_moveBtn()

-(void)resetCenter:(CGSize)newDistance isFinished:(bool)isFinished;

-(void)checkState;

@end

@implementation ReyPullView_moveBtn

@synthesize delegate;
@synthesize m_state;
@synthesize lastCenter;

//防治点击时,有移动
#define CLICKED_DISTANCE 10


//TODO: aDirection: 从哪拉出view
//TODO: aDistance: 拉出多少距离后响应
//TODO: aPulledViewSize: 要拉出view的大小
- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullView_pullFromDirection)aDirection 
           distance:(float)aDistance 
     pulledViewSize:(CGSize)aPulledViewSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        direction = aDirection;
        
        distance = aDistance;
        
        pulledViewSize = aPulledViewSize;
        
        m_state = ReyPullView_moveBtnStateHided;
        
        switch ((int)direction) {
            case ReyPullView_pullFromDirectionLeft:
          {
            directionTagX = 1;
            directionTagY = 0;
            break;
          }
            case ReyPullView_pullFromDirectionUp:
          {
            directionTagX = 0;
            directionTagY = 1;
            break;
          }
            case ReyPullView_pullFromDirectionRight:
          {
            directionTagX = -1;
            directionTagY = 0;
            break;
          }
            case ReyPullView_pullFromDirectionDown:
          {
            directionTagX = 0;
            directionTagY = -1;
            break;
          }
        }

    }
    return self;
}



-(void)dealloc
{
    [super dealloc];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    lastCenter = self.center;
    lastPoint = [[touches anyObject] locationInView:self.superview];
    beginPoint = lastPoint;
    
    if (delegate && [delegate respondsToSelector:@selector(moveBtnBegined:)]) {
        [delegate moveBtnBegined:self];
    }
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self.superview]; 
    [self resetCenter:CGSizeMake((nowPoint.x - lastPoint.x) * fabs(directionTagX), 
                                 (nowPoint.y - lastPoint.y) * fabs(directionTagY)) isFinished:NO];
    lastPoint = nowPoint;
    
    
    [super touchesMoved:touches withEvent:event];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self checkState];
    [super touchesEnded:touches withEvent:event];

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self checkState];
    [super touchesCancelled:touches withEvent:event];

}

//模拟点击事件
-(void)moveBtnCliecked
{
    //模拟按下状态
    lastCenter = self.center;
    
    if (delegate && [delegate respondsToSelector:@selector(moveBtnBegined:)]) {
        [delegate moveBtnBegined:self];
    }
    
    
    //模拟抬起状态
    
    //保持当前状态.再delegate回调完,再赋值给state.
    //避免状态还没改变,就提前赋值给state
    ReyPullView_moveBtnState nowState = m_state;
    
    float distanceX;
    float distanceY;
    switch (m_state) {
        case ReyPullView_moveBtnStateHided:
        {   
            distanceX = pulledViewSize.width;
            distanceY = pulledViewSize.height;
            nowState = ReyPullView_moveBtnStateShowed;
            
            break;
        }
        case ReyPullView_moveBtnStateShowed:
      {
        distanceX = -1 * pulledViewSize.width;
        distanceY = -1 * pulledViewSize.height;
        nowState = ReyPullView_moveBtnStateHided;
      }
            
    }
    
    [self resetCenter:CGSizeMake(directionTagX * distanceX,
                                 directionTagY * distanceY) isFinished:YES];
    m_state = nowState;
}



//检查view所属状态.主要用于设定self.center和delegate的调用
-(void)checkState
{
    float distanceX = lastPoint.x - lastCenter.x;
    float distanceY = lastPoint.y - lastCenter.y;
    
    //保持当前状态.再delegate回调完,再赋值给state.
    //避免状态还没改变,就提前赋值给state
    ReyPullView_moveBtnState nowState = m_state;
    
    if (fabs(lastPoint.x - beginPoint.x) < CLICKED_DISTANCE 
        && fabs(lastPoint.y - beginPoint.y)  <CLICKED_DISTANCE) {//点击结束
        
        switch (m_state) {
            case ReyPullView_moveBtnStateHided:
            {   
                distanceX = pulledViewSize.width;
                distanceY = pulledViewSize.height;
                nowState = ReyPullView_moveBtnStateShowed;
                
                break;
            }
            case ReyPullView_moveBtnStateShowed:
          {
            distanceX = -1 * pulledViewSize.width;
            distanceY = -1 * pulledViewSize.height;
            nowState = ReyPullView_moveBtnStateHided;
          }
                
        }
        
    }
    else//移动结束
      {
        switch (m_state) {
            case ReyPullView_moveBtnStateHided:
          {
            if (directionTagX * distanceX > distance || directionTagY * distanceY > distance ) {

                distanceX = pulledViewSize.width;
                distanceY = pulledViewSize.height;
                nowState = ReyPullView_moveBtnStateShowed;
            }
            else
              {
                distanceX = 0;
                distanceY = 0;
              }
            break;
          }
            case ReyPullView_moveBtnStateShowed:
          {
            if (directionTagX * distanceX < -distance || directionTagY * distanceY < -distance ) {
                
                distanceX = -1 * pulledViewSize.width;
                distanceY = -1 * pulledViewSize.height;
                nowState = ReyPullView_moveBtnStateHided;
            }
            else
              {
                distanceX = 0;
                distanceY = 0;
              }
            break;
          }

        }
        
      }
    
    [self resetCenter:CGSizeMake(directionTagX * distanceX,
                                 directionTagY * distanceY) isFinished:YES];
    m_state = nowState;
}

-(void)resetCenter:(CGSize)newDistance isFinished:(bool)isFinished
{    
    

    
    //view的中心位置.
    //由于状态不同,相对的中心点也不同
    CGPoint viewCenter;
    
    bool stateChange = NO;
    
    [CATransaction begin];
    [CATransaction flush];
    if (isFinished) {
        
        viewCenter = lastCenter;
        
        
        if (!CGSizeEqualToSize(newDistance, CGSizeZero)) {//状态正式改变

            stateChange = YES;
            
        }
        
        
    }
    else
      {
        viewCenter = self.center;
      }
    
    if (delegate && [delegate respondsToSelector:@selector(moveBtnMoved: distanceSize: isFinished: stateChange:)]) {
        [delegate moveBtnMoved:self distanceSize:newDistance isFinished:isFinished stateChange:stateChange];
    }
    
    self.center = CGPointMake(viewCenter.x + newDistance.width , viewCenter.y + newDistance.height);

    
    [CATransaction commit];

    
    
}


//修改moveBtn状态
-(void)changeState
{
    if (ReyPullView_moveBtnStateHided == m_state) {
        m_state = ReyPullView_moveBtnStateShowed;
        return;
    }
    
    m_state = ReyPullView_moveBtnStateHided;
}





@end
