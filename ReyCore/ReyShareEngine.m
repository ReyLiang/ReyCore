//
//  ReyShareEngine.m
//  shareTeset
//
//  Created by 慧彬 梁 on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyShareEngine.h"


@interface ReyShareEngine()
    <ReyShareViewDelegate>

-(void)initEngineData;


-(NSMutableURLRequest *)getLoginRequest;



@end

@implementation ReyShareEngine

//可以扩展
#define kShareKeychainServiceName    @"ShareServiceName"

#define kShareKeychainAccessToken          @"ShareAccessToken"
#define kShareKeychainExpireTime           @"ShareExpireTime"

#define kShareKeyAPIVesion @"1.0"

//授权url
//大部分都支持token方式,故只提供一个.豆瓣特殊对待
#define kShareOAuthURL   @""

//get new access_token
#define kShareRefreshToken @""
//api url
#define kShareAPIURL @""

//授权url
//大部分都支持token方式,故只提供一个.豆瓣特殊对待
#define kShareOAuthURL   @""
//api url
#define kShareAPIURL @""

@synthesize delegate;
@synthesize m_redirectURI,m_appKey,m_appSecret;
@synthesize m_accessToken,m_expireTime;

@synthesize m_userName;
@synthesize m_shareName;

@synthesize m_superView;
@synthesize m_type;

-(id)initWithAppKey:(NSString *)appkey
          appSecret:(NSString *)appsecret
        redirectURI:(NSString *)redirectURI
{
    self = [super init];
    if (self) {
        m_appKey = [appkey retain];
        m_appSecret = [appsecret retain];
        m_redirectURI = [redirectURI retain];
        
        [self initEngineData];
    }
    
    return self;
}

-(void)dealloc
{
    [m_shareName release];
    [m_userName release];
    
    if (m_accessToken) {
        [m_accessToken release];
        m_accessToken = nil;
    }
    
    [m_redirectURI release];
    [m_appKey release];
    [m_appSecret release];
    
    
    [super dealloc];
}

-(void)initEngineData
{
    [self readAuthorizeDataFromKeychain];
}


-(NSString *)getServicesName
{
    if (m_userName) {
        return [NSString stringWithFormat:@"%@%@",kShareKeychainServiceName,m_userName];
    }
    
    return kShareKeychainServiceName;
}

#pragma mark -
#pragma mark Login Method
-(void)login
{
//    if ([self isLoggedIn]) {
//        if ([delegate respondsToSelector:@selector(engineAlreadyLoggedIn:)])
//        {
//            [delegate engineAlreadyLoggedIn:self];
//        }
//        return;
//    }
    
    CGRect rect = CGRectMake(0, 0, m_superView.frame.size.width, m_superView.frame.size.height);
    
    ReyShareView * authView = [[ReyShareView alloc] initWithFrame:rect withRedirect:m_redirectURI];
    
    authView.delegate = self;
    
    [m_superView addSubview:authView];
    
    [authView loadShareRequest:[self getLoginRequest]];
    
    [authView release];
    
}

//刷新token
//为了流程的顺序性,不做多线程处理.
-(BOOL)refreshToken
{
    return NO;
}

- (void)logOut
{
    [self deleteAuthorizeDataInKeychain];
    
    if ([delegate respondsToSelector:@selector(engineDidLogOut:)])
    {
        [delegate engineDidLogOut:self];
    }
}

- (BOOL)isLoggedIn
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    if (now - m_expireTime >= 0 ) {
        
        
        if ([self refreshToken]) {
            [self saveAuthorizeDataToKeychain];
        }
        else
        {
            [self deleteAuthorizeDataInKeychain];
            if ([delegate respondsToSelector:@selector(engineAuthorizeExpired:)])
            {
                [delegate engineAuthorizeExpired:self];
            }
            return NO;
        }
        
        
        
    }
    
    //    return userID && accessToken && refreshToken;
    return m_accessToken && (m_expireTime > 0);
}

// get dic from k=v&k=v
-(NSDictionary *)getDictionaryFromParameter:(NSString *)parameter
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    NSArray * arry = [parameter componentsSeparatedByString:@"&"];
    
    for (NSString * item in arry) {
        NSArray * itemArry = [item componentsSeparatedByString:@"="];
        [dic setObject:[itemArry objectAtIndex:1] forKey:[itemArry objectAtIndex:0]];
    }
    
    return dic;
}

#pragma mark -
#pragma mark API Method

-(void)loadRequestWithAPIURL:(NSString *)apiurl
                  MethodName:(NSString *)methodName
              httpMethodType:(ReyShareRequestMethodType)type
                      params:(NSDictionary *)params
{

	if (![self isLoggedIn])
	{
        if ([delegate respondsToSelector:@selector(engineNotAuthorized:)])
        {
            [delegate engineNotAuthorized:self];
        }
        return;
	}
    
    NSString * url;
    if (methodName) {
        url = [NSString stringWithFormat:@"%@%@",apiurl,methodName];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@",apiurl];
    }
    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:url parameber:params method:type];
    
    [ReyDownload ReyDownloadWithDelegate:self request:request];
}


-(void)loadRequestWithMethodName:(NSString *)methodName
              httpMethodType:(ReyShareRequestMethodType)type
                      params:(NSMutableDictionary *)params
{
    [self loadRequestWithAPIURL:kShareOAuthURL
                     MethodName:methodName
                 httpMethodType:type
                         params:params];
}

-(void)sendShareWithDictionary:(NSMutableDictionary *)params
{
    
}
-(void)sendShareWithText:(NSString *)text image:(UIImage *)image
{
    
}

-(void)sendShareWithText:(NSString *)text
                   image:(UIImage *)image
               longitude:(double)longitude
                latitude:(double)latitude
{
    
}

#pragma mark -
#pragma mark ReyDownloadDelegate Method
-(void)DownloadFinished:(id)downloaded
{
    NSString * str = [[NSString alloc] initWithData:downloaded encoding:NSUTF8StringEncoding];
//    NSLog(str);
    SBJSON * jsonParser = [[SBJSON alloc]init];
    
    NSError *parseError = nil;
    id result = [[jsonParser objectWithString:str error:&parseError] retain];
    
    if (parseError) {
        NSError * err = [NSError errorWithDomain:ReyShareErrorDomain
                                            code:kShareErrorCodeJSONParser
                                        userInfo:[NSDictionary dictionaryWithObject:[parseError description]
                                                                             forKey:ReyShareErrorDetailKey]];
        
        if ([delegate respondsToSelector:@selector(engine:requestDidFailWithError:)]) {
            [delegate engine:self requestDidFailWithError:err];
        }
        
    }
    
    [jsonParser release];
    [str release];
    
    if ([result isKindOfClass:[NSDictionary class]])
	{
		
        NSError * err = [self hasError:result];
        if (err) {
            if ([delegate respondsToSelector:@selector(engine:requestDidFailWithError:)]) {
                [delegate engine:self requestDidFailWithError:err];
            }
        }
	}
    
    
    
    if ([delegate respondsToSelector:@selector(engine:requestDidFinishedWithResult:)]) {
        [delegate engine:self requestDidFinishedWithResult:result];
    }
    
    [result release];
}

-(NSError *)hasError:(NSDictionary * )params
{
    
    
    if ([params objectForKey:@"error_code"] != nil && [[params objectForKey:@"error_code"] intValue] != 200)
    {
        NSError * err = [NSError errorWithDomain:ReyShareErrorDomain
                                            code:kShareErrorCodeRequest
                                        userInfo:[NSDictionary dictionaryWithObject:[params objectForKey:@"error_code"]
                                                                             forKey:ReyShareErrorDetailKey]];
        
        return err;
    }
    
    return nil;
}

-(void)DownloadFailed:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(engine:requestDidFailWithError:)]) {
        [delegate engine:self requestDidFailWithError:error];
    }
}

//200为成功
-(void)didReceiveWithResponse:(NSHTTPURLResponse *)response
{
    int statusCode = [response statusCode];
    if (statusCode == 200) {
        if ([delegate respondsToSelector:@selector(engine:requestDidSucceedWithResult:)]) {
            [delegate engine:self requestDidSucceedWithResult:[NSNumber numberWithInt:statusCode]];
        }
    }
}


#pragma mark -
#pragma mark ReyShareViewDelegate Method

-(BOOL)ReyShareView:(ReyShareView *)sender faildWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(engine:didFailToLogInWithError:)])
    {
        NSError * err = [NSError errorWithDomain:ReyShareErrorDomain
                                            code:kShareErrorCodeAuthorize
                                        userInfo:[NSDictionary dictionaryWithObject:error forKey:ReyShareErrorDetailKey]];
        [delegate engine:self didFailToLogInWithError:err];
    }
    
    return YES;
}

-(BOOL)GetStringFromOauth:(ReyShareView *)shareView response:(NSString *)response navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSDictionary * dic = [self getDictionaryFromParameter:response];
    
    if ([dic objectForKey:@"access_token"]) {
        
        m_accessToken = [[[dic objectForKey:@"access_token"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
        m_expireTime = [[dic objectForKey:@"expires_in"] doubleValue] + [[NSDate date] timeIntervalSince1970];
        
        [self setOtherKeychain:dic];
        
        m_shareName = [[self getShareNameFromServers] retain];
        
        [self saveAuthorizeDataToKeychain];
        
        if ([delegate respondsToSelector:@selector(engineDidLogIn:)])
        {
            [delegate engineDidLogIn:self];
        }
    }
    else if([dic objectForKey:@"error"])
    {
        NSString *error = [dic objectForKey:@"error"];
        
        NSRange range = [error rangeOfString:@"denied"];
        
        //用户取消授权
        if (range.length) {
            
            return YES;
        }
        
        
        //unknow error
        if ([delegate respondsToSelector:@selector(engine:didFailToLogInWithError:)])
        {
            NSError * err = [NSError errorWithDomain:ReyShareErrorDomain
                                                code:kShareErrorCodeAuthorize
                                            userInfo:[NSDictionary dictionaryWithObject:error forKey:ReyShareErrorDetailKey]];
            [delegate engine:self didFailToLogInWithError:err];
        }
    }

    

    
    return YES;
}

-(NSString *)getShareNameFromServers
{
    return nil;
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
    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:kShareOAuthURL parameber:parameber method:ReyShareRequestMethodType_Get];
    
    return request;
}

#pragma mark -
#pragma mark Keychain Method


//TODO: can overwrite
//主要用于子类不同需求
-(void)setOtherKeychain:(NSDictionary *)parameber
{
    
}


- (void)readAuthorizeDataFromKeychain
{

    m_accessToken = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainAccessToken
                                                andServiceName:[self getServicesName]
                                                         error:nil] retain];
    
    m_expireTime = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainExpireTime andServiceName:[self getServicesName] error:nil] doubleValue];
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
    
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainAccessToken
                              andServiceName:[self getServicesName]
                                       error:nil];
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainExpireTime
                              andServiceName:[self getServicesName]
                                       error:nil];
}



@end
