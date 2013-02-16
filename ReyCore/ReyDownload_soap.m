//
//  ReyDownload_soap.m
//  ReyCore
//
//  Created by 慧彬 梁 on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyDownload_soap.h"
#import "ReyCodeXML.h"

@interface ReyDownload_soap()
-(NSMutableString *)getPostBody:(NSDictionary *)postBody;
@end

@implementation ReyDownload_soap

@synthesize soap_xmlns_tag,soap_xmlns_space,soap_action,soap_itemsArry;



+ (id)ReyDownloadWithDelegate:(id<ReyDownloadDelegate>) myDelegate
                 request:(NSMutableURLRequest *)request
{
    
    ReyDownload_soap * autoRelese = [[ReyDownload_soap alloc] init];
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
    ReyDownload_soap * autoRelese = [[ReyDownload_soap alloc] init];
    autoRelese.m_autoRelease = YES;
    
    if (postBody) {
        
        
        autoRelese.soap_xmlns_tag = [postBody valueForKey:@"xmlns_tag"];
        autoRelese.soap_xmlns_space = [postBody valueForKey:@"xmlns_space"];
        autoRelese.soap_action = [postBody valueForKey:@"action"];
        [autoRelese.soap_itemsArry addObjectsFromArray:[postBody valueForKey:@"items"]];

    }
    
    [autoRelese downloadWithURL:url delegate:myDelegate];
    
    return autoRelese;
}

-(id)init
{
    self = [super init];
    if (self) {
        soap_itemsArry = [[NSMutableArray alloc] init];
    }
    return self;
}

//TODO: 获得request,方便post子类重载.
-(NSMutableURLRequest *)getRequestWithURL:(NSURL *)url
{
    strPostBody = [[ReyCodeXML ReyCodeXMLGetSOAPPostBodyWithAction:soap_action 
                                                     withXmlns_tag:soap_xmlns_tag 
                                                   withXmlns_space:soap_xmlns_space 
                                                      withPostBody:soap_itemsArry] retain];
    
//    NSLog(@"@@@@@\n %@",strPostBody);
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [strPostBody length]];
    NSString * soapaction = [NSString stringWithFormat:@"%@%@",soap_xmlns_space,soap_action];
    
    NSMutableURLRequest * urlRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	[urlRequest setTimeoutInterval:10];
	[urlRequest setURL:url];
    
    //以下对请求信息添加属性前四句是必有的
	[urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest addValue: soapaction forHTTPHeaderField:@"SOAPAction"];
	[urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setHTTPBody:[strPostBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(ConnectFailed) userInfo:nil repeats:NO];
    
    return urlRequest;
}

//TODO: 设置post方式的key-value.
-(void)addPostFieldWithKey:(NSString *)key value:(NSString *)value
{
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"tag",value,@"value", nil];
//    [soap_itemsArry addObject:dic];
}

-(void)dealloc
{
    [soap_xmlns_tag release];
    [soap_xmlns_space release];
    [soap_action release];
    
    [soap_itemsArry removeAllObjects];
    [soap_itemsArry release];
    [super dealloc];
}
@end
