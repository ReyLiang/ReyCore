/*************************************************
 
 Copyright (C), 2012-2015, Rey mail=>rey0@qq.com.
 
 File name:	ReyMD5.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/8/7
 
 Description:
 
 md5加密类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import <Foundation/Foundation.h>

@interface ReyMD5 : NSObject

+(NSString *)getMD5WithString:(NSString *)str;
+(NSString *)getMD5WithString:(NSString *)str withKey:(NSString *)key;
@end
