//
//  ReyCustomAlert.m
//  ReyCore
//
//  Created by rey liang on 12-1-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyCustomAlert.h"
#import "ReyError.h"

@interface ReyCustomAlert()

- (void)initData;
- (void)initMessage;
- (void)initButton;
- (int)getDevice;

- (void)addButton:(int)index 
           frame:(CGRect)frame 
             img:(UIImage *)img 
            imgH:(UIImage *)imgH 
           title:(NSString *)title;

- (CGRect)getButtonFrame:(int)index 
                   count:(int)count 
               imageSize:(CGSize)imgSize;

@end

@implementation ReyCustomAlert


@synthesize btnImgsArry,btnTitlesArry,message;
@synthesize delegate;
@synthesize tag;
@synthesize isAutoRemove;

#define BUTTONS_Y 0.66*self.frame.size.height


- (id)initWithFrame:(CGRect)frame 
           delegate:(id<ReyCustomAlertDelegate>)aDelegate 
    backgroundImage:(UIImage *)image
            message:(NSString *)aMessage 
         buttonImgs:(NSArray *)imgsArray 
       buttonTitles:(NSArray *) titlesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        m_deviceTag = [self getDevice];
        
        UIImageView * bgImgView = [[UIImageView alloc] initWithImage:image];
        bgImgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:bgImgView];
        [bgImgView release];
        
        delegate = aDelegate;
        
        isAutoRemove = YES;
        
        message = [aMessage retain];
        
        isSetImgs = NO;
        isSetTitles = NO;
        
        if (imgsArray) {
            btnImgsArry = [imgsArray retain];
            isSetImgs = YES;
        }
        
        if (titlesArray) {
            btnTitlesArry = [titlesArray retain];
            isSetTitles = YES;
        }
        
        
        [self initData];
        
    }
    return self;
}

-(void)initData
{
    [self initMessage];
    [self initButton];
}

//初始化内容
-(void)initMessage
{
    
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40*m_deviceTag, self.frame.size.width, 60*m_deviceTag)];
    
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    messageLabel.text = message;
    messageLabel.numberOfLines = 2;
    messageLabel.lineBreakMode = UILineBreakModeWordWrap;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.font = [UIFont systemFontOfSize:20*m_deviceTag];
    
    messageLabel.shadowColor = [UIColor blackColor];
    messageLabel.shadowOffset = CGSizeMake(0, 1);
    
    [self addSubview:messageLabel];
    [messageLabel release];
    
}

//初始化按钮
-(void)initButton
{
    float btnCount;
    
    if (isSetImgs) {
        btnCount = [btnImgsArry count]/2;
    }
    else
      {
        if (isSetTitles) {
            btnCount = [btnTitlesArry count];
        }
      }
    
    for (int i = 0; i < btnCount; i++) {
        if (isSetImgs && isSetTitles) {
            
            UIImage * img = [btnImgsArry objectAtIndex:i*2];
            UIImage * imgH = [btnImgsArry objectAtIndex:(i*2 +1)];
            CGRect frame = [self getButtonFrame:i count:btnCount imageSize:img.size];
            [self addButton:i 
                      frame:frame
                        img:img
                       imgH:imgH
                      title:[ReyError getLocalize:[btnTitlesArry objectAtIndex:i]]];
        }
        else if (isSetImgs) {
            
            UIImage * img = [btnImgsArry objectAtIndex:i*2];
            UIImage * imgH = [btnImgsArry objectAtIndex:(i*2 +1)];
            CGRect frame = [self getButtonFrame:i count:btnCount imageSize:img.size];
            [self addButton:i 
                      frame:frame
                        img:img
                       imgH:imgH
                      title:nil];
        }
        else if (isSetTitles) {
            CGRect frame = [self getButtonFrame:i count:btnCount imageSize:CGSizeZero];
            [self addButton:i 
                      frame:frame
                        img:nil
                       imgH:nil
                      title:[ReyError getLocalize:[btnTitlesArry objectAtIndex:i]]];
        }
    }
}

//获得按钮的位置信息
-(CGRect)getButtonFrame:(int)index count:(int)count imageSize:(CGSize)imgSize
{
    CGRect frame;
    
    
    //按钮宽高
    float btnWidth;
    float btnHeight;
    
    //有图片
    if (!CGSizeEqualToSize(imgSize, CGSizeZero)) {
        btnWidth = imgSize.width*m_deviceTag;
        btnHeight = imgSize.height*m_deviceTag;
    }
    else //没有背景图片
      {
        btnWidth = 100*m_deviceTag;
        btnHeight = 40*m_deviceTag;
      }
    
    switch (count) {
        case 1:
      {
        frame = CGRectMake(self.frame.size.width/2 - btnWidth/2, BUTTONS_Y, btnWidth, btnHeight);
        break;
      }
        case 2:
        case 3:
      {
        float btnsSpace = (self.frame.size.width - btnWidth * count)/(count +1);
//        NSLog(@"%f",btnsSpace);
        frame = CGRectMake(btnsSpace * (index+1) + btnWidth * index, BUTTONS_Y, btnWidth, btnHeight);
//        NSLog(@"%@",NSStringFromCGRect(frame));
        break;
      }

    }
    
    return frame;
}


-(void)addButton:(int)index 
           frame:(CGRect)frame 
             img:(UIImage *)img 
            imgH:(UIImage *)imgH 
           title:(NSString *)title
{
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    
    btn.tag = index;
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:imgH forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:20*m_deviceTag];
    btn.titleLabel.shadowColor = [UIColor blackColor];
    btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    [btn release];
}

-(void)buttonClicked:(UIButton *)btn
{
    if (delegate && [delegate respondsToSelector:@selector(alertBtnClicked: btn:)]) {
        [delegate alertBtnClicked:self btn:btn];
    }
    
    if (isAutoRemove) {
        [self removeAlert];
    }
}

-(void)removeAlert
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAlertNil" object:nil];
    [self.superview removeFromSuperview];
}

-(int)getDevice
{
    
    NSString * ret = [[UIDevice currentDevice] model];
    NSRange range = [ret rangeOfString:@"iPad"];
    
    if (range.length) {
        //ipad
        return 2;
    }
    
    //iphone or ipod
    return 1;
}

-(void)dealloc
{
    [message release];
    [btnImgsArry release];
    [btnTitlesArry release];
    [super dealloc];
}

@end
