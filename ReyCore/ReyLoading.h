/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyLoading.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/13 
 
 Description: 
 
 加载等待界面
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@interface ReyLoading : UIView
{
    UIActivityIndicatorView * activityView ;
    
    UIView * m_bgView;
}
@property (nonatomic , retain) UIActivityIndicatorView * activityView;
@property (nonatomic , retain) UIView * m_bgView;
-(void)startActivityView;
-(void)stopActivityView;
@end
