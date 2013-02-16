//
//  ReyAlert.h
//  ReyCore
//
//  Created by rey liang on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReyCustomAlert.h"

@interface ReyAlert : UIView
{
    ReyCustomAlert * m_alert;
}
@property (nonatomic , retain) ReyCustomAlert * m_alert;
- (id)initWithFrame:(CGRect)frame 
           delegate:(id<ReyCustomAlertDelegate>)aDelegate 
    backgroundImage:(UIImage *)image
            message:(NSString *)aMessage 
         buttonImgs:(NSArray *)imgsArray 
       buttonTitles:(NSArray *) titlesArray 
                tag:(int)tag;
-(void)SetAutoRemoveMode:(bool)isAutoRemove;
-(int)getDevice;
@end
