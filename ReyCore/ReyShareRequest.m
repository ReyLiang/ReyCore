//
//  ReyShareRequest.m
//  shareTeset
//
//  Created by 慧彬 梁 on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyShareRequest.h"

@interface ReyShareRequest()

+(NSData *)getDataFromParemeber:(NSDictionary *)parameber;

+(NSData *)getMultipartDataFromParemeber:(NSDictionary *)parameber;


+(NSData *)getMultiItemDataWithName:(NSString *)name value:(NSString *)value;
+(NSData *)getMultiItemDataWithName:(NSString *)name data:(NSData *)data;
+(NSData *)getMultiItemDataWithName:(NSString *)name image:(UIImage *)image;
@end

@implementation ReyShareRequest


#define TIMEOUT 60
#define kShareRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

+(NSMutableURLRequest *)getRequestWithURL:(NSString *)url 
                                parameber:(NSDictionary *)parameber 
                                   method:(ReyShareRequestMethodType)method
{
    NSMutableURLRequest * request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    //设置也没用,还是120s
    [request setTimeoutInterval:TIMEOUT];
    
    switch (method) {
        case ReyShareRequestMethodType_Get:
        {
            NSString * webStr = [NSString stringWithFormat:@"%@?%@",url,[ReyShareRequest getStringFromParemeber:parameber]];
            
            [request setURL:[NSURL URLWithString:webStr]];
            
            [request setHTTPMethod:@"GET"];
            
            
            return request;
            break;

        }
        case ReyShareRequestMethodType_Post:
        {
            
            [request setURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[ReyShareRequest getDataFromParemeber:parameber]];
            return request;
            break;
            
        }
        case ReyShareRequestMethodType_Multipart:
        {
            [request setURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kShareRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:[ReyShareRequest getMultipartDataFromParemeber:parameber]];
            return request;
            break;
        }
        
    }
    
    
    return nil;
}

//TODO: k=v&k1=v1....
+(NSString *)getStringFromParemeber:(NSDictionary *)parameber
{
    NSMutableString * str = [[[NSMutableString alloc] init] autorelease];
    NSArray * keys = [parameber allKeys];
    int i =0;
    
    for (NSString * key in keys) {
        if (i != 0) {
            [str appendFormat:@"&"];
        }
        
        [str appendFormat:@"%@=%@",key,[parameber objectForKey:key]];
        
        i++;
    }
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

//TODO: NSData * by k=v&k1=v1....
+(NSData *)getDataFromParemeber:(NSDictionary *)parameber
{
    NSString * str = [ReyShareRequest getStringFromParemeber:parameber];
    
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData *)getMultipartDataFromParemeber:(NSDictionary *)parameber
{
    
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kShareRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"--%@--\r\n", kShareRequestStringBoundary];
    
    NSMutableData * body = [NSMutableData data];
    
    
    
    NSArray * keys = [parameber allKeys];
    
    //先传文字
    for (NSString * key in keys) {
        
        id value = [parameber objectForKey:key];
        if ([value isKindOfClass:[UIImage class]]) {
//            [body appendData:[ReyShareRequest getMultiItemDataWithName:key image:value]];
        }
        else if ([value isKindOfClass:[NSData class]])
        {
//            [body appendData:[ReyShareRequest getMultiItemDataWithName:key data:value]];
        }
        else
        {
            [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[ReyShareRequest getMultiItemDataWithName:key value:value]];
        }
    }
    
    //后传文件
    for (NSString * key in keys) {
//        [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
        id value = [parameber objectForKey:key];
        if ([value isKindOfClass:[UIImage class]]) {
            [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[ReyShareRequest getMultiItemDataWithName:key image:value]];
        }
        else if ([value isKindOfClass:[NSData class]])
        {
            [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[ReyShareRequest getMultiItemDataWithName:key data:value]];
        }
        else
        {
//            [body appendData:[ReyShareRequest getMultiItemDataWithName:key value:value]];
        }
    }
    
    [body appendData:[bodySuffixString dataUsingEncoding:NSUTF8StringEncoding]];

    return body;
}

+(NSData *)getMultiItemDataWithName:(NSString *)name value:(NSString *)value
{
    NSString * str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",name,value];
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData *)getMultiItemDataWithName:(NSString *)name data:(NSData *)data
{
    NSMutableString * str = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n",name];
    [str appendFormat:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
    
    NSMutableData * resultData = [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [resultData appendData:data];
    [resultData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return resultData;
}

+(NSData *)getMultiItemDataWithName:(NSString *)name image:(UIImage *)image
{
    NSMutableString * str = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n",name];
    [str appendFormat:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
//    NSLog(@"%@",str);
    
    NSMutableData * resultData = [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [resultData appendData:UIImagePNGRepresentation(image)];
    [resultData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return resultData;
}
                                  
                                  
@end
