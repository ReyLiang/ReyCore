/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyDownload_Post.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/12 
 
 Description: 
 
 用于http下载模板类,使用post传值
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import "ReyDownload_Post.h"

@implementation ReyDownload_Post

@synthesize strPostBody;

+ (id)ReyDownloadWithDelegate:(id<ReyDownloadDelegate>) myDelegate
                 request:(NSMutableURLRequest *)request
{
    
    ReyDownload_Post * autoRelese = [[ReyDownload_Post alloc] init];
    autoRelese.m_autoRelease = YES;
    autoRelese.m_request = request;
    
    [autoRelese downloadWithURL:nil delegate:myDelegate];
    
    return autoRelese;
    
    
}


//模拟oc做的自动释放函数
+ (id)ReyDownloadWithURL:(NSURL * )url 
                delegate:(id<ReyDownloadDelegate>) myDelegate 
               postField:(NSDictionary *)postBody
{
    ReyDownload_Post * autoRelese = [[ReyDownload_Post alloc] init];
    autoRelese.m_autoRelease = YES;
    
    if (postBody) {
        NSArray * keys = [postBody allKeys];
        for (NSString * key in keys) {
            [autoRelese addPostFieldWithKey:key value:[postBody valueForKey:key]];
        }
    }
    
    [autoRelese downloadWithURL:url delegate:myDelegate];
    
    return autoRelese;
}


+ (id)ReyDownloadWithURL:(NSURL * )url
                delegate:(id<ReyDownloadDelegate>) myDelegate
               postField:(NSDictionary *)postBody
               extraData:(NSMutableDictionary *)extraData
{
    ReyDownload_Post * autoRelese = [[ReyDownload_Post alloc] init];
    autoRelese.m_autoRelease = YES;
    
    if (postBody) {
        NSArray * keys = [postBody allKeys];
        for (NSString * key in keys) {
            [autoRelese addPostFieldWithKey:key value:[postBody valueForKey:key]];
        }
    }
    
    autoRelese.m_extraData = extraData;
    
    [autoRelese downloadWithURL:url delegate:myDelegate];
    
    return autoRelese;
}
-(id)init
{
    self = [super init];
    if (self) {
        
        strPostBody = nil;
        
    }
    return self;
}
//TODO: 获得request,方便post子类重载.
-(NSMutableURLRequest *)getRequestWithURL:(NSURL *)url
{
    if (m_request) {
        
        cancleTimer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(ConnectFailed) userInfo:nil repeats:NO] retain];
        
        return m_request;
    }
    
    NSMutableURLRequest * urlRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	[urlRequest setTimeoutInterval:10];
	[urlRequest setURL:url];

    [urlRequest setHTTPBody:[strPostBody dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPMethod:@"POST"];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(ConnectFailed) userInfo:nil repeats:NO];
    
    return urlRequest;
}


//TODO: 设置post方式的key-value.
-(void)addPostFieldWithKey:(NSString *)key value:(NSString *)value
{
    if (!strPostBody) {
        strPostBody = [[NSMutableString alloc] init];
    }
    else
      {
        [strPostBody appendFormat:@"&"];
      }
    [strPostBody appendFormat:@"%@=%@",key,value];
}

-(void)dealloc
{
    
    [strPostBody release];
    [super dealloc];
}

@end
