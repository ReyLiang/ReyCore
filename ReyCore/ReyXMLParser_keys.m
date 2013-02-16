//
//  ReyXMLParser_keys.m
//  ReyCore
//
//  Created by rey liang on 11-12-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReyXMLParser_keys.h"



@implementation ReyXMLParser_keys

#define CONTAINITEM  @"key", nil
#define ITEM @"keys"

@synthesize currentArray;
@synthesize directory;

-(id)initWithURL:(NSURL *)url 
       plistName:(NSString *)PlistName 
        postBody:(NSDictionary *)postBody 
        delegate:(id<ReyXMLParserDelegate>)aDelegate 
       directory:(NSString *)aDirectory 
{

    if (aDirectory) {
        directory = [[NSString alloc] initWithFormat:@"%@/",aDirectory];
    }
    
    return [self initWithURL:url plistName:PlistName postBody:postBody delegate:aDelegate];
}
-(void)initContainArray
{
	containArray = [[NSArray alloc] initWithObjects:CONTAINITEM];
    
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict 
{
	if ([elementName isEqualToString:ITEM]) {
		[dictionary release];
		dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:[attributeDict objectForKey:@"Gid"] forKey:@"Gid"];
        [currentArray release];
        currentArray = [[NSMutableArray alloc] init];
        
        //重置plist文件名称
        [plistName release];
        plistName = [[NSString stringWithFormat:@"%@.plist",[attributeDict objectForKey:@"Gid"]] retain];
        isCheckUpdate = NO;
		//NSLog(@"@@@@@@@@@@@@@[elementName isEqualToString:%@]",ITEM);
	}
	else if ([containArray containsObject: elementName]) {
        currentElementName = [elementName retain];
        
		
        [currentAttribute release];
        currentAttribute = [attributeDict retain];
		//NSLog(@"@@@@@@@@@@@@@%@",currentElementName);
	}
    else if ([elementName isEqualToString:@"updates"]) {

        
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
		//NSLog(@"END@@@@@@@@@@@@@%@",currentElementName);

        [currentArray addObject:currentAttribute];
        
        [currentAttribute release];
        currentAttribute = nil;
		[currentElementName release];
		currentElementName = nil;
        
		
	} else if ([elementName isEqualToString:ITEM]) {
		//NSLog(@"END@@@@@@@@@@@@@[elementName isEqualToString:%@]",ITEM);
        
        [dictionary setValue:currentArray forKey:@"keys"];

        [currentArray release];
        currentArray = nil;
        
	}

    
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    if ([delegate respondsToSelector:@selector(XMLParseFinished:data:)]) {
//        [delegate XMLParseFinished:self data:dictionary];
//    }
    //==test测试数据
	[self writeToPath];
    [dictionary release];
    dictionary = nil;
}

-(void)writeToPath
{
	if (!isCheckUpdate) {//如果是检测模式,就不写入本地
		NSString * comPath = [NSString stringWithFormat:@"Documents/%@%@",directory,plistName];
		NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:comPath];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path] ) {
			NSError * error;
			if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
				//NSLog(@"%@",[error description]);
				abort();
			}
		}


		if (![dictionary writeToFile:path atomically:NO]) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",directory] withIntermediateDirectories:YES attributes:nil error:nil]) {
                
            }
            
            if (![dictionary writeToFile:path atomically:NO]) {
                //NSLog(@"Plist文件保存出错");
                abort();
            }
		}


		
	}
    
}


-(void)dealloc
{
    [directory release];
    [super dealloc];
    
}

@end
