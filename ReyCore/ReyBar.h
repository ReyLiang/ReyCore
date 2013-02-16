//
//  ReyBar.h
//  ReyCore
//
//  Created by Rey on 12-8-18.
//
//

#import <UIKit/UIKit.h>

@protocol ReyBarDelegate;

@interface ReyBar : UIView
{
    id<ReyBarDelegate> delegate;
    
    //移动的背景
    UIImageView * m_moveImgView;
    
    //当前点击按钮
    UIButton * m_lastBtn;
}
@property (nonatomic , assign) id<ReyBarDelegate> delegate;
@property (nonatomic , retain) UIImageView * m_moveImgView;
@property (nonatomic , retain) UIButton * m_lastBtn;;

-(void)setItemsWithImgs:(NSArray *)imgs;

- (id)initWithFrame:(CGRect)frame
              bgImg:(UIImage *)bgImg
            moveImg:(UIImage *)moveImg;
- (id)initWithFrame:(CGRect)frame
              bgImg:(UIImage *)bgImg
            moveImg:(UIImage *)moveImg
           itemImgs:(NSArray *)itemImgs;
@end


@protocol ReyBarDelegate <NSObject>

-(void)ReyBarItemsClicked:(ReyBar *)sender index:(int)index;

@end