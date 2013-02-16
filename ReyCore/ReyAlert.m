//
//  ReyAlert.m
//  ReyCore
//
//  Created by rey liang on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyAlert.h"


@implementation ReyAlert
@synthesize m_alert;

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
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        UIImage * bgImg = [UIImage imageNamed:@"Rey_CA_bgimg"];
        
        m_alert = [[ReyCustomAlert alloc] initWithFrame:CGRectMake(88, 67.5, 303.5, 175) 
                                                             delegate:aDelegate 
                                                      backgroundImage:bgImg 
                                                              message:aMessage 
                                                           buttonImgs:imgsArray 
                                                         buttonTitles:titlesArray];
        if ( UIDeviceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]) ) {
            m_alert.center = CGPointMake(240, 160);        }
        else {
            m_alert.center = CGPointMake(160, 240);
        }
        m_alert.tag = tag;
        [self addSubview:m_alert];

    }
    return self;
}

-(void)SetAutoRemoveMode:(bool)isAutoRemove
{
    m_alert.isAutoRemove = isAutoRemove;
}

-(void)dealloc
{
    [m_alert release];
    [super dealloc];
}

@end
