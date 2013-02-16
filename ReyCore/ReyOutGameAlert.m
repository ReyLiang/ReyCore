//
//  ReyAutoDisconnAlert.m
//  GODClient
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyOutGameAlert.h"


@implementation ReyOutGameAlert

- (id)initWithFrame:(CGRect)frame 
           delegate:(id)aDelegate 
    backgroundImage:(UIImage *)image
            message:(NSString *)aMessage 
         buttonImgs:(NSArray *)imgsArray 
       buttonTitles:(NSArray *)titlesArray 
                tag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        UIImage * bgImg = [UIImage imageNamed:@"Rey_CA_bgimg"];
        
        m_alert = [[ReyAlert_outGame alloc] initWithFrame:CGRectMake(88, 67.5, 303.5, 175) 
                                                                               delegate:aDelegate 
                                                                        backgroundImage:bgImg 
                                                                                message:aMessage 
                                                                             buttonImgs:imgsArray 
                                                                           buttonTitles:titlesArray];
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
            || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) 
        {
            m_alert.center = CGPointMake(240, 160);
        }
        else {
            m_alert.center = CGPointMake(160, 240);        
        }
        m_alert.tag = tag;
        [self addSubview:m_alert];
    }
    return self;
}


-(void)dealloc
{
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
