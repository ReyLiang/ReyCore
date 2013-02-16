//
//  MyClass.h
//  ReyCore
//
//  Created by rey liang on 12-2-3.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ReyButtonRotationStateLeft,
    ReyButtonRotationStateUp,
    ReyButtonRotationStateRight,
    ReyButtonRotationStateDown
}ReyButtonRotationState;



@interface ReyButton_rotation : UIButton
{
    //是否摇摆的标识
    bool isRocker;
    
}

- (id)initWithFrame:(CGRect)frame 
        centerState:(ReyButtonRotationState)centerState;

-(void)startRocker;
-(void)stopRocker;

@end
