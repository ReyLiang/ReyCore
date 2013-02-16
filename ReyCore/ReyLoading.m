/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyLoading.m	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/13 
 
 Description: 
 
 加载等待界面
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import "ReyLoading.h"

@implementation ReyLoading

@synthesize activityView;
@synthesize m_bgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //50%黑的背景
        m_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_bgView.backgroundColor = [UIColor blackColor];
        m_bgView.alpha = 0.5;
        [self addSubview:m_bgView];
        
        //等待图标
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        activityView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:activityView];
        
    }
    return self;
}

//开始动画
-(void)startActivityView
{
    [activityView startAnimating];
}

//结束动画
-(void)stopActivityView
{
    [activityView stopAnimating];
}

-(void)dealloc
{
    [m_bgView release];
    [activityView release];
    [super dealloc];
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    activityView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
    m_bgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

@end
