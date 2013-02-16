//
//  ReyProcess.m
//  ReyProcess
//
//  Created by I Mac on 11-3-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReyProcess.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReyProcess

@synthesize maskLayer;
@synthesize totalCount;

//364 × 35
- (id)initWithFrame:(CGRect)frame nullImg:(UIImage *)nullImg fullImg:(UIImage *)fullImg
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		progress = 0;
        currectIndex = 0;
		
		//进度条背景,不变化
		
		UIImageView * nullView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		nullView.image = nullImg;
		[self addSubview:nullView];
		[nullView release];
		
		

		
		
		
		//已加载进度条,变化
		
		//已加载进度条的遮盖
		maskLayer = [[CALayer layer]retain];
		maskLayer.contents = (id)fullImg.CGImage;
		maskLayer.frame = [self getMastLayerFrame];
		
		
		
		
		UIImageView * fullView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		fullView.image = fullImg;
		fullView.layer.mask = maskLayer;		
		
		[self addSubview:fullView];
		[fullView release];
		
		
		
    }
    return self;
}
-(float)progress
{
	return progress;
}
-(void)setProgress:(float)number
{
    if (number == 0) {
        currectIndex = 0;
    }
	progress = number;
	[self updateProgressView];
}

-(CGRect)getMastLayerFrame
{
	if (progress>=1) {
		progress = 1;
	}
	return CGRectMake(0, 0, self.frame.size.width*progress, self.frame.size.height);
}
-(void)updateProgressView
{
	[CATransaction begin];
	[CATransaction setAnimationDuration:0.7];
	
	maskLayer.frame = [self getMastLayerFrame];
	
	[CATransaction commit];
}

-(void)addProgress
{
    if (currectIndex == totalCount) {
        return;
    }
    currectIndex += 1;
    [self setProgress:(currectIndex*1.0)/(totalCount*1.0)];
    //NSLog(@"@@@@ %f",progress);
}

-(void)delProgress
{
    if (currectIndex == 0) {
        return;
    }
    currectIndex -= 1;
    [self setProgress:(currectIndex*1.0)/(totalCount*1.0)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[maskLayer release];
    [super dealloc];
}


@end
