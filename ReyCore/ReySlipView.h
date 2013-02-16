/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReySlipView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/2/6 
 
 Description: 
 
 判断手势滑动.
 支持4个方向.
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 *************************************************/ 

#import <UIKit/UIKit.h>




typedef enum {
    ReySlipViewFromNone,
    ReySlipViewFromLeft,
    ReySlipViewFromUp,
    ReySlipViewFromRight,
    ReySlipViewFromDown
}ReySlipViewFromDirection;


typedef enum {
    ReySlipViewStateNone,
    ReySlipViewStateStart,
    ReySlipViewStateFinished
    
}ReySlipViewState;



@protocol ReySlipViewDelegate <NSObject>

//TODO: direction: 用户触发的滑动方向
-(void)slipCompleted:(id)sender FromDirection:(ReySlipViewFromDirection)direction;

@end

@interface ReySlipView : UIView
{
    //判断开始坐标
    CGPoint beginPoint;
    
    //判断状态
    ReySlipViewState state;
    
    ReySlipViewFromDirection direction;
    
    id<ReySlipViewDelegate> delegate;
    
    NSTimer * m_timer;
}

@property (nonatomic , assign) id<ReySlipViewDelegate> delegate;
@property (assign) ReySlipViewState state;
@property (nonatomic , retain) NSTimer * m_timer;
@end
