//
//  ReyPullView.m
//  PopupTest
//
//  Created by rey liang on 12-1-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyPullView.h"
#import "ReyAnimation.h"

@interface ReyPullView()

-(void)initData:(NSArray *)imgsArry;

-(void)addAnimationToPulledView:(CGSize)distanceSize;

-(void)addAnimationToMoveBtn:(ReyPullView_moveBtn *)aMoveBtn distance:(CGSize)distanceSize;

-(void)initMaskAndPulledView;

-(void)changeMoveBtnBgimg:(bool)isShow;

-(void)moveToBottom:(bool)stateChanged;

-(void)moveToTop;

-(void)addShakeAnimation;

@end

@implementation ReyPullView

@synthesize pulledView,moveBtn;
@synthesize delegate;
@synthesize bgimgArry;
@synthesize isShowBgColor;





- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullViewFromDirection)aDirection 
         pulledView:(UIView *)aPullView
        moveBtnImgs:(NSArray *)imgsArry 
          showPoint:(CGPoint)aShowPoint
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        isShowBgColor = NO;
        
        self.multipleTouchEnabled = YES;
        
        pulledView = [aPullView retain];
        pulledView.hidden = YES;
        [self addSubview:pulledView];
        
        
        direction = aDirection;
        
        showPoint = aShowPoint;
        
        [self initData:imgsArry];
    }
    return self;
}

-(void)dealloc
{
    [bgimgArry release];
    [pulledView release];
    [moveBtn release];
    [super dealloc];
}


-(void)initData:(NSArray *)imgsArry
{
    bgimgArry = [imgsArry retain];
    UIImage * img = [bgimgArry objectAtIndex:0];
    UIImage * imgH = [bgimgArry objectAtIndex:1];
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
    
    
    btnWidth = moveBtn.frame.size.width;
    btnHeight = moveBtn.frame.size.height;
    
    [self initMaskAndPulledView];
    
    
    
    
}

-(void)changeMoveBtnBgimg:(bool)isShow
{
    UIImage * img;
    UIImage * imgH;
    if (!isShow) {
        img = [bgimgArry objectAtIndex:2];
        imgH = [bgimgArry objectAtIndex:3];
    }
    else
      {
        img = [bgimgArry objectAtIndex:0];
        imgH = [bgimgArry objectAtIndex:1];
      }
    
    [moveBtn setBackgroundImage:img forState:UIControlStateNormal];
    [moveBtn setBackgroundImage:imgH forState:UIControlStateHighlighted];
}

-(void)initMaskAndPulledView
{
    CALayer * maskLayer = [CALayer layer];
    
    NSBundle * bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"ReyCoreBundle" ofType:@"bundle"]];
    UIImage * maskImage = [UIImage imageWithContentsOfFile:[bundle pathForResource:MASK_IMAGENAME ofType:@"png"]];
    maskLayer.contents = (id)maskImage.CGImage;
    
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
    

    float selfWidth = self.frame.size.width;
    float selfHeight = self.frame.size.height;
    
    CGRect maskFrame, pulledFrame;
    
    
    switch (direction) {
        case ReyPullViewFromDirectionLeft:
      {
        maskFrame = CGRectMake(showPoint.x, 
                               showPoint.y, 
                               selfWidth - showPoint.x , 
                               selfHeight -showPoint.y );
        
        pulledFrame = CGRectMake( showPoint.x- pulledView.frame.size.width,
                                 showPoint.y, 
                                 pulledView.frame.size.width, 
                                 pulledView.frame.size.height);
        break;
      }  
        case ReyPullViewFromDirectionUp:
      {
        maskFrame = CGRectMake(showPoint.x, 
                               showPoint.y,
                               selfWidth - showPoint.x ,
                               selfHeight -showPoint.y );
        
        pulledFrame = CGRectMake(showPoint.x,
                                 showPoint.y - pulledView.frame.size.height, 
                                 pulledView.frame.size.width, 
                                 pulledView.frame.size.height);
        break;
      }  
        case ReyPullViewFromDirectionRight:
      {
        maskFrame = CGRectMake(0, 
                               showPoint.y, 
                               showPoint.x + btnWidth,
                               selfHeight -showPoint.y);
        pulledFrame = CGRectMake(showPoint.x + btnWidth,
                                 showPoint.y, 
                                 pulledView.frame.size.width, 
                                 pulledView.frame.size.height);
        
        
        break;
      }  
        case ReyPullViewFromDirectionDown:
      {
        maskFrame = CGRectMake(showPoint.x, 0, selfWidth - showPoint.x , btnHeight + showPoint.y );
        pulledFrame = CGRectMake(showPoint.x,
                                 showPoint.y + btnHeight, 
                                 pulledView.frame.size.width, 
                                 pulledView.frame.size.height);
        break;
      }  
    }
    
    maskLayer.frame = maskFrame;
    
    pulledView.frame = pulledFrame;
}

//快速显示或隐藏pullView
-(void)QiuckShowOrHide
{
    [moveBtn moveBtnCliecked];
}

#pragma mark -
#pragma mark ReyPullView_moveBtnDelegate

-(void)moveBtnMoved:(ReyPullView_moveBtn *)aMoveBtn
       distanceSize:(CGSize)distanceSize 
         isFinished:(bool)isFinished 
        stateChange:(bool)stateChange
{
//    //NSLog(@"distanceSize %@",NSStringFromCGSize(distanceSize));
    //NSLog(@"%d",isFinished);

    if (isFinished) {//touchEnd被触发
        
        if (stateChange) {//moveBtn将要改变
            [self addAnimationToPulledView:distanceSize];
            [self addAnimationToMoveBtn:aMoveBtn distance:distanceSize];
            [self changeMoveBtnBgimg:aMoveBtn.m_state];
            
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
        else //moveBtn状态不改变
          {

            //状态为未改变时,由于hide先扩大self的frame,需要再缩小frame
            if (aMoveBtn.m_state == ReyPullView_moveBtnStateHided) {
                pulledView.hidden = YES;
                [self moveToBottom:NO];

            }
            

          }
        
        
        
        pulledView.center = CGPointMake(pulledView_lastCenter.x + distanceSize.width,
                                        pulledView_lastCenter.y + distanceSize.height);
    }
    else
      {

        pulledView.center = CGPointMake(pulledView.center.x + distanceSize.width,
                                        pulledView.center.y + distanceSize.height);
      }
    
}


-(void)moveBtnBegined:(ReyPullView_moveBtn *)aMoveBtn
{
    if (aMoveBtn.m_state == ReyPullView_moveBtnStateHided) {
        pulledView.hidden = NO;
        [self moveToTop];
    }
    
    pulledView_lastCenter = pulledView.center;
}

#pragma mark -




-(void)addAnimationToPulledView:(CGSize)distanceSize
{
    float duration;
    
    //x轴方向的移动
    if (distanceSize.width) {
        duration = fabs(ANIMATION_DURATION * (1- fabs(pulledView.center.x - pulledView_lastCenter.x)/pulledView.frame.size.width));
    }
    else      //y轴方向的移动
      {
        duration =fabs(ANIMATION_DURATION * (1- fabs(pulledView.center.y - pulledView_lastCenter.y)/pulledView.frame.size.height));
      }
    [ReyAnimation SetPointMoveBasicAnimation:pulledView 
                                    delegate:nil 
                                         key:@"test" 
                                    duration:duration 
                                  startPoint:pulledView.center 
                                    endPoint:CGPointMake(pulledView_lastCenter.x + distanceSize.width , pulledView_lastCenter.y + distanceSize.height)];
    
}

-(void)addAnimationToMoveBtn:(ReyPullView_moveBtn *)aMoveBtn distance:(CGSize)distanceSize
{
    float duration;
    
    //x轴方向的移动
    if (distanceSize.width) {
        duration = fabs(ANIMATION_DURATION * (1- fabs(aMoveBtn.center.x - aMoveBtn.lastCenter.x)/pulledView.frame.size.width));
    }
    else      //y轴方向的移动
      {
        duration =fabs(ANIMATION_DURATION * (1- fabs(aMoveBtn.center.y - aMoveBtn.lastCenter.y)/pulledView.frame.size.height));
      }
    [ReyAnimation SetPointMoveBasicAnimation:aMoveBtn 
                                    delegate:self 
                                         key:@"test" 
                                    duration:duration 
                                  startPoint:aMoveBtn.center 
                                    endPoint:CGPointMake(aMoveBtn.lastCenter.x + distanceSize.width , aMoveBtn.lastCenter.y + distanceSize.height)];
    
    
}

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
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if (isShake) {
            isShake = NO;
        }
        else
          {
            if (moveBtn.m_state == ReyPullView_moveBtnStateHided) {
                pulledView.hidden = YES;
            }
            
            [self addShakeAnimation];

            isShake = YES;
          }
        
    }
}



-(void)moveToTop
{

    //把pullview移到最上层.
    if (isShowBgColor) {
        NSArray * superSubViews = [self.superview subviews];
        indexInSuperview = [superSubViews indexOfObject:self];
        [self.superview exchangeSubviewAtIndex:[superSubViews count] - 1 withSubviewAtIndex:indexInSuperview];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    }
    else    //发送回调函数,通知delegate
      {
        if (delegate && [delegate respondsToSelector:@selector(PullViewWillShow:)]) {
            [delegate PullViewWillShow:self];
            
        }
      }
    
}

-(void)moveToBottom:(bool)stateChanged
{

    //把pullview移到之前所在层.
    if (isShowBgColor) {
        NSArray * superSubViews = [self.superview subviews];
        [self.superview exchangeSubviewAtIndex:[superSubViews count] - 1 withSubviewAtIndex:indexInSuperview];
        self.backgroundColor = [UIColor clearColor];
    }
    else    //发送回调函数,通知delegate
      {
          if (delegate && [delegate respondsToSelector:@selector(PullViewHided: 
                                                                 state:)]) {
              [delegate PullViewHided:self state:stateChanged];
              
          }
          

      }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesBegan:[event touchesForView:self] withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesMoved:[event touchesForView:self] withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesEnded:[event touchesForView:self] withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesCancelled:[event touchesForView:self] withEvent:event];
}


@end
