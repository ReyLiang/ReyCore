//
//  ReyPopupView_fromBtn.m
//  PopupTest
//
//  Created by rey liang on 12-1-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyPopupView_circle.h"
#import <QuartzCore/QuartzCore.h>
/////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ReyPopupView_circle ()

//TODO: 功能函数
-(CGPoint)getPathCenter:(int)index randius:(float)randius;
-(float)getStartangleWithPathCenter:(CGPoint)pathCenter;

-(float)getEndangle:(int)index 
         pathCenter:(CGPoint)pathCenter 
         startangle:(float) startangle;

-(void)addCircleItemWithIndex:(int)index 
                   PathCenter:(CGPoint)pathCenter 
                   startangle:(float)startangle 
                     endangle:(float)endangle 
                      randius:(float)randius 
                  isClockWise:(bool)isclockWise;


-(void)showItems;
-(void)hideItems;
-(void)showBgimage;
-(void)CircleItemClick:(UIButton *)btn;


//TODO: 初始化函数
-(void)initData;
-(void)initImgBtnItems;
@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ReyPopupView_circle

@synthesize itemsImgArray,itemsArray;
@synthesize settingBtn;
@synthesize bgImageView;
@synthesize delegate;


//动画周期
#define CIRCLE_ANIMATION_DURATION  1.0f

//轨迹圆的半径
#define PATH_RANDIUS 150.0

//根据角度获得弧度
#define RADIAN(X) M_PI/180.0*(X)

//最大加载功能按钮数,包括setting按钮
#define MAXCOUNT 8



//TODO: point: 动画开始的位置
//TODO: items: 子按钮的图片数组.数组中,奇数为normal图片,偶数为heightLight图片
//TODO: isClockwise: 是否为逆时针
- (id)initWithFrame:(CGRect)frame center:(CGPoint )point itemsImgArray:(NSArray *)items isClockwise:(bool)isClockwise
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        finishedItemsCount = 0;
        
        centerPoint = point;

        itemsImgArray = [[NSArray alloc] initWithArray:items];
        
        isClockWise = isClockwise;
        
        
        [self initData];
    }
    return self;
}

-(void)dealloc
{
    [itemsArray removeAllObjects];
    [itemsArray release];
    
    [itemsImgArray release];
    
    [settingBtn release];
    [bgImageView release];
    [super dealloc];
}

-(void)initData
{
    [self initImgBtnItems];
}


//TODO: 初始化image按钮
-(void)initImgBtnItems
{
    //添加背景图片
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgImageView.hidden = YES;
    [self addSubview:bgImageView];
    
    itemsArray = [[NSMutableArray alloc] init];
    
    int count = [itemsImgArray count]/2;
      
    if (count > MAXCOUNT) {
        count = MAXCOUNT;
    }
    for (int i = 1; i < count; i++) {
        
        
        //获得动画所需要的,轨迹圆的圆心坐标,动画开始角度,动画结束角度
        CGPoint pathCenter = [self getPathCenter:i randius:PATH_RANDIUS];      
        float startangle = [self getStartangleWithPathCenter:pathCenter];
        float endangle = [self getEndangle:i pathCenter:pathCenter startangle:startangle];
        
        [self addCircleItemWithIndex:i
                          PathCenter:pathCenter 
                               startangle:startangle 
                                 endangle:endangle 
                                  randius:PATH_RANDIUS 
                              isClockWise:isClockWise];
        
      }
    
    
    //初始化最上面的按钮
    UIImage * img = [itemsImgArray objectAtIndex:0];
    UIImage * imgH = [itemsImgArray objectAtIndex:1];
    
    settingBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    settingBtn.center = centerPoint;
    [settingBtn setTag:0];
    
    [settingBtn setBackgroundImage:img forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    
    [settingBtn addTarget:self action:@selector(CircleItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingBtn];

    
    //初始化背景图片
    UIImage * bgImg;
    if ([itemsArray count] < 4) {//加载第一张背景图
        bgImg = [UIImage imageNamed:@"Rey_circleBgimage1"];
    }
    else if ([itemsArray count] < 5) {//加载第二张背景图
        bgImg = [UIImage imageNamed:@"Rey_circleBgimage2"];
    }
    else if ([itemsArray count] < 6) {//加载第三张背景图
        bgImg = [UIImage imageNamed:@"Rey_circleBgimage3"];
    }
    else if ([itemsArray count] < MAXCOUNT) {//加载第四张背景图
        bgImg = [UIImage imageNamed:@"Rey_circleBgimage4"];
    }
    
    bgImageView.image = bgImg ;

}

//TODO: 添加动画按钮
-(void)addCircleItemWithIndex:(int)index 
                   PathCenter:(CGPoint)pathCenter 
                    startangle:(float)startangle 
                      endangle:(float)endangle 
                       randius:(float)randius 
                   isClockWise:(bool)isclockWise
{
    UIImage * img = [itemsImgArray objectAtIndex:index*2];
    UIImage * imgH = [itemsImgArray objectAtIndex:index* 2 + 1];
    
    ReyPopupView_circleItem * btn = [[ReyPopupView_circleItem alloc ]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    btn.delegate = self;
    btn.center = centerPoint;
    [btn setTag:index];
    
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:imgH forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(CircleItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //==test
//    [btn addMoveAnimationWithPathCenter:CGPointMake(150, 100) startangle:M_PI_2 endangle:M_PI randius:150 isClockWise:isClockWise];
    [btn addMoveAnimationWithPathCenter:pathCenter 
                             startangle:startangle 
                               endangle:endangle 
                                randius:randius 
                            isClockWise:isclockWise];
    
    [self addSubview:btn];
    [itemsArray addObject:btn];
    [btn release];
}

//功能键点击
-(void)CircleItemClick:(ReyPopupView_circleItem *)btn
{
    if (btn.tag == -1) {//隐藏功能键
        [self hideItems];
        btn.tag = 0;
        
        if (delegate && [delegate respondsToSelector:@selector(circleItemsAnimationStart:)]) {
            [delegate circleItemsAnimationStart:NO];
        }
    }
    else if (btn.tag == 0) {//显示功能键
        [self showItems];
        btn.tag = -1;
        
        if (delegate && [delegate respondsToSelector:@selector(circleItemsAnimationStart:)]) {
            [delegate circleItemsAnimationStart:YES];
        }
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(circleItemsClicked:)]) {
            [delegate circleItemsClicked:btn];
        }

    }
}


//显示功能键
-(void)showItems
{
    [self showBgimage];
    settingBtn.userInteractionEnabled = NO;
    for (int i = 0 ; i < [itemsArray count]; i++) {
        ReyPopupView_circleItem * btn = [itemsArray objectAtIndex:i];
        [btn startShowAnimation];
    }
}

//隐藏功能键
-(void)hideItems
{
    [self showBgimage];
    settingBtn.userInteractionEnabled = NO;
    for (int i = 0 ; i < [itemsArray count]; i++) {
        ReyPopupView_circleItem * btn = [itemsArray objectAtIndex:i];
        [btn startHideAnimation];
    }
}

//背景图片的显示隐藏动画
-(void)showBgimage
{
    bgImageView.hidden = !bgImageView.hidden;
    CATransition *animation = [CATransition animation];
    //animation.delegate = self;
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromTop;
    [bgImageView.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark -
#pragma mark ReyPopupView_circleItemDelegate

-(void)circleItemShowAnimationFinished:(ReyPopupView_circleItem *)item
{

    if (finishedItemsCount + 1 != [itemsArray count]) {
        finishedItemsCount ++;
        return;
    }
    
    settingBtn.userInteractionEnabled = YES;
    finishedItemsCount = 0;
    
    if (delegate && [delegate respondsToSelector:@selector(circleItemsAnimationFinished:)]) {
        [delegate circleItemsAnimationFinished:YES];
    }
    
    return;
}


-(void)circleItemHideAnimationFinished:(ReyPopupView_circleItem *)item
{

    if (finishedItemsCount + 1 != [itemsArray count]) {
        finishedItemsCount ++;
        return;
    }
    settingBtn.userInteractionEnabled = YES;
    finishedItemsCount = 0;
    
    if (delegate && [delegate respondsToSelector:@selector(circleItemsAnimationFinished:)]) {
        [delegate circleItemsAnimationFinished:NO];
    }
    return;
}

#pragma mark -


#pragma mark -
#pragma mark Animation path

//TODO: 获得运动轨迹的开始角度
//TODO: index: 添加item的位置
//TODO: randius: 轨迹圆半径
-(CGPoint)getPathCenter:(int)index randius:(float)randius
{
    //pathCenter在以centerPoint为圆心的圆上.
    //简化坐标系.以centerPoint为原点.
  {
    //从哪点出发
    //相对self.frame.origin的点
    float centerX = centerPoint.x;//440;
    float centerY = centerPoint.y;//280;
    
    float pathCenterX[] ={ 70 , 120 , 144 , 10 };
    
    //x^2 + y^2 = r^2;
    //计算相对出发点的x,y值.
    float x;
    float y;
    
    if (index < 4) {//第一条线,加载3个按钮
        x = pathCenterX[0];
    }
    else if (index < 6)//第二条线,加载2个按钮
      {
        if (index == 4) {
            x = pathCenterX[2];
        }
        else //增加一条圆
          {
            x = pathCenterX[1];
          }
        
      }
    else if (index < MAXCOUNT)//第三条线,加载2个按钮
      {
        x = pathCenterX[3];
      }
    
    //*1,计算出发点上方的轨迹圆心.*-1计算出发点下方的
    y = sqrtf(randius * randius - x * x) * 1;
    
    return CGPointMake(centerX + x, centerY - y);
  }

}

//TODO: 获得运动轨迹的开始角度
//TODO: pathCenter: 路径的圆心坐标
-(float)getStartangleWithPathCenter:(CGPoint)pathCenter 
{
    //centerPoint在以pathCenter为圆心的圆上.
    //简化坐标系.以pathCenter为原点.
    //判断centerPoint,在简化的坐标系中的象限,从而得到偏移角度

    float x = centerPoint.x - pathCenter.x;
    float y = pathCenter.y - centerPoint.y;
    
    if (x>=0) {
        if (y>=0) {  //第一象限
            
            return -1.0 * atan(y/x);
        }
        else //第四象限
          {
            return  atan(-y/x);
          }
    }
    else
      {
        if (y >= 0) {  //第二象限
            return -1.0 * atan(-x/y) - M_PI_2;
        }
        else  //第三象限
          {
            return atan(-x / -y) + M_PI_2;
          }
      }
}

//获得结束角度.
//主要是相对开始角度,偏移的角度
//先测试便宜45度 == M_PI_4
//TODO: 获得运动轨迹的偏转角度.
//TODO: pathCenter: 路径的圆心坐标
//TODO: startangle: 运动轨迹开始角度
-(float)getEndangle:(int)index 
         pathCenter:(CGPoint)pathCenter 
         startangle:(float) startangle 
{

    float endangle = startangle;
    if (index < 4) {//第一条线,加载3个按钮
        endangle += index * RADIAN(41.0);
    }
    else if (index < 5)//第二条线,加载第1个按钮
      {
        endangle += index%3 * RADIAN(30.0);
      }
    else if (index < 6)//第二条线,加载第2个按钮
      {
        endangle += index%3 * RADIAN(36.0);
      }
    else if (index < MAXCOUNT)//第三条线,加载2个按钮
      {
        endangle += (index%5 + 1) * RADIAN(40.0) + RADIAN(10.0);
      }
    
    //超出范围
    return endangle;
}

#pragma mark -



@end
