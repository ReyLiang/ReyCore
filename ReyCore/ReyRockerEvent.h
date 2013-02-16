/************************************************* 
 
 Copyright (C), 2011-2015, Rey mail=>rey0@qq.com. 
 
 File name:	ReyRocker.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/5 
 
 Description: 
 
 摇杆控制事件.
 支持8方向,4方向
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

//这样排序是为减少if判断,根据特定公式直接读取
//quad为象限函数getQuadrant返回值,angle为角度函数getLessangle返回值.
//symbol在以(m_centetX,m_centerY)为原点的坐标系里时,当x*y>0为1;否则为-1
//也就是点在2,4象限时,symbol为-1;
//公式ret = Quad+(symbol)*angle;
typedef enum 
{
    ReyRockerEventNone,
    ReyRockerEventUp,//上 = 1
    ReyRockerEventUpRight,//右上 = 2
    ReyRockerEventRight,//右 = 3
    ReyRockerEventDownRight,//右下 = 4
    ReyRockerEventDown,//下 = 5
    ReyRockerEventDownLeft,//左下 = 6
    ReyRockerEventLeft,//左 = 7
    ReyRockerEventUpLeft,//左上 = 8
}ReyRockerEventDirection;


@protocol ReyRockerEventDelegate <NSObject>

-(void)ReyRockerEventClicked:(id)rocker direction:(ReyRockerEventDirection)direction;

@end

@interface ReyRockerEvent : UIView
{
    //背景图片
    UIImageView * bgImageView;
    
    //移动图片
    UIImageView * moveImageView;
    
    //移动方向
    ReyRockerEventDirection direction;
    
    id<ReyRockerEventDelegate> delegate;
    
    //圆心的x,y值
    float m_centerX;
    float m_centerY;
}

@property (nonatomic , retain) UIImageView * bgImageView;

@property (nonatomic , retain) UIImageView * moveImageView;

@property (nonatomic , assign) id<ReyRockerEventDelegate> delegate;

- (id)initWithFrame:(CGRect)frame bgImage:(UIImage *)bgImage moveImage:(UIImage *)moveImage;



-(int)getLessangle:(float )x y:(float)y;
-(int)getQuadrant:(float)x y:(float)y;
@end
