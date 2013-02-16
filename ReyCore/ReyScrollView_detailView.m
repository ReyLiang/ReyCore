//
//  ReyScrollView_detailView.m
//  ReyCore
//
//  Created by Rey on 12-11-14.
//
//

#import "ReyScrollView_detailView.h"


@implementation ReyScrollView_detailView

@synthesize m_superScrollView;

- (id)initWithFrame:(CGRect)frame scrollView:(ReyScrollView *)scrollView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_superScrollView = scrollView;
        
        
    }
    return self;
}

-(void)dealloc
{
    
    [super dealloc];
}



-(void )touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(<#NSString *format#>)
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"scrSubViewsTouch" object:nil];
	
//	NSLog(@"touchesBegan,event'count = %d",[[event touchesForView:self] count]);
	if ([touches count]) {
		for (UITouch * touch in touches) {
			if ([touch tapCount] == 2) {
				CGPoint myLocation = [touch locationInView:self];
				
				[m_superScrollView RestoreZooming:myLocation];
			}
//            else if ([touch tapCount] == 1)
//            {
//                isSingleTap = YES;
//            }
		}
	}
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isSingleTap = NO;
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isSingleTap = NO;
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (isSingleTap) {
//        NSLog(@"@@@@@@@@@@@@@");
//    }
//
//    
//}


@end
