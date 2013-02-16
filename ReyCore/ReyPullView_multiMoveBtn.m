//
//  ReyPullView_multiMoveBtn.m
//  ReyCore
//
//  Created by rey liang on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyPullView_multiMoveBtn.h"
#import "ReyAnimation.h"

@implementation ReyPullView_multiMoveBtn

@synthesize otherMoveBtn;


- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullViewFromDirection)aDirection 
         pulledView:(UIView *)aPullView
        moveBtnImgs:(NSArray *)imgsArry 
          showPoint:(CGPoint)aShowPoint
     otherShowPoint:(CGPoint)aOtherShowPoint
{
    otherShowPoint = aOtherShowPoint;
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

-(void)dealloc
{
    [otherMoveBtn release];
    [super dealloc];
}

-(void)initData:(NSArray *)imgsArry
{
    bgimgArry = [imgsArry retain];
    UIImage * img = [imgsArry objectAtIndex:0];
    UIImage * imgH = [imgsArry objectAtIndex:1];
    //初始化移动按钮
    moveBtn = [[ReyPullView_moveBtn alloc] initWithFrame:CGRectMake(showPoint.x, showPoint.y, 
                                                                    img.size.width, 
                                                                    img.size.height)
                                       pullFromDirection:(int)direction
                                                distance:EFFECTIVE_DISTANCE
                                          pulledViewSize:pulledView.frame.size];
    
    moveBtn.delegate = self;
    
    
    [moveBtn setBackgroundImage:img forState:UIControlStateNormal];
    [moveBtn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    [self addSubview:moveBtn];
    
    
    UIImage * otherimg = [imgsArry objectAtIndex:4];
    UIImage * otherimgH = [imgsArry objectAtIndex:5];
    //初始化移动按钮
    otherMoveBtn = [[ReyPullView_moveBtn alloc] initWithFrame:CGRectMake(otherShowPoint.x, otherShowPoint.y, 
                                                                    otherimg.size.width, 
                                                                    otherimg.size.height)
                                       pullFromDirection:(int)direction
                                                distance:EFFECTIVE_DISTANCE
                                          pulledViewSize:pulledView.frame.size];
    
    otherMoveBtn.delegate = self;
    
    
    [otherMoveBtn setBackgroundImage:otherimg forState:UIControlStateNormal];
    [otherMoveBtn setBackgroundImage:otherimgH forState:UIControlStateHighlighted];
    [self addSubview:otherMoveBtn];
    
    CGRect frameUnion = CGRectUnion(moveBtn.frame, otherMoveBtn.frame);

    btnWidth = frameUnion.size.width;
    btnHeight = frameUnion.size.height;
    
    showPoint = CGPointMake(frameUnion.origin.x, frameUnion.origin.y);
    
    [self initMaskAndPulledView];
    
//    //==test
//    moveBtn.backgroundColor = [UIColor blueColor];
//    otherMoveBtn.backgroundColor = [UIColor purpleColor];
    
}

-(void)changeMoveBtnBgimg:(bool)isShow
{
    UIImage * img;
    UIImage * imgH;
    UIImage * otherImg;
    UIImage * otherImgH;
    
    if (!isShow) {
        img = [bgimgArry objectAtIndex:2];
        imgH = [bgimgArry objectAtIndex:3];
        otherImg = [bgimgArry objectAtIndex:6];
        otherImgH = [bgimgArry objectAtIndex:7];
    }
    else
      {
        img = [bgimgArry objectAtIndex:0];
        imgH = [bgimgArry objectAtIndex:1];
        otherImg = [bgimgArry objectAtIndex:4];
        otherImgH = [bgimgArry objectAtIndex:5];
      }
    
    [moveBtn setBackgroundImage:img forState:UIControlStateNormal];
    [moveBtn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    [otherMoveBtn setBackgroundImage:otherImg forState:UIControlStateNormal];
    [otherMoveBtn setBackgroundImage:otherImgH forState:UIControlStateHighlighted];
}

#pragma mark -
#pragma mark ReyPullView_moveBtnDelegate

-(void)moveBtnMoved:(ReyPullView_moveBtn *)aMoveBtn
       distanceSize:(CGSize)distanceSize 
         isFinished:(bool)isFinished 
        stateChange:(bool)stateChange
{

    if (isFinished) {//touchEnd被触发
        
        if (stateChange) {//moveBtn将要改变
            [self addAnimationToPulledView:distanceSize];
            [self addAnimationToMoveBtn:aMoveBtn distance:distanceSize];
            [self changeMoveBtnBgimg:aMoveBtn.m_state];
            
            if (aMoveBtn == moveBtn) {
                [self addAnimationToMoveBtn:otherMoveBtn distance:distanceSize];
                [otherMoveBtn changeState];
            }
            else
              {
                [self addAnimationToMoveBtn:moveBtn distance:distanceSize];
                [moveBtn changeState];
              }
            
            
            if (aMoveBtn.m_state == ReyPullView_moveBtnStateHided) {
                if (delegate && [delegate respondsToSelector:@selector(PullViewShowed:)]) {
                    [delegate PullViewShowed:self];
                }
            }
            else
              {
                [self moveToBottom:YES];
              }
            
        }
        else
          {
            
            //状态为未改变时,由于hide先扩大self的frame,需要再缩小frame
            if (aMoveBtn.m_state == ReyPullView_moveBtnStateHided) {
                [self moveToBottom:NO];
                pulledView.hidden = YES;
            }
          }
        
        
        [self setMoveBtnFrame:aMoveBtn distanceSize:distanceSize isFinished:isFinished];
        pulledView.center = CGPointMake(pulledView_lastCenter.x + distanceSize.width,
                                        pulledView_lastCenter.y + distanceSize.height);
    }
    else
      {

        [self setMoveBtnFrame:aMoveBtn distanceSize:distanceSize isFinished:isFinished];
        pulledView.center = CGPointMake(pulledView.center.x + distanceSize.width,
                                        pulledView.center.y + distanceSize.height);
      }
    
}

-(void)moveBtnBegined:(ReyPullView_moveBtn *)aMoveBtn
{
    if (aMoveBtn == moveBtn) {
        otherMoveBtn.lastCenter = otherMoveBtn.center;
    }
    else
      {
        moveBtn.lastCenter = moveBtn.center;
      }
    [super moveBtnBegined:aMoveBtn];
}

-(void)setMoveBtnFrame:(ReyPullView_moveBtn *)aMoveBtn
          distanceSize:(CGSize)distanceSize 
            isFinished:(bool)isFinished 
{
    if (isFinished) {
        if (aMoveBtn == moveBtn) {//移动otherMoveBtn
            otherMoveBtn.center =  CGPointMake(otherMoveBtn.lastCenter.x + distanceSize.width,
                                               otherMoveBtn.lastCenter.y + distanceSize.height);
        }
        else
          {
            moveBtn.center =  CGPointMake(moveBtn.lastCenter.x + distanceSize.width,
                                               moveBtn.lastCenter.y + distanceSize.height);
          }
    }
    else
      {
        if (aMoveBtn == moveBtn) {//移动otherMoveBtn
            otherMoveBtn.center =  CGPointMake(otherMoveBtn.center.x + distanceSize.width,
                                               otherMoveBtn.center.y + distanceSize.height);
        }
        else
          {
            moveBtn.center =  CGPointMake(moveBtn.center.x + distanceSize.width,
                                          moveBtn.center.y + distanceSize.height);
          }
      }
}

#pragma mark -



-(void)addShakeAnimation
{
    [ReyAnimation SetPointMoveShakeAnimation:pulledView 
                                    delegate:nil 
                                         key:@"test" 
                                  shakeCount:4 
                                  isVertical:direction%2
                                    duration:0.1
                                  startPoint:pulledView.center 
                                    endPoint:pulledView.center];
    
    [ReyAnimation SetPointMoveShakeAnimation:moveBtn 
                                    delegate:self 
                                         key:@"test" 
                                  shakeCount:4 
                                  isVertical:direction%2
                                    duration:0.1
                                  startPoint:moveBtn.center 
                                    endPoint:moveBtn.center];
    
    [ReyAnimation SetPointMoveShakeAnimation:otherMoveBtn 
                                    delegate:nil 
                                         key:@"test" 
                                  shakeCount:4 
                                  isVertical:direction%2
                                    duration:0.1
                                  startPoint:otherMoveBtn.center 
                                    endPoint:otherMoveBtn.center];
}

@end
