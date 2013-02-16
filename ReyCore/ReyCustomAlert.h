/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyCustomAlert.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/14 
 
 Description: 
 
 自定义警告框.
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol ReyCustomAlertDelegate <NSObject>

-(void)alertBtnClicked:(id)sender btn:(UIButton *)clickedBtn;

@end

@interface ReyCustomAlert : UIView

{
    //如果img和title都指定,必须一一对应.
    //img和title可以只指定其中一个.
    //按钮图片
    NSArray * btnImgsArry;
    bool isSetImgs;
    
    //按钮标题
    NSArray * btnTitlesArry;
    bool isSetTitles;
    
    //警告信息
    NSString * message;
    
    //标识
    int tag;
    
    bool isAutoRemove;
    
    //判断分辨率进而加载view
    int m_deviceTag;
    
    
    id<ReyCustomAlertDelegate> delegate;
}

@property (nonatomic) int tag;
@property (nonatomic) bool isAutoRemove;
@property (nonatomic, retain) NSArray * btnImgsArry;
@property (nonatomic, retain) NSArray * btnTitlesArry;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, assign) id<ReyCustomAlertDelegate> delegate;


- (id)initWithFrame:(CGRect)frame 
           delegate:(id<ReyCustomAlertDelegate>)aDelegate 
    backgroundImage:(UIImage *)image
            message:(NSString *)aMessage 
         buttonImgs:(NSArray *)imgsArray 
       buttonTitles:(NSArray *) titlesArray;

-(void)removeAlert;
-(void)buttonClicked:(UIButton *)btn;

@end
