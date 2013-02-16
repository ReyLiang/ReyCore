//
//  ReyXMLParser_autoUpdate.m
//  ReyCore
//
//  Created by rey liang on 11-12-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReyXMLParser_autoUpdate.h"

@implementation ReyXMLParser_autoUpdate

@synthesize currentArray;


#define CONTAINITEM  @"version", @"update", nil
#define ITEM @"set"


-(void)initContainArray
{
	containArray = [[NSArray alloc] initWithObjects:CONTAINITEM];
    
}

-(void)dealloc
{
    if (currentArray) {
        [currentArray release];
        currentArray = nil;
    }
    [super dealloc];
}

-(void)DownloadFinished:(id)downloaded
{
    
    switch ([(NSData *)downloaded length]) 
  {
      case 0://发生错误,无返回
            isFailed = YES;
            break;
      case 1://返回值为1时.
      {
        if ([delegate respondsToSelector:@selector(XMLParseFinished: data:)]) {
            [delegate XMLParseFinished:self data:[NSArray arrayWithObjects:@"1",@"1",nil]];
        }
            break;
      }
      default://解析版本信息.
      {
        //NSLog(@"%@ 's %d",plistName,[downloaded length]);
        xmlParser = [[NSXMLParser alloc] initWithData:downloaded];
        xmlParser.delegate = self;
        [xmlParser parse];
        //NSLog(@"\n\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n\n");
        
        [xmlParser release];
        [download release];
        //NSLog(@"%@",[NSString stringWithCString:[downloaded bytes] encoding:NSUTF8StringEncoding]);
            break;
      }
    }

    isFinished = YES;
	
}


#pragma mark -
#pragma mark NSXMLParser callbacks



- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	[objectArray  release];
	objectArray = [[NSMutableArray alloc] init];
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
		//NSLog(@"@@@@@@@@@@@@@[elementName isEqualToString:%@]",ITEM);
	}
	else if ([containArray containsObject: elementName]) {
        currentElementName = [elementName retain];

		
        [currentAttribute release];
        currentAttribute = [attributeDict retain];
		//NSLog(@"@@@@@@@@@@@@@%@",currentElementName);
	}
    else if ([elementName isEqualToString:@"updates"]) {
        [currentArray release];
        currentArray = [[NSMutableArray alloc] init];
        
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

        if ([currentElementName isEqualToString:@"update"])
          {
            //NSLog([currentAttribute valueForKey:@"value"]);
            [currentArray addObject:[currentAttribute valueForKey:@"value"]];
          }
        else 
          {
            [dictionary setValue: [currentAttribute valueForKey:@"value"] forKey: currentElementName];
          }
		
        
        [currentAttribute release];
        currentAttribute = nil;
		[currentElementName release];
		currentElementName = nil;

		
	} else if ([elementName isEqualToString:ITEM]) {
		//NSLog(@"END@@@@@@@@@@@@@[elementName isEqualToString:%@]",ITEM);
		[objectArray addObject:dictionary];
		[dictionary release];
		dictionary = nil;
        
	}
    else if ([elementName isEqualToString:@"updates"]) {
        [dictionary setValue:currentArray forKey:elementName];
        [currentArray release];
        currentArray = nil;
        
    }
    
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([delegate respondsToSelector:@selector(XMLParseFinished:data:)]) {
        [delegate XMLParseFinished:self data:objectArray];
    }
    //==test测试数据
	[self writeToPath];
}


@end
