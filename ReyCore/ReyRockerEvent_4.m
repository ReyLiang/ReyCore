//
//  ReyRockerEvent_4.m
//  ReyCore
//
//  Created by rey liang on 12-1-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyRockerEvent_4.h"

@implementation ReyRockerEvent_4

//判断角度是否小于M_PI_4
-(int)getLessangle:(float )x y:(float)y
{
    
    float length = sqrtf((x-m_centerX)*(x-m_centerX) + (y-m_centerY)*(y-m_centerY));
    
    float sinV = fabsf(x-m_centerX)/length;
    float du = fabsf(asinf(sinV));
    //    //NSLog(@"x = %f y = %f du =%f",x,y,du);
    if (du <= (M_PI_4)) {//贴近y轴
                           //        //NSLog(@"度数小于22.5");
        return -1;
    }
    else //贴近x轴
      {
        //        //NSLog(@"度数大于77.5");
        return 1;
      }
    
}

@end
