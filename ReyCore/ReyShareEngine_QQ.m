//
//  ReyShareEngine_QQ.m
//  shareTeset
//
//  Created by Rey on 12-8-16.
//
//

#import "ReyShareEngine_QQ.h"

@implementation ReyShareEngine_QQ

//可以扩展
#define kShareKeychainServiceName    @"ShareServiceName_QQ"


#define kShareKeychainAccessToken           @"ShareAccessToken_QQ"
#define kShareKeychainExpireTime            @"ShareExpireTime_QQ"
#define kShareKeychainOpenid                @"ShareOpenid_QQ"
#define kShareKeychainOpenKey               @"ShareOpenKey_QQ"
#define kShareKeychainName                  @"ShareName_QQ"
#define kShareKeychainNick                  @"ShareNick_QQ"
#define kShareKeychainRefreshToken          @"ShareRefreshToken_QQ"

#define kShareKeyAPIVesion @"2.a"

//授权url
//大部分都支持token方式,故只提供一个.豆瓣特殊对待
#define kShareOAuthURL   @"https://open.t.qq.com/cgi-bin/oauth2/authorize"

#define kShareRefreshToken @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
//api url 
#define kShareAPIURL @"https://open.t.qq.com/api/"

#define kShareGetIPURL @"https://services.cheeseyouth.com/client/ip"




@synthesize m_openid,m_openkey,m_name,m_nick,m_refresh_token;

-(NSString *)getIP
{
    NSString * url = [NSString stringWithFormat:@"%@",kShareGetIPURL];
    
    NSString * jsonIp = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    SBJSON * json = [[SBJSON alloc]init];
    
    NSDictionary * result = (NSDictionary *)[json objectWithString:jsonIp];
    
    return [result objectForKey:@"address"];
}

//为了流程的顺序性,不做多线程处理.
-(BOOL)refreshToken
{
    BOOL hasRefresh = NO;
    NSString * url =[NSString stringWithFormat:@"%@?client_id=%@&grant_type=refresh_token&refresh_token=%@",kShareRefreshToken,self.m_appKey,self.m_refresh_token];
    NSString * refresh = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary * result = [self getDictionaryFromParameter:refresh];
    
    if (![result objectForKey:@"errorCode"]) {
        self.m_accessToken = [result objectForKey:@"access_token"];
        self.m_expireTime = [[result objectForKey:@"expires_in"] doubleValue] + [[NSDate date] timeIntervalSince1970];
        self.m_refresh_token = [result objectForKey:@"refresh_token"];
        self.m_name = [result objectForKey:@"name"];
        self.m_nick = [result objectForKey:@"nick"];
        
        hasRefresh = YES;
    }
    
    
    return hasRefresh;
}

-(void)dealloc
{
    [m_openid release];
    [m_openkey release];
    [m_name release];
    [m_nick release];
    [m_refresh_token release];
    [super dealloc];
}

-(NSString *)getServicesName
{
    if (m_userName) {
        return [NSString stringWithFormat:@"%@%@",kShareKeychainServiceName,m_userName];
    }
    
    return kShareKeychainServiceName;
}

-(NSString *)getShareNameFromServers
{
    if (!m_nick || [m_nick isEqualToString:@""]) {
        return @" ";
    }
    
    return m_nick;
}


- (BOOL)isLoggedIn
{
    return m_openid && m_openkey && m_refresh_token && [super isLoggedIn];
}


-(NSError *)hasError:(NSDictionary * )params
{
    if ([params objectForKey:@"errcode"] != nil && [[params objectForKey:@"errcode"] intValue] != 0)
    {
        NSError * err = [NSError errorWithDomain:ReyShareErrorDomain
                                            code:kShareErrorCodeRequest
                                        userInfo:[NSDictionary dictionaryWithObject:[params objectForKey:@"errcode"]
                                                                             forKey:ReyShareErrorDetailKey]];
        
        return err;
    }
    
    return nil;
}

-(void)loadRequestWithMethodName:(NSString *)methodName
                  httpMethodType:(ReyShareRequestMethodType)type
                          params:(NSMutableDictionary *)params
{
    
    NSMutableDictionary * commDic = [NSMutableDictionary dictionary];
    [commDic setObject:self.m_accessToken forKey:@"access_token"];
    [commDic setObject:self.m_appKey forKey:@"oauth_consumer_key"];
    [commDic setObject:self.m_openid forKey:@"openid"];
    [commDic setObject:[self getIP] forKey:@"clientip"];
    [commDic setObject:kShareKeyAPIVesion forKey:@"oauth_version"];
    [commDic setObject:@"all" forKey:@"scope"];
    
    NSString * commStr =[ReyShareRequest getStringFromParemeber:commDic];
    
    [params setObject:@"json" forKey:@"format"];
    
    [self loadRequestWithAPIURL:kShareAPIURL
                     MethodName:[NSString stringWithFormat:@"%@?%@",methodName,commStr]
                 httpMethodType:type
                         params:params];
}

-(void)sendShareWithText:(NSString *)text image:(UIImage *)image
{
    [self sendShareWithText:text image:image longitude:ReyShareLocationNull latitude:ReyShareLocationNull];
}


-(void)sendShareWithText:(NSString *)text image:(UIImage *)image longitude:(double)longitude latitude:(double)latitude
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if (longitude != ReyShareLocationNull && latitude !=ReyShareLocationNull) {
        [params setObject:([NSString stringWithFormat:@"%f",longitude]) forKey:@"longitude"];
        [params setObject:([NSString stringWithFormat:@"%f",latitude]) forKey:@"latitude"];
    }
    
    [params setObject:(text ? text : @"") forKey:@"content"];
    
    if (image) {
        [params setObject:image forKey:@"pic"];
        [self loadRequestWithMethodName:@"t/add_pic"
                         httpMethodType:ReyShareRequestMethodType_Multipart
                                 params:params];
    }
    else
    {
        [self loadRequestWithMethodName:@"t/add"
                         httpMethodType:ReyShareRequestMethodType_Post
                                 params:params];
    }
}


#pragma mark -
#pragma mark Request Method
#pragma mark Can overwrite



-(NSMutableURLRequest *)getLoginRequest
{
    
    NSMutableDictionary * parameber = [NSMutableDictionary dictionary];
    [parameber setObject:m_appKey forKey:@"client_id"];
    [parameber setObject:m_redirectURI forKey:@"redirect_uri"];
    [parameber setObject:@"token" forKey:@"response_type"];
    [parameber setObject:@"2" forKey:@"wap"];
    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:kShareOAuthURL parameber:parameber method:ReyShareRequestMethodType_Get];
    
    return request;
}


//TODO: can overwrite
//主要用于子类不同需求
-(void)setOtherKeychain:(NSDictionary *)parameber
{
    m_openid = [[[parameber objectForKey:@"openid"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]retain];
    m_openkey = [[[parameber objectForKey:@"openkey"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]retain];
    m_name = [[parameber objectForKey:@"name"]retain];
    m_nick = [[[parameber objectForKey:@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]retain];
    m_refresh_token = [[[parameber objectForKey:@"refresh_token"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]retain];
}


#pragma mark -
#pragma mark Keychain Method

- (void)readAuthorizeDataFromKeychain
{
    
    m_refresh_token = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainRefreshToken
                                                  andServiceName:[self getServicesName]
                                                           error:nil] retain];
    
    m_openid = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainOpenid
                                           andServiceName:[self getServicesName]
                                                    error:nil] retain];
    m_openkey = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainOpenKey
                                            andServiceName:[self getServicesName]
                                                     error:nil] retain];
    m_name = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainName
                                         andServiceName:[self getServicesName]
                                                  error:nil] retain];
    m_nick = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainNick
                                         andServiceName:[self getServicesName]
                                                  error:nil] retain];
    
    
    m_accessToken = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainAccessToken
                                                andServiceName:[self getServicesName]
                                                         error:nil] retain];
    
    m_expireTime = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainExpireTime
                                               andServiceName:[self getServicesName]
                                                        error:nil] doubleValue];
    
    
}

- (void)saveAuthorizeDataToKeychain
{
    
	[SFHFKeychainUtils storeUsername:kShareKeychainRefreshToken
                         andPassword:m_refresh_token
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
    [SFHFKeychainUtils storeUsername:kShareKeychainOpenid
                         andPassword:m_openid
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
    [SFHFKeychainUtils storeUsername:kShareKeychainOpenKey
                         andPassword:m_openkey
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
    [SFHFKeychainUtils storeUsername:kShareKeychainName
                         andPassword:m_name
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
    [SFHFKeychainUtils storeUsername:kShareKeychainNick
                         andPassword:m_nick
                      forServiceName:[self getServicesName]
                      updateExisting:YES
                               error:nil];
    
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
    

    [m_openid release];
    m_openid = nil;
    
    [m_openkey release];
    m_openkey = nil;
    
    [m_name release];
    m_name = nil;
    
    [m_nick release];
    m_nick = nil;
    
    [m_refresh_token release];
    m_refresh_token = nil;
    
    [m_accessToken release];
    m_accessToken = nil;
    
    m_expireTime = 0;
    
    
    [SFHFKeychainUtils deleteItemForUsername:kShareKeychainOpenid
                              andServiceName:[self getServicesName]
                                       error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kShareKeychainOpenKey
                              andServiceName:[self getServicesName]
                                       error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kShareKeychainName
                              andServiceName:[self getServicesName]
                                       error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kShareKeychainNick
                              andServiceName:[self getServicesName]
                                       error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kShareKeychainRefreshToken
                              andServiceName:[self getServicesName]
                                       error:nil];
    
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainExpireTime
                              andServiceName:[self getServicesName]
                                       error:nil];
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainAccessToken
                              andServiceName:[self getServicesName]
                                       error:nil];
    
    
	
}


@end
