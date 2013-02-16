//
//  ReyLabel_rocker.h
//  ReyCodeXML
//
//  Created by 慧彬 梁 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ReyLabel_Rock_Left,
    ReyLabel_Rock_Right
}ReyLabel_RockDirection;

@interface ReyLabel_rocker : UIView
{
    
    UILabel * m_label;
    
    NSString * m_message;
    
    float m_fontSize;
    
    //second
    float m_duration;
    
    //anim direction
    //
    ReyLabel_RockDirection m_currentTag;
    
    bool m_animStarted;
    
    bool m_animCanStart;
}
@property (nonatomic , retain) UILabel * m_label;
@property (nonatomic , retain) NSString * m_message;

- (id)initWithFrame:(CGRect)frame message:(NSString *)msg fontSize:(float)fontsize duration:(float)duration;
- (id)initWithFrame:(CGRect)frame message:(NSString *)msg fontSize:(float)fontsize;
-(void)startWithDuration:(float)duration;
-(void)stop;

@end
