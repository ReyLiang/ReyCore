/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyPopupView_circleItem.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/10 
 
 Description: 
 
 弹出按钮
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol ReyPopupView_circleItemDelegate;

@interface ReyPopupView_circleItem : UIButton

{
    CGMutablePathRef showPath;
    CGMutablePathRef hidePath;
    
    //动画结束的回调
    
    //动画状态标识
    bool isShowAnimation;
    
    float m_startangle;
    float m_endangle;
    
    id<ReyPopupView_circleItemDelegate> delegate;
    
    
}
@property (nonatomic , assign) id<ReyPopupView_circleItemDelegate> delegate;

-(void)startShowAnimation;
-(void)startHideAnimation;
-(void)addMoveAnimationWithPathCenter:(CGPoint)pathCenter 
                            startangle:(float)starangle 
                             endangle:(float)endangle 
                              randius:(float)randius
                          isClockWise:(bool)isClockWise;
@end


//按钮动画结束的回调
@protocol ReyPopupView_circleItemDelegate <NSObject>

-(void)circleItemShowAnimationFinished:(ReyPopupView_circleItem *)item;
-(void)circleItemHideAnimationFinished:(ReyPopupView_circleItem *)item;

@end