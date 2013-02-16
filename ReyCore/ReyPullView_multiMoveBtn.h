/************************************************* 
 
 Copyright (C), 2011-2015, yunlian Tech. Co., Ltd. 
 
 File name:	ReyPullView_multiMoveBtn.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/10 
 
 Description: 
 
 支持多个拉出按钮
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>
#import "ReyPullView.h"

@interface ReyPullView_multiMoveBtn : ReyPullView

{
    ReyPullView_moveBtn * otherMoveBtn;
    
    //otherMoveBtn的orgin点
    CGPoint otherShowPoint;
}

@property (nonatomic , retain) ReyPullView_moveBtn * otherMoveBtn;

- (id)initWithFrame:(CGRect)frame 
  pullFromDirection:(ReyPullViewFromDirection)aDirection 
         pulledView:(UIView *)aPullView
        moveBtnImgs:(NSArray *)imgsArry 
          showPoint:(CGPoint)aShowPoint
     otherShowPoint:(CGPoint)aOtherShowPoint;

-(void)setMoveBtnFrame:(ReyPullView_moveBtn *)aMoveBtn
          distanceSize:(CGSize)distanceSize 
            isFinished:(bool)isFinished;
@end
