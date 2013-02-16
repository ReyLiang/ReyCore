//
//  ReyPullView_customMoveBtn.m
//  ReyCore
//
//  Created by rey liang on 12-1-31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyPullView_customMoveBtn.h"

@implementation ReyPullView_customMoveBtn


- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullViewFromDirection)aDirection 
         pulledView:(UIView *)aPullView
        moveBtnImgs:(NSArray *)imgsArry 
          showPoint:(CGPoint)aShowPoint
     moveBtnOrigin:(CGPoint)aMoveBtnOrigin
{
    moveBtnOrigin = aMoveBtnOrigin;
    self = [super initWithFrame:frame 
              pullFromDirection:aDirection 
                     pulledView:aPullView 
                    moveBtnImgs:imgsArry 
                      showPoint:aShowPoint];
    if (self) {
        // Initialization code
        
    }
    
    return self;
}



-(void)initData:(NSArray *)imgsArry
{
    bgimgArry = [imgsArry retain];
    UIImage * img = [bgimgArry objectAtIndex:0];
    UIImage * imgH = [bgimgArry objectAtIndex:1];
    //初始化移动按钮
    moveBtn = [[ReyPullView_moveBtn alloc] initWithFrame:CGRectMake(moveBtnOrigin.x, moveBtnOrigin.y, 
                                                                    img.size.width, 
                                                                    img.size.height)
                                       pullFromDirection:(int)direction
                                                distance:EFFECTIVE_DISTANCE
                                          pulledViewSize:pulledView.frame.size];
    
    moveBtn.delegate = self;
    
    [moveBtn setBackgroundImage:img forState:UIControlStateNormal];
    [moveBtn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    [self addSubview:moveBtn];
    
    
    btnWidth = moveBtn.frame.size.width;
    btnHeight = moveBtn.frame.size.height;
    
    [self initMaskAndPulledView];
    
}
    
    

@end
