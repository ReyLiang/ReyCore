//
//  ReyWebView.m
//  ReyHTML5View
//
//  Created by rey liang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyWebView.h"

@implementation ReyWebView

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
    [self stopLoading];
    [super dealloc];
}

@end
