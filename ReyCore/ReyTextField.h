//
//  ReyTextField.h
//  ReyCore
//
//  Created by rey liang on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReyTextField : UITextField
{
    float padding_left;
    float padding_right;
    float padding_top;
    float padding_bottom;
}

@property (nonatomic) float padding_left;
@property (nonatomic) float padding_right;
@property (nonatomic) float padding_top;
@property (nonatomic) float padding_bottom;
@end
