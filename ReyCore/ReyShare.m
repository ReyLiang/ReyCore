//
//  ReyShare.m
//  shareTeset
//
//  Created by 慧彬 梁 on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyShare.h"
#import "ReyShareEngine_sina.h"
#import "ReyShareEngine_QQ.h"
#import "ReyShareEngine_renren.h"
#import "ReyShareEngine_douban.h"

ReyShare * g_Share;

@interface ReyShare()


@property (nonatomic , retain) ReyShareEngine_sina * m_sina;
@property (nonatomic , retain) ReyShareEngine_QQ * m_qq;
@property (nonatomic , retain) ReyShareEngine_renren * m_renren;
@property (nonatomic , retain) ReyShareEngine_douban * m_douban;


-(ReyShareEngine_sina *)initSinaEngineWithAppkey:(NSString *)appkey
                                       appsecret:(NSString *)appsecret
                                     redirectURI:(NSString *)redirectURI;

-(ReyShareEngine_QQ *)initQQEngineWithAppkey:(NSString *)appkey
                                   appsecret:(NSString *)appsecret
                                 redirectURI:(NSString *)redirectURI;

-(ReyShareEngine_renren *)initRenrenEngineWithAppkey:(NSString *)appkey
                                           appsecret:(NSString *)appsecret
                                         redirectURI:(NSString *)redirectURI;

-(ReyShareEngine_douban *)initDoubanEngineWithAppkey:(NSString *)appkey
                                           appsecret:(NSString *)appsecret
                                         redirectURI:(NSString *)redirectURI;


@end

@implementation ReyShare


@synthesize m_sina;
@synthesize m_qq;
@synthesize m_renren;




+(ReyShare *)ReyShare
{
    if (!g_Share) {
        g_Share = [[ReyShare alloc] init];
    }
    return g_Share;
}

+(void)ReyShareRelese
{
    if (g_Share) {
        [g_Share release];
        g_Share = nil;
    }
}


#pragma mark -

+(ReyShareEngine *)GetEngineWithType:(ReyShareEngineType)type
{
    switch ((int)type) {
        case ReyShareEngineType_Sina:
        {
            return [ReyShare GetEngineWithRedirectURI:SINA_REDIRECT_URI
                                                 type:ReyShareEngineType_Sina];
        }
            
        case ReyShareEngineType_QQ:
        {
            return [ReyShare GetEngineWithRedirectURI:QQWB_REDIRECT_URI
                                                 type:ReyShareEngineType_QQ];
            
        }
        case ReyShareEngineType_Renren:
        {
            return [ReyShare GetEngineWithRedirectURI:RENREN_REDIRECT_URI
                                                 type:ReyShareEngineType_Renren];
            
        }
        case ReyShareEngineType_Douban:
        {
            return [ReyShare GetEngineWithRedirectURI:DOUBAN_REDIRECT_URI
                                                 type:ReyShareEngineType_Douban];
            
        }
    }
    return nil;
}


+(ReyShareEngine *)GetEngineWithAppkey:(NSString *)appkey
                             appsecret:(NSString *)appsecret
                           redirectURI:(NSString *)redirectURI
                                  type:(ReyShareEngineType)type
{
    if (!g_Share) {
        [ReyShare ReyShare];
    }
    
    switch ((int)type) {
        case ReyShareEngineType_Sina:
        {
            return [g_Share initSinaEngineWithAppkey:appkey
                                           appsecret:appsecret
                                         redirectURI:redirectURI];
        }
            
        case ReyShareEngineType_QQ:
        {
            return [g_Share initQQEngineWithAppkey:appkey
                                         appsecret:appsecret
                                       redirectURI:redirectURI];
        }
        case ReyShareEngineType_Renren:
        {
            return [g_Share initRenrenEngineWithAppkey:appkey
                                             appsecret:appsecret
                                           redirectURI:redirectURI];
        }
        case ReyShareEngineType_Douban:
        {
            return [g_Share initDoubanEngineWithAppkey:appkey
                                             appsecret:appsecret
                                           redirectURI:redirectURI];
        }

    }
    return nil;
    
    

}

+(ReyShareEngine *)GetEngineWithRedirectURI:(NSString *)redirectURI
                                       type:(ReyShareEngineType)type
{

    
    switch ((int)type) {
        case ReyShareEngineType_Sina:
        {
            return [ReyShare GetEngineWithAppkey:SINA_APPKEY
                                       appsecret:SINA_APPSECRET
                                     redirectURI:redirectURI
                                            type:ReyShareEngineType_Sina];
        }
            
        case ReyShareEngineType_QQ:
        {
            return [ReyShare GetEngineWithAppkey:QQWB_APPKEY
                                       appsecret:QQWB_APPSECRET
                                     redirectURI:redirectURI
                                            type:ReyShareEngineType_QQ];
            
        }
        case ReyShareEngineType_Renren:
        {
            return [ReyShare GetEngineWithAppkey:RENREN_APPKEY
                                       appsecret:RENREN_APPSECRET
                                     redirectURI:redirectURI
                                            type:ReyShareEngineType_Renren];

        }
        case ReyShareEngineType_Douban:
        {
            return [ReyShare GetEngineWithAppkey:DOUBAN_APPKEY
                                       appsecret:DOUBAN_APPSECRET
                                     redirectURI:redirectURI
                                            type:ReyShareEngineType_Douban];

        }
    }
    return nil;
    
    
    
}


#pragma mark -
#pragma mark share method

-(ReyShareEngine_sina *)initSinaEngineWithAppkey:(NSString *)appkey
                                       appsecret:(NSString *)appsecret
                                     redirectURI:(NSString *)redirectURI
{
    if (!m_sina) {
        m_sina = [[ReyShareEngine_sina alloc] initWithAppKey:appkey appSecret:appsecret redirectURI:redirectURI];
        m_sina.m_type = ReyShareEngineType_Sina;
    }
    
    return m_sina;
}

-(ReyShareEngine_QQ *)initQQEngineWithAppkey:(NSString *)appkey
                                   appsecret:(NSString *)appsecret
                                 redirectURI:(NSString *)redirectURI
{
    if (!m_qq) {
        m_qq = [[ReyShareEngine_QQ alloc] initWithAppKey:appkey appSecret:appsecret redirectURI:redirectURI];
        m_qq.m_type = ReyShareEngineType_QQ;
    }
    
    return m_qq;
}


-(ReyShareEngine_renren *)initRenrenEngineWithAppkey:(NSString *)appkey
                                           appsecret:(NSString *)appsecret
                                         redirectURI:(NSString *)redirectURI
{
    if (!m_renren) {
        m_renren = [[ReyShareEngine_renren alloc] initWithAppKey:appkey appSecret:appsecret redirectURI:redirectURI];
        m_renren.m_type = ReyShareEngineType_Renren;
    }
    
    return m_renren;
}


-(ReyShareEngine_douban *)initDoubanEngineWithAppkey:(NSString *)appkey
                                           appsecret:(NSString *)appsecret
                                         redirectURI:(NSString *)redirectURI
{
    if (!m_douban) {
        m_douban = [[ReyShareEngine_douban alloc] initWithAppKey:appkey appSecret:appsecret redirectURI:redirectURI];
        m_douban.m_type = ReyShareEngineType_Douban;
    }
    
    return m_douban;
}

#pragma mark -


-(id)init
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}


-(void)dealloc
{
    if (m_douban) {
        [m_douban release];
        m_douban = nil;
    }
    if (m_renren) {
        [m_renren release];
        m_renren = nil;
    }
    if (m_qq) {
        [m_qq release];
        m_qq = nil;
    }
    if (m_sina) {
        [m_sina release];
        m_sina = nil;
    }
    [super dealloc];
}

@end
