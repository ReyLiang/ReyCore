//
//  ReyProcess.h
//  ReyProcess
//
//  Created by I Mac on 11-3-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReyProcess : UIView {
	float progress;
    
    int totalCount;
	
	//已加载进度条的遮盖
	CALayer * maskLayer ;
    
    int currectIndex;
}
@property(nonatomic) float progress;
@property(nonatomic) int totalCount;
@property (nonatomic , retain) CALayer * maskLayer;

-(void)setProgress:(float)number;
-(CGRect)getMastLayerFrame;

- (id)initWithFrame:(CGRect)frame nullImg:(UIImage *)nullImg fullImg:(UIImage *)fullImg;

-(void)addProgress;
-(void)delProgress;
@end
