//
//  ReyPullView_moveBtn.h
//  PopupTest
//
//  Created by rey liang on 12-1-15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//moveBtn所处状态
typedef enum {
    ReyPullView_moveBtnStateHided = 0,
    ReyPullView_moveBtnStateShowed
}ReyPullView_moveBtnState;

//拉出view的方向
typedef enum {
    ReyPullView_pullFromDirectionLeft = 0,
    ReyPullView_pullFromDirectionUp,
    ReyPullView_pullFromDirectionRight,
    ReyPullView_pullFromDirectionDown,
}ReyPullView_pullFromDirection;


//动画时间
#define ANIMATION_DURATION 0.3

@protocol ReyPullView_moveBtnDelegate;


@interface ReyPullView_moveBtn : UIButton
{
    //上一中心坐标
    CGPoint lastCenter;
    
    //上一位移坐标
    CGPoint lastPoint;
    //开始点击坐标
    CGPoint beginPoint;
    
    
    ReyPullView_moveBtnState m_state;
    
    ReyPullView_pullFromDirection direction;
    
    //根据拉出方向,来确定center的最终值
    //例如:left,directionTagX = 1,directionTagY = 0;
    int directionTagX;
    int directionTagY;
    
    //移动相应距离
    float distance;
    //要拖出view的大小
    CGSize pulledViewSize;
    
    id<ReyPullView_moveBtnDelegate> delegate;

}
@property (nonatomic , assign) id<ReyPullView_moveBtnDelegate> delegate;
@property (nonatomic) ReyPullView_moveBtnState m_state;
@property (nonatomic) CGPoint lastCenter;

- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullView_pullFromDirection)aDirection 
           distance:(float)aDistance 
     pulledViewSize:(CGSize)aPulledViewSize;

-(void)changeState;

//模拟单击事件
-(void)moveBtnCliecked;
@end


@protocol ReyPullView_moveBtnDelegate <NSObject>

//没次有移动就回调
//TODO: moveBtn: self
//TODO: distanceSize: 偏移向量
//TODO: isFinished: 是否结束,表示touchEnd被调用
-(void)moveBtnMoved:(ReyPullView_moveBtn *)moveBtn 
       distanceSize:(CGSize)distanceSize 
         isFinished:(bool)isFinished
        stateChange:(bool)changed;

//点击开始
-(void)moveBtnBegined:(ReyPullView_moveBtn *)moveBtn;

@end