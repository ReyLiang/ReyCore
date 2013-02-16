//
//  ReyCodeXML.m
//  ReyCodeXML
//
//  Created by 慧彬 梁 on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyCodeXML.h"

@implementation ReyCodeXML

//get @"key=value"
+(NSString *)ReyCodeXMLGetKeyAndValue:(NSString *)key withValue:(NSString *)value
{
    NSMutableString * str = [[[NSMutableString alloc] init] autorelease];
    
    [str appendFormat:@" %@=%@ ",key,value];
    return str;
}

//get @"<tag>value</tag>"
+(NSString *)ReyCodeXMLGetSingleTag:(NSString *)tag withValue:(NSString *)value
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tag,@"tag",value,@"value", nil];
    return [ReyCodeXML ReyCodeXMLGetTag:nil withData:dic];
}

//get @"<xmln:tag key=value .....>value</tag>"
+(NSString *)ReyCodeXMLGetTag:(NSString *)xmlns
                       withData:(NSDictionary *)data
{
    NSString * tag = [data objectForKey:@"tag"];
    NSString * value = [data objectForKey:@"value"];
    NSDictionary * arributeDic = [data objectForKey:@"arributeDic"];
    NSArray * items = [data objectForKey:@"items"];
    
    if (!value) {
        value = @"";
    }
    
    if (!xmlns) {
        xmlns = @"";
    }
    NSMutableString * str = [[[NSMutableString alloc] init] autorelease];
    
    NSArray * keys = [arributeDic allKeys];
    

    
    [str appendFormat:@"\n<%@:%@",xmlns,tag];
    
    for (NSString * key in keys) {
        [str appendString:[ReyCodeXML ReyCodeXMLGetKeyAndValue:key withValue:[arributeDic objectForKey:key]]];
    }
    
    [str appendFormat:@">"];
    [str appendString:value];
    
    for (NSDictionary * item in items) {
        NSString * itemStr = [ReyCodeXML ReyCodeXMLGetTag:xmlns withData:item];
        [str appendFormat:@"%@",itemStr];
    }
    
    [str appendFormat:@"</%@:%@>",xmlns,tag];
    return str;
}

//get @"<tag>value
//<xmlns:subTag key=value>value</subTag>
//<xmlns:subTag key=value>value</subTag>
//<xmlns:subTag key=value>value</subTag>
//</tag>"

//=======================
//item dictionary descript
//    key         type
//    tag         NSString *
//    value       NSString *
//    arribute    NSDictionary *
//=======================

+(NSString *)ReyCodeXMLGetTagArray:(NSString *)tag 
                         withXmlns:(NSString *)xmlns
                      withArribute:(NSDictionary *)arributeDic 
                         withItems:(NSArray *)items
{
    NSMutableString * str =[[[NSMutableString alloc] init] autorelease];
    
    NSArray * keys = [arributeDic allKeys];
    
    
    
    [str appendFormat:@"<%@:%@",xmlns,tag];
    
    for (NSString * key in keys) {
        [str appendString:[ReyCodeXML ReyCodeXMLGetKeyAndValue:key withValue:[arributeDic objectForKey:key]]];
    }
    [str appendFormat:@">"];
    
    //add item
    for (NSDictionary * item in items) {
        NSString * itemStr =[ReyCodeXML ReyCodeXMLGetTag:xmlns withData:item];
        [str appendFormat:@"%@",itemStr];
    }
    
    
    [str appendFormat:@"\n</%@:%@>",xmlns,tag];
    
    return str;
}




+(NSMutableString *)ReyCodeXMLGetSOAPPostBodyWithAction:(NSString *)action 
                                withXmlns_tag:(NSString *)xmlns_tag
                              withXmlns_space:(NSString *)xmlns_space
                                 withPostBody:(NSArray *)postbody
{
    NSMutableString * str =[[[NSMutableString alloc] init] autorelease];
    
    [str appendFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"];
    [str appendFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \
                                        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \
                       xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" > \n"];
    [str appendFormat:@"<soap:Body xmlns:%@=\"%@\">\n",xmlns_tag,xmlns_space];
    
    NSString * postBody = [ReyCodeXML ReyCodeXMLGetTagArray:action 
                                                  withXmlns:xmlns_tag 
                                               withArribute:nil 
                                                  withItems:postbody];
    
    [str appendString:postBody];
    
    
    [str appendFormat:@"</soap:Body>\n"];
    [str appendFormat:@"</soap:Envelope>\n"];
    
    return str;
}



@end
