/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyLabel_shadow.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/11/24 
 
 Description: 
 
 UILablel.带白色阴影.
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 
#import "ReyLabel_shadow.h"

@implementation ReyLabel_shadow


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.backgroundColor = [UIColor clearColor];
        [self setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]];
        [self setShadowOffset:CGSizeMake(0, 1)];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.backgroundColor = [UIColor clearColor];
        [self setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]];
        [self setShadowOffset:CGSizeMake(0, 1)];
    }
    
    return self;
}



@end
