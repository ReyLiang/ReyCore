/*************************************************
 
 Copyright (C), 2012-2015, Rey mail=>rey0@qq.com.
 
 File name:	ReyShareEngine.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/8/13
 
 Description:
 
 分享处理基础模板类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import <Foundation/Foundation.h>

#import "JSON.h"
#import "SFHFKeychainUtils.h"
#import "ReyShareRequest.h"
#import "ReyShareView.h"
#import "ReyDownload.h"



#define ReyShareErrorDomain @"ReyShareErrorDomain"
#define ReyShareErrorDetailKey @"ReyShareErrorDetailKey"
#define ReyShareLocationNull -200000

typedef enum
{
	kShareErrorCodeAuthorize	= 100,
    kShareErrorCodeJSONParser	= 101,
    kShareErrorCodeRequest      = 102,
}ShareErrorCode;


@protocol ReyShareEngineDelegate;

@interface ReyShareEngine : NSObject
    <ReyDownloadDelegate>
{
    id<ReyShareEngineDelegate> delegate;
    
    NSString        * m_userName;
    
    //分享账户的用户名
    NSString        * m_shareName;
    
    NSString        * m_appKey;
    NSString        * m_appSecret;
    NSString        * m_redirectURI;
    
    NSString        * m_accessToken;
    NSTimeInterval   m_expireTime;
    
    UIView * m_superView;
    
    int m_type;
}

@property (nonatomic , assign) id<ReyShareEngineDelegate> delegate;

@property (nonatomic, retain) NSString        * m_userName;

@property (nonatomic, retain) NSString        * m_shareName;

@property (nonatomic, retain) NSString * m_appKey;
@property (nonatomic, retain) NSString * m_appSecret;
@property (nonatomic, retain) NSString * m_redirectURI;

@property (nonatomic, retain) NSString * m_accessToken;
@property (nonatomic, assign) NSTimeInterval  m_expireTime;


@property (nonatomic, assign) UIView * m_superView;

@property (nonatomic, assign) int m_type;

-(id)initWithAppKey:(NSString *)appkey
          appSecret:(NSString *)appsecret
        redirectURI:(NSString *)redirectURI;
-(void)login;
- (BOOL)isLoggedIn;
- (void)logOut;

-(void)loadRequestWithAPIURL:(NSString *)apiurl
                  MethodName:(NSString *)methodName
              httpMethodType:(ReyShareRequestMethodType)type
                      params:(NSDictionary *)params;



#pragma mark protected method


//为了流程的顺序性,不做多线程处理.
-(BOOL)refreshToken;

-(NSString *)getServicesName;

-(NSString *)getShareNameFromServers;

-(NSError *)hasError:(NSDictionary * )params;

-(NSDictionary *)getDictionaryFromParameter:(NSString *)parameter;

//only renren api used
-(void)sendShareWithDictionary:(NSMutableDictionary *)params;

-(void)sendShareWithText:(NSString *)text image:(UIImage *)image;

-(void)sendShareWithText:(NSString *)text
                   image:(UIImage *)image
               longitude:(double)longitude
                latitude:(double)latitude;

-(void)loadRequestWithMethodName:(NSString *)methodName
                  httpMethodType:(ReyShareRequestMethodType)type
                          params:(NSMutableDictionary *)params;


-(void)setOtherKeychain:(NSDictionary *)parameber;
- (void)readAuthorizeDataFromKeychain;
- (void)saveAuthorizeDataToKeychain;
- (void)deleteAuthorizeDataInKeychain;

@end


@protocol ReyShareEngineDelegate <NSObject>

@optional

// If you try to log in with logIn or logInUsingUserID method, and
// there is already some authorization info in the Keychain,
// this method will be invoked.
// You may or may not be allowed to continue your authorization,
// which depends on the value of isUserExclusive.
- (void)engineAlreadyLoggedIn:(ReyShareEngine *)engine;

// Log in successfully.
- (void)engineDidLogIn:(ReyShareEngine *)engine;

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(ReyShareEngine *)engine didFailToLogInWithError:(NSError *)error;

// Log out successfully.
- (void)engineDidLogOut:(ReyShareEngine *)engine;

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(ReyShareEngine *)engine;
- (void)engineAuthorizeExpired:(ReyShareEngine *)engine;

- (void)engine:(ReyShareEngine *)engine requestDidFailWithError:(NSError *)error;
- (void)engine:(ReyShareEngine *)engine requestDidSucceedWithResult:(id)result;
- (void)engine:(ReyShareEngine *)engine requestDidFinishedWithResult:(id)result;

@end
