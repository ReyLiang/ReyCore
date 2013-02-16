//
//  ReyAlert_autoDisconnect.h
//  GODClient
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReyCustomAlert.h"

@interface ReyAlert_autoDisconnect : ReyCustomAlert
{

    
    UILabel * timeOutLabel;

    int timeCount;
    
    NSTimer * timeOutTimer;
}


@property (nonatomic , retain) UILabel * timeOutLabel;
@property (nonatomic , retain) NSTimer * timeOutTimer;

@end
