//
//  Rey_BLV_item.h
//  ReyBreakLoad
//
//  Created by Rey on 12-11-18.
//  Copyright (c) 2012年 Rey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Rey_BLV_itemDelegate;

@interface Rey_BLV_item : UIView
{
    
    id<Rey_BLV_itemDelegate> m_delegate;
    
    CGSize m_superSize;
    
    UIImageView * m_imgView;
}

@property (nonatomic , assign) id<Rey_BLV_itemDelegate> m_delegate;
@property (nonatomic , retain) UIImageView * m_imgView;

- (id)initWithFrame:(CGRect)frame superSize:(CGSize)superSize showImg:(UIImage *)showImg;
- (id)initWithFrame:(CGRect)frame superSize:(CGSize)superSize;
-(void)startAnimation;
-(void)setImage:(UIImage *)image;
@end


@protocol Rey_BLV_itemDelegate <NSObject>

-(void)Rey_BLV_itemAnimationFinished:(Rey_BLV_item *)item;

@end
