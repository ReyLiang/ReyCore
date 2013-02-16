/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyInterchangeView_moveItem.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/2/4 
 
 Description: 
 
 可以拖拽的button
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol ReyInterchangeView_moveItemDelegate;


@interface ReyInterchangeView_moveItem : UIButton
{
    id<ReyInterchangeView_moveItemDelegate> delegate;
    
    //在touch事件结束的时候,要设定的值
    //外部可以在本类回调函数中设置值
    CGPoint m_nowCenterPoint;
    
    float borderWidth;
    float borderHeight;
    
    //标识是否处于互换模式
    bool m_canItercanged;
    
    //交换的标识
    int m_interchangeTag;

}

@property (nonatomic , assign)id<ReyInterchangeView_moveItemDelegate> delegate;
@property (nonatomic) CGPoint m_nowCenterPoint;
@property (nonatomic) bool m_canItercanged;
@property (nonatomic) int m_interchangeTag;
@end


@protocol ReyInterchangeView_moveItemDelegate <NSObject>

-(void)moveItemMoveEnd:(ReyInterchangeView_moveItem *)item;
-(void)moveItemMoveStart:(ReyInterchangeView_moveItem *)item;

@end