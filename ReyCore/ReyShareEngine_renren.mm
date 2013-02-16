//
//  ReyShareEngine_renren.m
//  shareTeset
//
//  Created by Rey on 12-8-17.
//
//

#import "ReyShareEngine_renren.h"

#import "ReyMD5.h"

@interface ReyShareEngine_renren()

- (NSString *)generateSig:(NSMutableDictionary *)paramsDict secretKey:(NSString *)secretKey;

@end

@implementation ReyShareEngine_renren


//可以扩展
#define kShareKeychainServiceName    @"ShareServiceName_renren"


#define kShareKeychainAccessToken           @"ShareAccessToken_renren"
#define kShareKeychainExpireTime            @"ShareExpireTime_renren"

#define kShareKeyAPIVesion @"1.0"

//授权url
//大部分都支持token方式,故只提供一个.豆瓣特殊对待
#define kShareOAuthURL   @"https://graph.renren.com/oauth/authorize"

#define kShareRefreshToken @""
//api url
#define kShareAPIURL @"http://api.renren.com/restserver.do"



-(NSString *)getServicesName
{
    if (m_userName) {
        return [NSString stringWithFormat:@"%@%@",kShareKeychainServiceName,m_userName];
    }
    
    return kShareKeychainServiceName;
}



- (NSString *)generateSig:(NSMutableDictionary *)paramsDict secretKey:(NSString *)secretKey{
    NSMutableString* joined = [NSMutableString string];
	NSArray* keys = [paramsDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (id obj in [keys objectEnumerator]) {
		id value = [paramsDict valueForKey:obj];
		if ([value isKindOfClass:[NSString class]]) {
			[joined appendString:obj];
			[joined appendString:@"="];
			[joined appendString:value];
		}
	}
	[joined appendString:secretKey];
	return [ReyMD5 getMD5WithString:joined];
}



-(void)sendShareWithDictionary:(NSMutableDictionary *)params
{
    [params setObject:@"feed.publishFeed" forKey:@"method"];
    
    [self loadRequestWithMethodName:nil
                     httpMethodType:ReyShareRequestMethodType_Post
                             params:params];
}






-(void)loadRequestWithMethodName:(NSString *)methodName
                  httpMethodType:(ReyShareRequestMethodType)type
                          params:(NSMutableDictionary *)params
{
    [params setObject:self.m_accessToken forKey:@"access_token"];
    [params setObject:kShareKeyAPIVesion forKey:@"v"];
    [params setObject:@"JSON" forKey:@"format"];
    
    NSString * sig =[self generateSig:params secretKey:m_appSecret];
    
    [params setObject:sig forKey:@"sig"];
    
    [self loadRequestWithAPIURL:kShareAPIURL
                     MethodName:methodName
                 httpMethodType:type
                         params:params];
}


-(NSMutableURLRequest *)getLoginRequest
{
    
    NSMutableDictionary * parameber = [NSMutableDictionary dictionary];
    [parameber setObject:m_appKey forKey:@"client_id"];
    [parameber setObject:m_redirectURI forKey:@"redirect_uri"];
    [parameber setObject:@"token" forKey:@"response_type"];
    [parameber setObject:@"publish_feed,status_update,publish_share,photo_upload" forKey:@"scope"];

    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:kShareOAuthURL parameber:parameber method:ReyShareRequestMethodType_Get];
    
    return request;
}


//TODO: can overwrite
//主要用于子类不同需求
-(void)setOtherKeychain:(NSDictionary *)parameber
{

}

-(NSString *)getShareNameFromServers
{
    

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"users.getInfo" forKey:@"method"];
    [params setObject:self.m_accessToken forKey:@"access_token"];
    [params setObject:kShareKeyAPIVesion forKey:@"v"];
    [params setObject:@"JSON" forKey:@"format"];
    
    NSString * sig =[self generateSig:params secretKey:m_appSecret];
    
    [params setObject:sig forKey:@"sig"];
    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:kShareAPIURL
                                                             parameber:params
                                                                method:ReyShareRequestMethodType_Post];
    
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString * str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    SBJSON * json = [[SBJSON alloc]init];
    
    NSArray * result  = (NSArray *)[json objectWithString:str];
    
    NSDictionary * dic = [result objectAtIndex:0];
    
    [json release];

    return [dic objectForKey:@"name"];
}



#pragma mark -
#pragma mark Keychain Method

- (void)readAuthorizeDataFromKeychain
{
    
    
    
    m_accessToken = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainAccessToken
                                                andServiceName:[self getServicesName]
                                                         error:nil] retain];
    
    m_expireTime = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainExpireTime
                                               andServiceName:[self getServicesName]
                                                        error:nil] doubleValue];
    
    
}

- (void)saveAuthorizeDataToKeychain
{
    

    
    [SFHFKeychainUtils storeUsername:kShareKeychainAccessToken
                         andPassword:m_accessToken
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
    
	[SFHFKeychainUtils storeUsername:kShareKeychainExpireTime
                         andPassword:[NSString stringWithFormat:@"%lf", m_expireTime]
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
}

- (void)deleteAuthorizeDataInKeychain
{
    

    
    [m_accessToken release];
    m_accessToken = nil;
    
    m_expireTime = 0;
    
    
    
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainExpireTime
                              andServiceName:[self getServicesName]
                                       error:nil];
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainAccessToken
                              andServiceName:[self getServicesName]
                                       error:nil];
    
    
    
    //清除缓存
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* graphCookies = [cookies cookiesForURL:
                             [NSURL URLWithString:@"http://graph.renren.com"]];
	
	for (NSHTTPCookie* cookie in graphCookies) {
		[cookies deleteCookie:cookie];
	}
	NSArray* widgetCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://widget.renren.com"]];
	
	for (NSHTTPCookie* cookie in widgetCookies) {
		[cookies deleteCookie:cookie];
	}
    
    
	
}


@end
