//
//  ReyScrollView_detailView.h
//  ReyCore
//
//  Created by Rey on 12-11-14.
//
//

#import <UIKit/UIKit.h>
#import "ReyScrollView.h"


@interface ReyScrollView_detailView : UIView
{
    ReyScrollView * m_superScrollView;
    
//    BOOL isSingleTap;
}

@property (nonatomic , assign) ReyScrollView * m_superScrollView;

- (id)initWithFrame:(CGRect)frame scrollView:(ReyScrollView *)scrollView;

@end
