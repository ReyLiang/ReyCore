//
//  ReyXMLParser_imgurl.m
//  ReyCore
//
//  Created by rey liang on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyXMLParser_imgurl.h"

@implementation ReyXMLParser_imgurl

#define CONTAINITEM  @"imgurl" , @"error", nil
#define ITEM @"set"

//TODO: 自动释放类型..避免bad_access
+(void)startXMLParserWithURL:(NSURL *)url 
                   plistName:(NSString *)PlistName 
                    postBody:(NSDictionary *)postBody 
                    delegate:(id<ReyXMLParserDelegate>)aDelegate
{
    ReyXMLParser_imgurl * paerser = [[ReyXMLParser_imgurl alloc] initWithURL:url plistName:PlistName postBody:postBody delegate:aDelegate];
    paerser.isNeedReleaseSelf = YES;
}


-(void)initContainArray
{
	containArray = [[NSArray alloc] initWithObjects:CONTAINITEM];
    
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict 
{
	if ([elementName isEqualToString:ITEM]) {

	}
	else if ([containArray containsObject: elementName]) {
        
        [objectArray addObject:[attributeDict valueForKey:@"value"]];

	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:currentElementName]) {
		
	} else if ([elementName isEqualToString:ITEM]) {
        //		//NSLog(@"END@@@@@@@@@@@@@[elementName isEqualToString:%@]",ITEM);
        
	}
    
	
}


@end
