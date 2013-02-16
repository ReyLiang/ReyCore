//
//  ReyShareEngine_sina.m
//  shareTeset
//
//  Created by Rey on 12-8-15.
//
//

#import "ReyShareEngine_sina.h"

@implementation ReyShareEngine_sina




//可以扩展
#define kShareKeychainServiceName    @"ShareServiceName_Sina"

#define kShareKeychainUserID               @"ShareUserID_Sina"
#define kShareKeychainAccessToken          @"ShareAccessToken_Sina"
#define kShareKeychainExpireTime           @"ShareExpireTime_Sina"

//授权url
//大部分都支持token方式,故只提供一个.豆瓣特殊对待
#define kShareOAuthURL   @"https://api.weibo.com/oauth2/authorize"
//api url
#define kShareAPIURL @"https://api.weibo.com/2/"


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

-(void)loadRequestWithMethodName:(NSString *)methodName
                  httpMethodType:(ReyShareRequestMethodType)type
                          params:(NSMutableDictionary *)params
{
    [params setObject:self.m_accessToken forKey:@"access_token"];
    
    [self loadRequestWithAPIURL:kShareAPIURL
                     MethodName:methodName
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
        [params setObject:([NSString stringWithFormat:@"%f",longitude]) forKey:@"long"];
        [params setObject:([NSString stringWithFormat:@"%f",latitude]) forKey:@"lat"];
    }
    
    [params setObject:(text ? text : @"") forKey:@"status"];
    
    if (image) {
        [params setObject:image forKey:@"pic"];
        [self loadRequestWithMethodName:@"statuses/upload.json"
                         httpMethodType:ReyShareRequestMethodType_Multipart
                                 params:params];
    }
    else
    {
        [self loadRequestWithMethodName:@"statuses/update.json"
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
    [parameber setObject:@"mobile" forKey:@"display"];
    
    NSMutableURLRequest * request = [ReyShareRequest getRequestWithURL:kShareOAuthURL parameber:parameber method:ReyShareRequestMethodType_Get];
    
    return request;
}


//TODO: can overwrite
//主要用于子类不同需求
-(void)setOtherKeychain:(NSDictionary *)parameber
{
    m_userID = [[parameber objectForKey:@"uid"]retain];
}

-(NSString *)getShareNameFromServers
{
    NSString * url = [NSString stringWithFormat:@"%@users/show.json?access_token=%@&uid=%@",kShareAPIURL,m_accessToken,m_userID];
    

    NSString * str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    SBJSON * json = [[SBJSON alloc]init];
    
    NSDictionary * result = (NSDictionary *)[json objectWithString:str];
    
    [json release];
    
    NSString * name = [result objectForKey:@"name"];
    
    if (!name || [name isEqualToString:@""]) {
        return @" ";
    }
    
    return name;
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
