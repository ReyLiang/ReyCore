//
//  ReyMD5.m
//  ReyCore
//
//  Created by 慧彬 梁 on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyMD5.h"
#import "MD5.h"

@implementation ReyMD5

+(NSString *)getMD5WithString:(NSString *)str
{
    MD5 * md5 = new MD5();
    
    md5->reset();
    md5->update([str cStringUsingEncoding:NSUTF8StringEncoding]);
    
    std::string md5Str = md5->toString();
    
    delete md5;
    
    return [NSString stringWithCString:md5Str.c_str() encoding:NSUTF8StringEncoding];
}

+(NSString *)getMD5WithString:(NSString *)str withKey:(NSString *)key
{
    MD5 * md5 = new MD5();
    
    std::string t_str([[ReyMD5 getMD5WithString:str] cStringUsingEncoding:NSUTF8StringEncoding]);
    std::string t_key([key cStringUsingEncoding:NSUTF8StringEncoding]);
    
    md5->reset();
    md5->update(t_str+t_key);
    
    std::string md5Str = md5->toString();
    
    delete md5;
    
    return [NSString stringWithCString:md5Str.c_str() encoding:NSUTF8StringEncoding];
}
@end
