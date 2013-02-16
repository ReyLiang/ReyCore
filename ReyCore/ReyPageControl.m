//
//  ReyPageControl.m
//  MenuDemoTest
//
//  Created by I Mac on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReyPageControl.h"


@implementation ReyPageControl

@synthesize activeImage;
@synthesize inactiveImage;


- (id)initWithFrame:(CGRect)frame
          activeImg:(UIImage *)activeImg
        inactiveImg:(UIImage *)inactiveImg
                gap:(float)aGap
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.userInteractionEnabled = NO;
		activeImage = [activeImg retain];
		inactiveImage = [inactiveImg retain];
		
		dotsSize = CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame));
        
        gap = aGap;
        
		
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
          activeImg:(UIImage *)activeImg
        inactiveImg:(UIImage *)inactiveImg
{
    
    return [self initWithFrame:frame activeImg:activeImage inactiveImg:inactiveImage gap:0];
}


-(void) updateDots
{
//    float x = 0 ;
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
        {
            dot.image = activeImage;
        }
        else
        {
            dot.image = inactiveImage;
        }

        dot.frame = CGRectMake(CGRectGetMinX(dot.frame), CGRectGetMinY(dot.frame), dotsSize.width, dotsSize.height);

		
    }

}

-(void)layoutSubviews
{
    if (gap) {
        float x = 0 ;
        int count = [self.subviews count];
        float paddingLeft = (self.frame.size.width - count * dotsSize.width - (count - 1)*gap)/2;
        for (int i = 0; i < count; i++)
        {
            UIImageView* dot = [self.subviews objectAtIndex:i];
            
            x = paddingLeft + (dotsSize.width + gap) * i;
            dot.frame = CGRectMake(x , CGRectGetMinY(dot.frame), dotsSize.width, dotsSize.height);
            
        }
        
        [self updateDots];
    }
    else
    {
        [super layoutSubviews];
    }
    
}


-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
-(void)dealloc
{
	[activeImage release];
	[inactiveImage release];
    [super dealloc];
}



@end
