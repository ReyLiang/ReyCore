//
//  ReyNetWorkStatus.h
//  ReyCore
//
//  Created by rey liang on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReyNetWorkStatus : UIView
{
    Reachability * m_reach;
    
    UIImageView * netWorkImgView;
    
    NetworkStatus lastNetStatus;
    
    UIInterfaceOrientation lastOrientation;
}

@property (nonatomic, retain)Reachability * m_reach;
@property (nonatomic, retain)UIImageView * netWorkImgView;


- (id)initWithHostName:(NSString *)hostname;
- (id)initWithIP:(NSString *)ipStr;
- (void)addNetWorkImg;
- (void)exchangeFrame:(UIInterfaceOrientation)orientation;
@end
