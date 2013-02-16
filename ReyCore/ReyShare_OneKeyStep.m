//
//  ReyShare_OneKeyStep.m
//  shareTeset
//
//  Created by Rey on 12-8-30.
//
//

#import "ReyShare_OneKeyStep.h"


@interface ReyShare_OneKeyStep()
    <ReyShareEngineDelegate>


@property (nonatomic , retain) UIView * m_superView;
@property (nonatomic , assign) ReyShareEngine * m_currentEngine;

-(id)initAutoReleaseWithType:(ReyShareEngineType)type  withSuperView:(UIView *)view;

-(void)initShare:(ReyShareEngineType)type  withSuperView:(UIView *)view;
-(void)startShare:(ReyShareEngineType)type;
-(void)allFinished;

@end





@implementation ReyShare_OneKeyStep


@synthesize m_superView;
@synthesize m_currentEngine;
@synthesize m_shareDic;
@synthesize delegate;
@synthesize m_userName;

//单独登陆接口
+(void)OneKeyStepShare:(ReyShareEngineType)singleType
         withSuperView:(UIView *)view
              delegate:(id<ReyShare_OneKeyStepDelegate>)adelegate
              username:(NSString *)username
{
    ReyShare_OneKeyStep * autoRel = [[ReyShare_OneKeyStep alloc] initAutoReleaseWithType:singleType withSuperView:view];
    
    autoRel.delegate = adelegate;
    autoRel.m_userName = [username retain];
    [autoRel startShare:singleType];
}

+(void)OneKeyStepShare:(ReyShareEngineType)type
         withSuperView:(UIView *)view
              sendData:(NSDictionary *)sendData
              delegate:(id<ReyShare_OneKeyStepDelegate>)adelegate
              username:(NSString *)username
{
    ReyShare_OneKeyStep * autoRel = [[ReyShare_OneKeyStep alloc] initAutoReleaseWithType:type withSuperView:view];
    
    autoRel.m_shareDic = [sendData retain];
    autoRel.delegate = adelegate;
    autoRel.m_userName = [username retain];
    [autoRel startShare:type];
}

//deprecated
+(void)OneKeyStepShare:(ReyShareEngineType)type
         withSuperView:(UIView *)view
              sendData:(NSDictionary *)sendData
              delegate:(id<ReyShare_OneKeyStepDelegate>)adelegate
{
    ReyShare_OneKeyStep * autoRel = [[ReyShare_OneKeyStep alloc] initAutoReleaseWithType:type withSuperView:view];

    autoRel.m_shareDic = [sendData retain];
    autoRel.delegate = adelegate;
    
    [autoRel startShare:type];
}

-(id)initWithType:(ReyShareEngineType)type withSuperView:(UIView *)view
{
    self = [super init];
    
    if (self) {
        
        [self initShare:type withSuperView:view];
        
    }
    
    return self;
}

-(id)initAutoReleaseWithType:(ReyShareEngineType)type withSuperView:(UIView *)view
{
    self = [super init];
    
    if (self) {
        m_isAutoRel = YES;
        [self initShare:type withSuperView:view];
        
    }
    
    return self;
}

-(void)dealloc
{
    [m_userName release];
    [m_shareDic release];
    [m_superView release];
    [super dealloc];
}

-(void)initShare:(ReyShareEngineType)type  withSuperView:(UIView *)view
{
    m_OKSType = type;
    m_current = 0;
    m_noneShare = m_OKSType;
    
    if (view) {
        m_superView = [view retain];
        
    }
    else //get local view
    {
        UIView * windows = [[UIApplication sharedApplication] keyWindow];
        m_superView = [[[windows subviews] objectAtIndex:0] retain];
    }
    
    
//    [self startShare:type];
}


-(void)startShare:(ReyShareEngineType)type
{

    if (type & ReyShareEngineType_Sina) {
        
        m_currentEngine = [ReyShare GetEngineWithType:ReyShareEngineType_Sina];
        m_currentEngine.delegate = self;
        
    }
    else if (type & ReyShareEngineType_QQ) {
        
        m_currentEngine = [ReyShare GetEngineWithType:ReyShareEngineType_QQ];
        m_currentEngine.delegate = self;
        
    }
    else if (type & ReyShareEngineType_Renren) {
        
        m_currentEngine = [ReyShare GetEngineWithType:ReyShareEngineType_Renren];
        m_currentEngine.delegate = self;
        
    }
    else if (type & ReyShareEngineType_Douban) {
        
        m_currentEngine = [ReyShare GetEngineWithType:ReyShareEngineType_Douban];
        m_currentEngine.delegate = self;
        
    }
    
    if (m_currentEngine) {
        
        m_current = m_current|m_currentEngine.m_type;
        
        
        if (!m_shareDic) {//只登陆授权
            m_currentEngine.m_superView = m_superView;
            [m_currentEngine login];
        }
        else
        {
            
            if ([m_currentEngine isLoggedIn]) {
                
                
                [self shareText:m_currentEngine.m_type];
                
            }
            else
            {
                m_currentEngine.m_superView = m_superView;
                [m_currentEngine login];
            }
        }

    }
    else //completed
    {
        
    }
}

-(void)onMainThreadShareText:(NSNumber *)number
{
    [self startShare:[number intValue]];
}

-(void)shareText:(ReyShareEngineType)type
{
    m_noneShare = m_noneShare & ~type;
//    NSLog(@"\nm_noneShare  %d\n",m_noneShare);
    switch ((int)type) {
        case ReyShareEngineType_Sina:
        {
            [m_currentEngine sendShareWithText:[m_shareDic objectForKey:@"text"]
                                         image:[m_shareDic objectForKey:@"image"]];
            break;
        }
            
        case ReyShareEngineType_QQ:
        {
            [m_currentEngine sendShareWithText:[m_shareDic objectForKey:@"text"]
                                         image:[m_shareDic objectForKey:@"image"]];
            break;
        }
        case ReyShareEngineType_Renren:
        {
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            [params setObject:@"芝士青年" forKey:@"name"];
            [params setObject:@"http://www.cheeseyouth.com" forKey:@"url"];
            [params setObject:[m_shareDic objectForKey:@"text"] forKey:@"description"];
            [params setObject:[m_shareDic objectForKey:@"url"] forKey:@"image"];
            
            
            [m_currentEngine sendShareWithDictionary:params];
            break;
        }
        case ReyShareEngineType_Douban:
        {
            [m_currentEngine sendShareWithText:[m_shareDic objectForKey:@"text"]
                                         image:[m_shareDic objectForKey:@"image"]];
            break;
        }
            
    }
}

-(void)allFinished
{
    if (m_current == m_OKSType) {
        if ([delegate respondsToSelector:@selector(ReyShare_OneKeyStep_allFinished:faildType:)]) {
            [delegate ReyShare_OneKeyStep_allFinished:self faildType:m_faildType];
        }
        if (m_isAutoRel) {
            [self release];
        }
    }
    else{
        [self performSelectorOnMainThread:@selector(onMainThreadShareText:)
                               withObject:[NSNumber numberWithInt:m_noneShare]
                            waitUntilDone:NO];
    }
    
}



#pragma mark -
#pragma mark ReyShareEngineDelegate
- (void)engineAlreadyLoggedIn:(ReyShareEngine *)engine
{
    
}

// Log in successfully.
- (void)engineDidLogIn:(ReyShareEngine *)engine
{
    if (!m_shareDic) {
        if ([delegate respondsToSelector:@selector(ReyShare_OneKeyStep_finished:engine:)]) {
            [delegate ReyShare_OneKeyStep_finished:self engine:m_currentEngine];
        }
        [self allFinished];
    }
    else
    {
        [self shareText:m_currentEngine.m_type];
    }

}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(ReyShareEngine *)engine didFailToLogInWithError:(NSError *)error
{
    m_faildType = m_faildType | engine.m_type;
    
    if ([delegate respondsToSelector:@selector(ReyShare_OneKeyStep_failed:engine:error:)]) {
        [delegate ReyShare_OneKeyStep_failed:self engine:m_currentEngine error:error];
    }
    
    [self allFinished];
}

// Log out successfully.
- (void)engineDidLogOut:(ReyShareEngine *)engine
{
    
}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(ReyShareEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(ReyShareEngine *)engine
{
    
}

- (void)engine:(ReyShareEngine *)engine requestDidFailWithError:(NSError *)error
{
    
    m_faildType = m_faildType | engine.m_type;
    
    
    if ([delegate respondsToSelector:@selector(ReyShare_OneKeyStep_failed:engine:error:)]) {
        [delegate ReyShare_OneKeyStep_failed:self engine:m_currentEngine error:error];
    }
    

}

- (void)engine:(ReyShareEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([delegate respondsToSelector:@selector(ReyShare_OneKeyStep_finished:engine:)]) {
        [delegate ReyShare_OneKeyStep_finished:self engine:m_currentEngine];
    }
    
    
}

- (void)engine:(ReyShareEngine *)engine requestDidFinishedWithResult:(id)result
{
    [self allFinished];
}

#pragma mark -
@end
