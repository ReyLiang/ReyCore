//
//  ReyLoadView.h
//  ReyCore
//
//  Created by Rey on 12-9-10.
//
//

#import <UIKit/UIKit.h>

@interface ReyLoadView : UIView
{
    UIImageView * m_loadImgView;
}

@property (nonatomic , retain) UIImageView * m_loadImgView;

-(void)startLoading:(double)duration;
-(void)endLoading;
- (id)initWithFrame:(CGRect)frame loadingImage:(UIImage *)loadingImage;
@end
