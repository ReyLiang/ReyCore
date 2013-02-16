//
//  ReyLabel_rocker.m
//  ReyCodeXML
//
//  Created by 慧彬 梁 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyLabel_rocker.h"
#import <QuartzCore/QuartzCore.h>
#import "ReyAnimation.h"
#import "ReyCommon.h"

@interface ReyLabel_rocker()
-(void)initData;
@end

@implementation ReyLabel_rocker

@synthesize m_message,m_label;

- (id)initWithFrame:(CGRect)frame message:(NSString *)msg fontSize:(float)fontsize duration:(float)duration
{
    [self initWithFrame:frame message:msg fontSize:fontsize];
    
    [self startWithDuration:duration];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame message:(NSString *)msg fontSize:(float)fontsize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_message = [msg retain];
        m_fontSize = fontsize;
        
        m_duration = 1.0;
        m_animStarted = false;
        
        CALayer * maskLayer = [CALayer layer];
        maskLayer.contents = (id)[UIImage imageNamed:@"ReyMask"].CGImage;
        maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        
        self.layer.mask = maskLayer;
        
        [self initData];
    }
    return self;
}

-(void)dealloc
{
    [self stop];
    [m_message release];
    [m_label release];
    [super dealloc];
}

-(void)initData
{
    int eng = [ReyCommon getEnglishCharacterLength:m_message];
    float width = ([m_message length] - eng)*1.0*m_fontSize + eng*m_fontSize/2.0;
    
    if (self.frame.size.width < width) {
        m_animCanStart = true;
    }
    else {
        m_animCanStart = false;
        width = self.frame.size.width;
    }
    
    m_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    m_label.backgroundColor = [UIColor clearColor];
    m_label.adjustsFontSizeToFitWidth = YES;
    m_label.textAlignment = UITextAlignmentCenter;
    m_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    m_label.font = [UIFont systemFontOfSize:m_fontSize];
    m_label.textColor = [UIColor blackColor];
    m_label.text = m_message;
    
    
    [m_label setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]];
    [m_label setShadowOffset:CGSizeMake(0, 1)];
    
    [self addSubview:m_label];
}


-(void)setM_message:(NSString *)message
{
    [m_message release];
    m_message = [message retain];
    
    [m_label.layer removeAllAnimations];
    
    float width = [m_message length]*1.0*m_fontSize;
    m_label.frame = CGRectMake(0, 0, width, self.frame.size.height);
    m_label.text = message;
    
}

-(void)startWithDuration:(float)duration
{
    if (!m_animCanStart) {
        return;
    }
    m_duration = duration*[m_message length];
    m_animStarted = true;

    m_currentTag = ReyLabel_Rock_Left;
    [ReyAnimation SetPointMoveBasicAnimation:m_label 
                                    delegate:self 
                                         key:@"ReyLabel_rocker_left" 
                                    duration:m_duration 
                                  startPoint:CGPointMake(m_label.center.x, m_label.center.y)
                                    endPoint:CGPointMake(self.frame.size.width-m_label.frame.size.width+m_label.center.x, m_label.center.y)];
}

-(void)stop
{
    if (!m_animCanStart) {
        return;
    }
    [m_label.layer removeAllAnimations];
    m_animStarted = false;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    switch (m_currentTag) {
        case ReyLabel_Rock_Left:
        {
            m_currentTag = ReyLabel_Rock_Right;
            
//            [m_label.layer removeAllAnimations];
            [ReyAnimation SetPointMoveBasicAnimation:m_label 
                                            delegate:self 
                                                 key:@"ReyLabel_rocker_left" 
                                            duration:m_duration 
                                          startPoint:CGPointMake(self.frame.size.width-m_label.frame.size.width+m_label.center.x, m_label.center.y)
                                            endPoint:CGPointMake(m_label.center.x, m_label.center.y)];
            
            break;
        }
        case ReyLabel_Rock_Right:
        {
            m_currentTag = ReyLabel_Rock_Left;
//            [m_label.layer removeAllAnimations];
            [ReyAnimation SetPointMoveBasicAnimation:m_label 
                                            delegate:self 
                                                 key:@"ReyLabel_rocker_left" 
                                            duration:m_duration 
                                          startPoint:CGPointMake(m_label.center.x, m_label.center.y)
                                            endPoint:CGPointMake(self.frame.size.width-m_label.frame.size.width+m_label.center.x, m_label.center.y)];
            
            break;
        }
    }
}


@end
