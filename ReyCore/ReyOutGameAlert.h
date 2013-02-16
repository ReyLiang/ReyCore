//
//  ReyAutoDisconnAlert.h
//  GODClient
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReyAlert_outGame.h"
#import "ReyAlert.h"


@interface ReyOutGameAlert : ReyAlert
- (id)initWithFrame:(CGRect)frame 
           delegate:(id<ReyCustomAlertDelegate>)aDelegate 
    backgroundImage:(UIImage *)image
            message:(NSString *)aMessage 
         buttonImgs:(NSArray *)imgsArray 
       buttonTitles:(NSArray *) titlesArray 
                tag:(int)tag;
@end
