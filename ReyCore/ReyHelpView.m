//
//  ReyHelpView.m
//  ReyCore
//
//  Created by rey liang on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyHelpView.h"
#import "ReyCommon.h"

@implementation ReyHelpView

@synthesize scrollView;
@synthesize jumpBtn;
@synthesize gameID;

#define BTNS_JUMP_IMG @"ReyHelp_jump"
#define BTNS_FINISHED_IMG @"ReyHelp_finised"
#define BTNS_NEVERSHOW_IMG @"ReyHelp_neverShow"
#define BTNS_NEVERSHOW_IMGH @"ReyHelp_neverShowH"


- (id)initWithFrame:(CGRect)frame 
         isVertical:(bool)isVertical 
       helpsImgArry:(NSArray *)imgsArry 
         isUserShow:(bool)isUserShow 
             gameID:(int)agameID
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        gameID = agameID;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        scrollView.scrollEnabled = YES;
        scrollView.delegate = self;
        
        if (isVertical) {
            scrollView.contentSize = CGSizeMake(frame.size.width , frame.size.height * [imgsArry count]);
            for (int i = 0; i < [imgsArry count] ; i++) {
                UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                      i*scrollView.frame.size.height, 
                                                                                      scrollView.frame.size.width, 
                                                                                      scrollView.frame.size.height)];
                imgView.image = [imgsArry objectAtIndex:i];
                [scrollView addSubview:imgView];
                [imgView release];
            }
        }
        else
          {
            scrollView.contentSize = CGSizeMake(frame.size.width * [imgsArry count] , frame.size.height);
            for (int i = 0; i < [imgsArry count] ; i++) {
                UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*scrollView.frame.size.width,
                                                                                      0, 
                                                                                      scrollView.frame.size.width, 
                                                                                      scrollView.frame.size.height)];
                imgView.image = [imgsArry objectAtIndex:i];
                [scrollView addSubview:imgView];
                [imgView release];
            }
          }
        
        [self addSubview:scrollView];
        
        
        //用户主动调用,无需加载不再显示按钮
        if (!isUserShow) {
            isNeverShow = NO;
            UIImage * showImg = [UIImage imageNamed:BTNS_NEVERSHOW_IMG];
            UIImage * showImgH = [UIImage imageNamed:BTNS_NEVERSHOW_IMGH];
            CGPoint point = [ReyCommon getShowPoint:gameID];
            UIButton * showBtn = [[UIButton alloc] initWithFrame:CGRectMake(point.x,point.y,
                                                                            showImg.size.width * [ReyCommon getDevice],
                                                                            showImg.size.height * [ReyCommon getDevice])];
            [showBtn setBackgroundImage:showImg forState:UIControlStateNormal];
            [showBtn setBackgroundImage:showImgH forState:UIControlStateHighlighted];
            [showBtn addTarget:self action:@selector(neverShow:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:showBtn];
            [showBtn release];
        }
        

        
        
        UIImage * jumpImg = [UIImage imageNamed:BTNS_JUMP_IMG];
        CGPoint jumpPoint = [ReyCommon getJumpPoint:gameID];
        
        jumpBtn = [[UIButton alloc] initWithFrame:CGRectMake(jumpPoint.x,
                                                             jumpPoint.y,
                                                             jumpImg.size.width * [ReyCommon getDevice],
                                                             jumpImg.size.height * [ReyCommon getDevice])];
        [jumpBtn setBackgroundImage:jumpImg forState:UIControlStateNormal];
        [jumpBtn addTarget:self action:@selector(jumpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jumpBtn];
        
    }
    
    return self;
}

-(void)dealloc
{
    [scrollView release];
    [jumpBtn release];
    [super dealloc];
}
//跳过
-(void)jumpBtnClick:(UIButton *)btn
{
    if (isNeverShow) {
        [ReyCommon setHelpInfoShow:gameID];
    }
    
    [self removeFromSuperview];
}
//不再显示
-(void)neverShow:(UIButton *)btn
{
    UIImage * img = [btn backgroundImageForState:UIControlStateNormal];
    UIImage * imgH = [btn backgroundImageForState:UIControlStateHighlighted];
    [btn setBackgroundImage:imgH forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    isNeverShow = !isNeverShow;
}
//翻页
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.size.width) {
        [jumpBtn setBackgroundImage:[UIImage imageNamed:BTNS_FINISHED_IMG] forState:UIControlStateNormal];
    }
    
}

@end
