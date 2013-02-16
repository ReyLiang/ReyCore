/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyRotationView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/10 
 
 Description: 
 
 以四边中一边的重点为圆心摇摆,摇摆角度为-X~X,X为随即角度.
 
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>


typedef enum {
    ReyRotationViewCenterStateLeft,
    ReyRotationViewCenterStateUp,
    ReyRotationViewCenterStateRight,
    ReyRotationViewCenterStateDown
}ReyRotationViewCenterState;

@interface ReyRotationView : UIView
{
    
    

    
    //是否摇摆的标识
    bool isRocker;
    
    
    
    
    UIButton * imageButton;
    
}

@property (nonatomic , retain) UIButton * imageButton;

- (id)initWithFrame:(CGRect)frame 
        centerState:(ReyRotationViewCenterState)centerState 
           imgsArry:(NSArray *)imgsArry;

-(void)startRocker;
-(void)stopRocker;

@end
