//
//  ReyImageView.m
//  ReyCore
//
//  Created by rey liang on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyImageView.h"

@implementation ReyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)showWithInterval:(float)interval
{
    self.hidden = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(hidesWhenStopped) userInfo:nil repeats:NO];
}


-(void)hidesWhenStopped
{
    self.hidden = YES;
}


@end
