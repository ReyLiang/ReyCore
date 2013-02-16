//
//  ReyBreakLoadView.h
//  ReyBreakLoad
//
//  Created by Rey on 12-11-18.
//  Copyright (c) 2012年 Rey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReyLoadView.h"

@interface ReyBreakLoadView : ReyLoadView
{
    UIImage * m_superImage;
    
    NSMutableArray * m_itemsArry;
    
    UIView * m_bgView;
}


@property (nonatomic , retain) UIImage * m_superImage;

@property (nonatomic , retain) NSMutableArray * m_itemsArry;

@property (nonatomic , retain) UIView * m_bgView;


- (id)initWithFrame:(CGRect)frame
       loadingImage:(UIImage *)loadingImage
       superViewImg:(UIImage *)superViewImg;

-(void)startLoading:(double)duration superImage:(UIImage *)superImage;


@end
