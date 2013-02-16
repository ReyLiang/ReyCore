//
//  ReyCodeXML.h
//  ReyCodeXML
//
//  Created by 慧彬 梁 on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReyCodeXML : NSObject

//get @"key=value"
+(NSString *)ReyCodeXMLGetKeyAndValue:(NSString *)key withValue:(NSString *)value;

//get @"<tag>value</tag>"
+(NSString *)ReyCodeXMLGetSingleTag:(NSString *)tag withValue:(NSString *)value;

//get @"<xmlns:tag key=value .....>value</tag>"
+(NSString *)ReyCodeXMLGetTag:(NSString *)xmlns
                     withData:(NSDictionary *)data;

//get @"<tag>value
//<xmlns:subTag key=value>value</subTag>
//<xmlns:subTag key=value>value</subTag>
//<xmlns:subTag key=value>value</subTag>
//</tag>"
+(NSString *)ReyCodeXMLGetTagArray:(NSString *)tag 
                         withXmlns:(NSString *)xmlns
                      withArribute:(NSDictionary *)arributeDic 
                         withItems:(NSArray *)items;

+(NSMutableString *)ReyCodeXMLGetSOAPPostBodyWithAction:(NSString *)action 
                                          withXmlns_tag:(NSString *)xmlns_tag
                                        withXmlns_space:(NSString *)xmlns_space
                                           withPostBody:(NSArray *)postbody;

@end
