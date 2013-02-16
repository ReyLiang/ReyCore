//
//  ReyAlert_autoDisconnect.m
//  GODClient
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyAlert_outGame.h"
#import "ReyError.h"



@implementation ReyAlert_outGame


@synthesize timeOutLabel;
@synthesize timeOutTimer;
@synthesize m_outGameBtn;

#define TIMEOUT 5



//初始化内容
-(void)initMessage
{
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 30)];
    
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    messageLabel.text = message;
    messageLabel.textColor = [UIColor whiteColor];
    
    messageLabel.shadowColor = [UIColor blackColor];
    messageLabel.shadowOffset = CGSizeMake(0, 1);
    
    [self addSubview:messageLabel];
    [messageLabel release];
    
    timeCount = TIMEOUT;
    
    timeOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, self.frame.size.width, 30)];
    
    timeOutLabel.backgroundColor = [UIColor clearColor];
    timeOutLabel.textAlignment = UITextAlignmentCenter;
    timeOutLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    timeOutLabel.font = [UIFont systemFontOfSize:30];
    
    timeOutLabel.text = [NSString stringWithFormat:@"%@%dS",[ReyError getLocalize:@"AUTODISCONNECT SUBTITLE"],timeCount];
    timeOutLabel.textColor = [UIColor redColor];
    
    timeOutLabel.shadowColor = [UIColor blackColor];
    timeOutLabel.shadowOffset = CGSizeMake(0, 1);
    
    [self addSubview:timeOutLabel];
    
    timeOutTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOutUpdate:) userInfo:nil repeats:YES] retain];
    
    
}

-(void)timeOutUpdate:(NSTimer *)timer
{
    
    timeCount--;
    if (timeCount == 0) {
        
        if (timeOutTimer) {
            [timeOutTimer invalidate];
            [timeOutTimer release];
            timeOutTimer = NULL;
        }
        
        m_outGameBtn.hidden = NO;
        timeOutLabel.hidden = YES;

    }
    
    timeOutLabel.text = [NSString stringWithFormat:@"%@%dS",[ReyError getLocalize:@"AUTODISCONNECT SUBTITLE"],
                         timeCount];
}

-(void)buttonClicked:(UIButton *)btn
{
    if (timeOutTimer) {
        [timeOutTimer invalidate];
        [timeOutTimer release];
        timeOutTimer = NULL;
    }
    
    [super buttonClicked:btn];
}

-(void)dealloc
{
    [m_outGameBtn release];
    if (timeOutTimer) {
        [timeOutTimer invalidate];
        [timeOutTimer release];
    }
    [timeOutLabel release];
    [super dealloc];
}

-(void)addButton:(int)index 
           frame:(CGRect)frame 
             img:(UIImage *)img 
            imgH:(UIImage *)imgH 
           title:(NSString *)title
{
    m_outGameBtn = [[UIButton alloc] initWithFrame:frame];
    
    m_outGameBtn.tag = index;
    m_outGameBtn.hidden = YES;
    
    [m_outGameBtn setBackgroundImage:img forState:UIControlStateNormal];
    [m_outGameBtn setBackgroundImage:imgH forState:UIControlStateNormal];
    [m_outGameBtn setTitle:title forState:UIControlStateNormal];
    
    m_outGameBtn.titleLabel.textColor = [UIColor whiteColor];
    m_outGameBtn.titleLabel.shadowColor = [UIColor blackColor];
    m_outGameBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    [m_outGameBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:m_outGameBtn];
    
}

@end
