/*************************************************
 
 Copyright (C), 2012-2015, Rey mail=>rey0@qq.com.
 
 File name:	ReyShare_OneKeyStep.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/8/30
 
 Description:
 
 一键分享类.
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import <Foundation/Foundation.h>
#import "ReyShare.h"

@protocol ReyShare_OneKeyStepDelegate;

@interface ReyShare_OneKeyStep : NSObject
{
//    text => share message
//    image => share image data
//    url => share image url
//    log => longitude
//    lat => latitude
    NSDictionary * m_shareDic;
    
    id<ReyShare_OneKeyStepDelegate> delegate;
    
    //用户相关信息:用户名
    //和账号绑定
    NSString * m_userName;
    
    
    
    
    //================
    //private
    ReyShareEngineType m_OKSType;
    ReyShareEngineType m_faildType;
    
    
    UIView * m_superView;
    
    BOOL m_isAutoRel;
    
    
    ReyShareEngineType m_current;
    ReyShareEngineType m_noneShare;
    ReyShareEngine * m_currentEngine;
    
    
}

@property (nonatomic , retain) NSDictionary * m_shareDic;

@property (nonatomic , retain) NSString * m_userName;

@property (nonatomic , assign) id<ReyShare_OneKeyStepDelegate> delegate;


+(void)OneKeyStepShare:(ReyShareEngineType)singleType
         withSuperView:(UIView *)view
              delegate:(id<ReyShare_OneKeyStepDelegate>)adelegate
              username:(NSString *)username;

+(void)OneKeyStepShare:(ReyShareEngineType)type
         withSuperView:(UIView *)view
              sendData:(NSDictionary *)sendData
              delegate:(id<ReyShare_OneKeyStepDelegate>)adelegate
              username:(NSString *)username;

//deprecated
+(void)OneKeyStepShare:(ReyShareEngineType)type
         withSuperView:(UIView *)view
              sendData:(NSDictionary *)sendData
              delegate:(id<ReyShare_OneKeyStepDelegate>)adelegate;
@end

@protocol ReyShare_OneKeyStepDelegate <NSObject>

-(void)ReyShare_OneKeyStep_allFinished:(ReyShare_OneKeyStep *)sender faildType:(ReyShareEngineType)type;

-(void)ReyShare_OneKeyStep_finished:(ReyShare_OneKeyStep *)sender engine:(ReyShareEngine *)engine;

-(void)ReyShare_OneKeyStep_failed:(ReyShare_OneKeyStep *)sender engine:(ReyShareEngine *)engine error:(NSError *)error;

@end
