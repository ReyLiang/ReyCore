/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyPullView_multiMoveBtn.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/10 
 
 Description: 
 
 支持button在初始点的水平方向上偏移
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 
#import <Foundation/Foundation.h>
#import "ReyPullView.h"

@interface ReyPullView_customMoveBtn : ReyPullView
{
    CGPoint moveBtnOrigin;
}

//TODO: aMoveBtnOrigin: 移动按钮的位置
- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullViewFromDirection)aDirection 
         pulledView:(UIView *)aPullView
        moveBtnImgs:(NSArray *)imgsArry 
          showPoint:(CGPoint)aShowPoint
      moveBtnOrigin:(CGPoint)aMoveBtnOrigin;

@end
