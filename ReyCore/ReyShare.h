/************************************************* 
 
 Copyright (C), 2012-2015, Rey mail=>rey0@qq.com. 
 
 File name:	ReyShare.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/8/9
 
 Description: 
 
 分享整合类.
 目前只支持OAuth2.0的网页授权.
 
 类库配置:
 
     sina必须framework:
     Security.framework
 
 Others: 
 
 
 
 forShort：
 
 
 History:  

 
 
 *************************************************/ 

#import <Foundation/Foundation.h>
#import "ReyShareEngine.h"
#import "ReyShareKeys.h"

typedef enum {
    ReyShareEngineType_Sina = 0x1,
    ReyShareEngineType_QQ = 0x10,
    ReyShareEngineType_Douban = 0x100,
    ReyShareEngineType_Renren = 0x1000,
}ReyShareEngineType;

@class ReyShareEngine_sina;
@class ReyShareEngine_QQ;
@class ReyShareEngine_renren;
@class ReyShareEngine_douban;

@interface ReyShare : NSObject
{
    
    //================
    //private
    //sina
    ReyShareEngine_sina * m_sina;
    
    //QQ
    ReyShareEngine_QQ * m_qq;
    
    //renren
    ReyShareEngine_renren * m_renren;
    
    //douban
    ReyShareEngine_douban * m_douban;
}

+(ReyShare *)ReyShare;
+(void)ReyShareRelese;

+(ReyShareEngine *)GetEngineWithType:(ReyShareEngineType)type;

+(ReyShareEngine *)GetEngineWithAppkey:(NSString *)appkey
                             appsecret:(NSString *)appsecret
                           redirectURI:(NSString *)redirectURI
                                  type:(ReyShareEngineType)type;

+(ReyShareEngine *)GetEngineWithRedirectURI:(NSString *)redirectURI
                                       type:(ReyShareEngineType)type;



@end
