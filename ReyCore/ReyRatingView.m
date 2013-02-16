//
//  RatingViewController.m
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ReyRatingView.h"

@implementation ReyRatingView

@synthesize s1, s2, s3, s4, s5;



//TODO: imageNameArry: 第一图片是空,第二个一半,第三个是实心
-(id )initWithFrame:(CGRect)frame 
      displayRating:(float)rate 
        andDelegate:(id)delegate 
      imageNameArry:(NSArray *)imageNameArry 
           canMoved:(bool)canMoved
{
	if ((self = [super initWithFrame:frame])) {
        
        m_canMoved = canMoved;
		
		//self.backgroundColor = [UIColor blackColor];
		[self setImagesDeselected:[imageNameArry objectAtIndex:0] 
                   partlySelected:[imageNameArry objectAtIndex:1] 
                     fullSelected:[imageNameArry objectAtIndex:2]  
                      andDelegate:delegate];
		[self displayRating:rate];
		
		
	}
	return self;
			
}


- (void)dealloc {
	[s1 release];
	[s2 release];
	[s3 release];
	[s4 release];
	[s5 release];
    [super dealloc];
}

-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage
			   andDelegate:(id<ReyRatingViewDelegate>)d {
	unselectedImage = [UIImage imageNamed:deselectedImage];
	partlySelectedImage = halfSelectedImage == nil ? unselectedImage : [UIImage imageNamed:halfSelectedImage];
	fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
	viewDelegate = d;
	
	height=0.0; width=0.0;
	if (height < [fullySelectedImage size].height) {
		height = [fullySelectedImage size].height;
	}
	if (height < [partlySelectedImage size].height) {
		height = [partlySelectedImage size].height;
	}
	if (height < [unselectedImage size].height) {
		height = [unselectedImage size].height;
	}
	if (width < [fullySelectedImage size].width) {
		width = [fullySelectedImage size].width;
	}
	if (width < [partlySelectedImage size].width) {
		width = [partlySelectedImage size].width;
	}
	if (width < [unselectedImage size].width) {
		width = [unselectedImage size].width;
	}
	
	starRating = 0;
	lastRating = 0;
	s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	s5 = [[UIImageView alloc] initWithImage:unselectedImage];
	
	[s1 setFrame:CGRectMake(0,         0, width, height)];
	[s2 setFrame:CGRectMake(width,     0, width, height)];
	[s3 setFrame:CGRectMake(2 * width, 0, width, height)];
	[s4 setFrame:CGRectMake(3 * width, 0, width, height)];
	[s5 setFrame:CGRectMake(4 * width, 0, width, height)];
	
	
	
	[s1 setUserInteractionEnabled:NO];
	[s2 setUserInteractionEnabled:NO];
	[s3 setUserInteractionEnabled:NO];
	[s4 setUserInteractionEnabled:NO];
	[s5 setUserInteractionEnabled:NO];
	
	[self addSubview:s1];
	[self addSubview:s2];
	[self addSubview:s3];
	[self addSubview:s4];
	[self addSubview:s5];
	
	CGRect frame = [self frame];
	frame.size.width = width * 7;
	frame.size.height = height;
	[self setFrame:frame];
}

-(void)displayRating:(float)rating {
	[s1 setImage:unselectedImage];
	[s2 setImage:unselectedImage];
	[s3 setImage:unselectedImage];
	[s4 setImage:unselectedImage];
	[s5 setImage:unselectedImage];
	
	float score = 0;//记录评级分数
	
	if (rating > 0.15) {
		[s1 setImage:partlySelectedImage];
		score +=0.5;
	}
	if (rating > 0.5) {
		[s1 setImage:fullySelectedImage];
		score +=0.5;
	}
	if (rating > 1) {
		[s2 setImage:partlySelectedImage];
		score +=0.5;
	}
	if (rating > 1.5) {
		[s2 setImage:fullySelectedImage];
		score +=0.5;
	}
	if (rating > 2) {
		[s3 setImage:partlySelectedImage];
		score +=0.5;
	}
	if (rating > 2.5) {
		[s3 setImage:fullySelectedImage];
		score +=0.5;
	}
	if (rating > 3) {
		[s4 setImage:partlySelectedImage];
		score +=0.5;
	}
	if (rating > 3.5) {
		[s4 setImage:fullySelectedImage];
		score +=0.5;
	}
	if (rating > 4) {
		[s5 setImage:partlySelectedImage];
		score +=0.5;
	}
	if (rating > 4.5) {
		[s5 setImage:fullySelectedImage];
		score +=0.5;
	}
	
	starRating = rating;
	lastRating = rating;
	if (viewDelegate && [viewDelegate respondsToSelector:@selector(ratingChanged:)]) {
		[viewDelegate ratingChanged:score];
	}
	
}

-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
	[self checkRating:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
    [self checkRating:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self checkRating:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

-(void)checkRating:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_canMoved) {
        CGPoint pt = [[touches anyObject] locationInView:self];
        float newRating = (float) (pt.x / width) ;//+ 0.5;
        if (newRating < 0 || newRating > 5)
            return;
        
        if (newRating != lastRating)
            [self displayRating:newRating];
    }
}

-(float)rating {
	return starRating;
}

@end
