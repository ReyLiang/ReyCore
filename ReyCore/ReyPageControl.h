//
//  ReyPageControl.h
//  MenuDemoTest
//
//  Created by I Mac on 11-4-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReyPageControl : UIPageControl {

	UIImage* activeImage;
    UIImage* inactiveImage;
	CGSize dotsSize;
    float gap;
}

@property (nonatomic , retain) UIImage* activeImage;
@property (nonatomic , retain) UIImage* inactiveImage;


- (id)initWithFrame:(CGRect)frame
          activeImg:(UIImage *)activeImg
        inactiveImg:(UIImage *)inactiveImg
                gap:(float)aGap;

- (id)initWithFrame:(CGRect)frame
          activeImg:(UIImage *)activeImg
        inactiveImg:(UIImage *)inactiveImg;

@end
