/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyPullView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/10 
 
 Description: 
 
 拉出效果的界面
 
 功能:
 可以设置最大拉出距离.
 可以设置拉出安全距离.小于安全距离的,代表不弹出.
 可以设置view到达位置后,弹动幅度,弹动次数和弹动时间
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>
#import "ReyPullView_moveBtn.h"

#define EFFECTIVE_DISTANCE 50
#define MASK_IMAGENAME @"ReyMask@2x"

@protocol ReyPullViewDelegate;


//拉出view的方向
typedef enum {
    ReyPullViewFromDirectionLeft,
    ReyPullViewFromDirectionUp,
    ReyPullViewFromDirectionRight,
    ReyPullViewFromDirectionDown,
}ReyPullViewFromDirection;



@interface ReyPullView : UIView
    <ReyPullView_moveBtnDelegate>
{
    //要拉出来的view
    UIView * pulledView;
    
    //拉出的方向
    ReyPullViewFromDirection direction;
    
    ReyPullView_moveBtn * moveBtn;
    
    //拉出view的上一次中心坐标.
    CGPoint pulledView_lastCenter;
    
    //最大显示距离
    CGPoint showPoint;
    
    //摇动效果
    bool isShake;
    
    //如果有多个moveBtn,其大小需要区moveBtn的交集
    float btnWidth;
    float btnHeight;
    
    //moveBtn的背景图片
    NSArray * bgimgArry;
    
    //在superview中subviews的index
    int indexInSuperview;
    
    id<ReyPullViewDelegate> delegate;
    
    //在pullview显示时,是否加50%黑的背景颜色.
    bool isShowBgColor;
    
    
}

@property (nonatomic , retain) UIView * pulledView;
@property (nonatomic , retain) ReyPullView_moveBtn * moveBtn;
@property (nonatomic , assign) id<ReyPullViewDelegate> delegate;
@property (nonatomic , retain) NSArray * bgimgArry;

@property (nonatomic) bool isShowBgColor;



- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullViewFromDirection)aDirection 
         pulledView:(UIView *)aPullView
        moveBtnImgs:(NSArray *)imgsArry 
          showPoint:(CGPoint)aShowPoint;

//快速显示或隐藏
//模拟单击moveBtn
-(void)QiuckShowOrHide;

@end

@protocol ReyPullViewDelegate <NSObject>

-(void)PullViewShowed:(ReyPullView *)pullView;
-(void)PullViewHided:(ReyPullView *)pullView state:(bool)isChanged;

-(void)PullViewWillShow:(ReyPullView *)pullView;



@end







