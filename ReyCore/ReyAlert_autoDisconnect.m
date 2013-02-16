//
//  ReyAlert_autoDisconnect.m
//  GODClient
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyAlert_autoDisconnect.h"
#import "ReyError.h"



@implementation ReyAlert_autoDisconnect


@synthesize timeOutLabel;
@synthesize timeOutTimer;

#define TIMEOUT 60



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
        
        UIButton * btn = [[[UIButton alloc] init] autorelease];
        btn.tag = 1;
        if (delegate && [delegate respondsToSelector:@selector(alertBtnClicked: btn:)]) {
            [delegate alertBtnClicked:self btn:btn];
        }
        if (timeOutTimer) {
            [timeOutTimer invalidate];
            [timeOutTimer release];
            timeOutTimer = NULL;
        }
        [self.superview removeFromSuperview];

    }
    
    timeOutLabel.text = [NSString stringWithFormat:@"%@%dS",[ReyError getLocalize:@"AUTODISCONNECT SUBTITLE"],
                         timeCount];
}

-(void)buttonClicked:(UIButton *)btn
{
    
    [super buttonClicked:btn];
    
}

-(void)dealloc
{
    if (timeOutTimer) {
        [timeOutTimer invalidate];
        [timeOutTimer release];
    }
    [timeOutLabel release];
    [super dealloc];
}

@end
