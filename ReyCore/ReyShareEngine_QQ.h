//
//  ReyShareEngine_QQ.h
//  shareTeset
//
//  Created by Rey on 12-8-16.
//
//

#import "ReyShareEngine.h"

@interface ReyShareEngine_QQ : ReyShareEngine
{
    NSString * m_openid;
    NSString * m_openkey;
    NSString * m_refresh_token;
    NSString * m_name;
    NSString * m_nick;
}
@property (nonatomic , retain) NSString * m_openid;
@property (nonatomic , retain) NSString * m_openkey;
@property (nonatomic , retain) NSString * m_refresh_token;
@property (nonatomic , retain) NSString * m_name;
@property (nonatomic , retain) NSString * m_nick;
@end
