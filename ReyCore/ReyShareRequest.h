/*************************************************
 
 Copyright (C), 2012-2015, Rey mail=>rey0@qq.com.
 
 File name:	ReyShareRequest.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/8/14
 
 Description:
 
 分享请求类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    ReyShareRequestMethodType_Get,
    ReyShareRequestMethodType_Post,
    ReyShareRequestMethodType_Multipart
}ReyShareRequestMethodType;

@interface ReyShareRequest : NSObject
+(NSMutableURLRequest *)getRequestWithURL:(NSString *)url 
                                parameber:(NSDictionary *)parameber 
                                   method:(ReyShareRequestMethodType)method;

+(NSString *)getStringFromParemeber:(NSDictionary *)parameber;
@end
