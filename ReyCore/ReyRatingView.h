/************************************************* 
 
 Copyright (C), 2011-2012, rey. 
 
 File name:	ReyRatingView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/6/18
 
 Description: 
 
 评分用的star界面.
 支持动态改变
 
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol ReyRatingViewDelegate <NSObject>
-(void)ratingChanged:(float)newRating;
@end


@interface ReyRatingView : UIView {
	UIImageView *s1, *s2, *s3, *s4, *s5;

	UIImage *unselectedImage, *partlySelectedImage, *fullySelectedImage;
	id<ReyRatingViewDelegate> viewDelegate;

	float starRating, lastRating;
	float height, width; // of each image of the star!
    
    //是否支持改变star个数
    bool m_canMoved;
}

@property (nonatomic, retain) UIImageView *s1;
@property (nonatomic, retain) UIImageView *s2;
@property (nonatomic, retain) UIImageView *s3;
@property (nonatomic, retain) UIImageView *s4;
@property (nonatomic, retain) UIImageView *s5;


-(void)setImagesDeselected:(NSString *)unselectedImage partlySelected:(NSString *)partlySelectedImage 
			  fullSelected:(NSString *)fullSelectedImage andDelegate:(id<ReyRatingViewDelegate>)d;
-(void)displayRating:(float)rating;
-(float)rating;

-(id )initWithFrame:(CGRect)frame 
      displayRating:(float)rate 
        andDelegate:(id)delegate 
      imageNameArry:(NSArray *)imageNameArry 
           canMoved:(bool)canMoved;

-(void)checkRating:(NSSet *)touches withEvent:(UIEvent *)event;

@end
