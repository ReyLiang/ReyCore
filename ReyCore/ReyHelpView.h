//
//  ReyHelpView.h
//  ReyCore
//
//  Created by rey liang on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReyHelpView : UIView
    <UIScrollViewDelegate>
{
    UIScrollView * scrollView;
    
    UIButton * jumpBtn;
    
    int gameID;
    
    //不再提示的标识
    bool isNeverShow;
}
@property (nonatomic , retain) UIScrollView * scrollView;
@property (nonatomic , retain) UIButton * jumpBtn;
@property (nonatomic) int gameID;

- (id)initWithFrame:(CGRect)frame 
         isVertical:(bool)isVertical 
       helpsImgArry:(NSArray *)imgsArry 
         isUserShow:(bool)isUserShow 
             gameID:(int)gameID;
@end
