//
//  ReyShareEngine_douban.m
//  shareTeset
//
//  Created by Rey on 12-8-17.
//
//

#import "ReyShareEngine_douban.h"


@interface ReyShareEngine_douban()

-(NSDictionary *)GetAccessTokenWithCode:(NSString *)code;

@end

@implementation ReyShareEngine_douban
//可以扩展
#define kShareKeychainServiceName    @"ShareServiceName_douban"


#define kShareKeychainAccessToken           @"ShareAccessToken_douban"
#define kShareKeychainExpireTime            @"ShareExpireTime_douban"
#define kShareKeychainUserID               @"ShareUserID_douban"


//授权url
//大部分都支持token方式,故只提供一个.豆瓣特殊对待
#define kShareOAuthURL   @"https://www.douban.com/service/auth2/auth"

#define kShareGetAccessToken @"https://www.douban.com/service/auth2/token"
//api url
#define kShareAPIURL @"https://api.douban.com/"

#define kShareGetIPURL @"https://services.cheeseyouth.com/client/ip"


@synthesize m_userID;

-(void)dealloc
{
    [m_userID release];
    [super dealloc];
}

-(NSString *)getServicesName
{
    if (m_userName) {
        return [NSString stringWithFormat:@"%@%@",kShareKeychainServiceName,m_userName];
    }
    
    return kShareKeychainServiceName;
}

- (BOOL)isLoggedIn
{
    return m_userID && [super isLoggedIn];
}


-(NSError *)hasError:(NSDictionary * )params
{
    
    
    if ([params objectForKey:@"code"] != nil)
    {
        NSError * err = [NSError errorWithDomain:ReyShareErrorDomain
                                            code:kShareErrorCodeRequest
                                        userInfo:[NSDictionary dictionaryWithObject:[params objectForKey:@"code"]
                                                                             forKey:ReyShareErrorDetailKey]];
        
        return err;
    }
    
    return nil;
}


-(void)sendShareWithText:(NSString *)text image:(UIImage *)image
{
    [self sendShareWithText:text image:image longitude:ReyShareLocationNull latitude:ReyShareLocationNull];
}


-(void)sendShareWithText:(NSString *)text image:(UIImage *)image longitude:(double)longitude latitude:(double)latitude
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if (longitude != ReyShareLocationNull && latitude !=ReyShareLocationNull) {
        [params setObject:([NSString stringWithFormat:@"%f",longitude]) forKey:@"long"];
        [params setObject:([NSString stringWithFormat:@"%f",latitude]) forKey:@"lat"];
    }
    
    [params setObject:(text ? text : @"") forKey:@"text"];
    
    if (image) {
        [params setObject:image forKey:@"image"];
        [self loadRequestWithMethodName:@"shuo/statuses/"
                         httpMethodType:ReyShareRequestMethodType_Multipart
                                 params:params];
    }
    else
    {
        [self loadRequestWithMethodName:@"shuo/statuses/"
                         httpMethodType:ReyShareRequestMethodType_Post
                                 params:params];
    }
}

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
    

    [request setValue:[NSString stringWithFormat:@"Bearer %@",m_accessToken] forHTTPHeaderField:@"Authorization"];

 
    
    [ReyDownload ReyDownloadWithDelegate:self request:request];
    
    
}


-(void)loadRequestWithMethodName:(NSString *)methodName
                  httpMethodType:(ReyShareRequestMethodType)type
                          params:(NSMutableDictionary *)params
{
    
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
    [parameber setObject:@"code" forKey:@"response_type"];
    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:kShareOAuthURL parameber:parameber method:ReyShareRequestMethodType_Get];
    
    return request;
}

-(NSDictionary *)GetAccessTokenWithCode:(NSString *)code
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:m_appKey forKey:@"client_id"];
    [params setObject:m_appSecret forKey:@"client_secret"];
    [params setObject:m_redirectURI forKey:@"redirect_uri"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [params setObject:code forKey:@"code"];
    
    NSMutableURLRequest * request =[ReyShareRequest getRequestWithURL:kShareGetAccessToken
                                                            parameber:params
                                                               method:ReyShareRequestMethodType_Post];
    
    NSURLResponse * resp = nil;
    NSError * error = nil;
    NSData * data =[NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    NSString * str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    SBJSON * json = [[SBJSON alloc] init];
    
    NSDictionary * result = [json objectWithString:str];
    
    [json release];
    
    
    return result;
}

-(BOOL)GetStringFromOauth:(ReyShareView *)shareView response:(NSString *)response navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSDictionary * dic = [self getDictionaryFromParameter:response];
    
    if ([dic objectForKey:@"code"]) {
        
        NSDictionary * result = [self GetAccessTokenWithCode:[dic objectForKey:@"code"]];
        if([result objectForKey:@"access_token"])
        {
            m_accessToken = [[[result objectForKey:@"access_token"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain];
            m_expireTime = [[result objectForKey:@"expires_in"] doubleValue] + [[NSDate date] timeIntervalSince1970];
            
            [self setOtherKeychain:result];
            
            m_shareName = [[self getShareNameFromServers] retain];
            
            [self saveAuthorizeDataToKeychain];
            
            if ([delegate respondsToSelector:@selector(engineDidLogIn:)])
            {
                [delegate engineDidLogIn:self];
            }
        }
        else if([result objectForKey:@"error"])
        {
            NSString *error = [result objectForKey:@"error"];
            
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
        
        
    }
    
    
    
    
    return YES;
}


-(NSString *)getShareNameFromServers
{

    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:@"https://api.douban.com/v2/user/~me"
                                                             parameber:nil
                                                                method:ReyShareRequestMethodType_Get];
    [request setValue:[NSString stringWithFormat:@"Bearer %@",m_accessToken] forHTTPHeaderField:@"Authorization"];
    
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString * str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    SBJSON * json = [[SBJSON alloc]init];
    
    NSDictionary * result = (NSDictionary *)[json objectWithString:str];
    
    [json release];
    
    NSString * code = [result objectForKey:@"code"];
    
    if (code) {
        return @" ";
    }
    
    return [result objectForKey:@"name"];

}


//TODO: can overwrite
//主要用于子类不同需求
-(void)setOtherKeychain:(NSDictionary *)parameber
{
    m_userID = [[parameber objectForKey:@"douban_user_id"]retain];
}


#pragma mark -
#pragma mark Keychain Method

- (void)readAuthorizeDataFromKeychain
{
    
    m_userID = [[SFHFKeychainUtils getPasswordForUsername:kShareKeychainUserID
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
    
	[SFHFKeychainUtils storeUsername:kShareKeychainUserID
                         andPassword:m_userID
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
    
    [m_userID release];
    m_userID = nil;
    
    [m_accessToken release];
    m_accessToken = nil;
    
    m_expireTime = 0;
    
    
	[SFHFKeychainUtils deleteItemForUsername:kShareKeychainAccessToken
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
