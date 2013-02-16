/*************************************************
 
 Copyright (C), 2010-2015, Rey
 
 File name:	ReyXMLParser.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/1/24
 
 Description:
 
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 *************************************************/

#import "ReyXMLParser.h"

@implementation ReyXMLParser

@synthesize plistName;
@synthesize xmlParser;
@synthesize dictionary;
@synthesize objectArray;
@synthesize containArray;
@synthesize currentElementName;
@synthesize currentText;
@synthesize currentAttribute;

@synthesize download;

@synthesize isFinished;
@synthesize isFailed;
@synthesize isCheckUpdate;
@synthesize isNeedReleaseSelf;

@synthesize delegate;

#define CONTAINITEMS  @"status", @"gsip", @"gsport", @"uid", @"center_url", nil
#define ITEM @"set"

//TODO: 自动释放类型..避免bad_access
+(id)startXMLParserWithURL:(NSURL *)url
                 plistName:(NSString *)PlistName 
                  postBody:(NSDictionary *)postBody 
                  delegate:(id<ReyXMLParserDelegate>)aDelegate
{
    ReyXMLParser * paerser = [[ReyXMLParser alloc] initWithURL:url plistName:PlistName postBody:postBody delegate:aDelegate];
    paerser.isNeedReleaseSelf = YES;
    
    return paerser;
}

//TODO: 初始化.plistName存储文件名,postBody是用于post方式发值的时候,key-value.
-(id)initWithURL:(NSURL *)url 
       plistName:(NSString *)PlistName 
        postBody:(NSDictionary *)postBody 
        delegate:(id<ReyXMLParserDelegate>)aDelegate
{
	if (self =[super init]) {
		isFinished = NO;
		isFailed = NO;
		isCheckUpdate = NO;
        if (!PlistName) {
            isCheckUpdate = YES;
            plistName = nil;
        }
        else
        {
            plistName = [PlistName retain];
        }
        
        if (postBody) {
            download = [[ReyDownload_Post alloc] init];
            delegate = aDelegate;
            if (postBody) {
                NSArray * keys = [postBody allKeys];
                for (NSString * key in keys) {
                    [download addPostFieldWithKey:key value:[postBody valueForKey:key]];
                }
            }
        }
        else
        {
            download = [[ReyDownload alloc] init];
            delegate = aDelegate;

        }
		
		
        
		[download downloadWithURL:url delegate:self];
		
		[self initContainArray];
	}
	return self;
}


-(void)initContainArray
{
	containArray = [[NSArray alloc] initWithObjects:CONTAINITEMS];
}

-(void)dealloc
{
    
    
    if (download) {
        [download release];
        download = nil;
    }
    
    if (objectArray) {
        [objectArray release];
        objectArray = nil;
    }
	if (currentAttribute) {
        [currentAttribute release];
        currentAttribute = nil;
    }
	if (currentText) {
		[currentText release];
        currentText = nil;
	}
	if (currentElementName) {
		[currentElementName release];
        currentElementName = nil;
	}
	if (dictionary) {
		[dictionary release];
        dictionary = nil;
	}
    if (plistName) {
        [plistName release];
        plistName = nil;
    }
	[containArray release];
    containArray = nil;
	[super dealloc];
	
    //NSLog(@"xml parser dealloc!");
	
}

-(void)DownloadFinished:(id)downloaded
{
	if (![(NSData *)downloaded length]) {
		isFailed = YES;
        if (delegate && [delegate respondsToSelector:@selector(XMLParseFailed:)]) {
            [delegate XMLParseFailed:self];
        }
		return;
	}
	
//	//测试接收
//	NSString * comPath = [NSString stringWithFormat:@"Documents/1%@",category];
//	NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:comPath];
//	NSData * data = [[NSData alloc] initWithData:downloaded];
//	[data writeToFile:path atomically:NO];
//	[data release];
    
//    NSLog(@"%@",[NSString stringWithUTF8String:[downloaded bytes]]);
	
	[NSThread detachNewThreadSelector:@selector(startXMLParser:) toTarget:self withObject:downloaded];
	

	
}

-(void)startXMLParser:(id)downloaded
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
//    NSLog(@"%@",[NSString stringWithCString:[downloaded bytes] encoding:NSUTF8StringEncoding]);
	xmlParser = [[NSXMLParser alloc] initWithData:downloaded];
	xmlParser.delegate = self;
	[xmlParser parse];
    
    while(!download.finished) {
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        
    }
	isFinished = YES;
	[xmlParser release];
    xmlParser = nil;
	[download release];
    download = nil;
    
    
    //    //==test
    //    [self release];
    if (isNeedReleaseSelf) {
        [self release];
    }
    
    [pool release];
}

-(void)DownloadFailed:(NSError *)error
{
	isFailed = YES;
	//NSLog(@"1123123123");
    
    if ([delegate respondsToSelector:@selector(XMLParseFailed:)]) {
        [delegate XMLParseFailed:self];
    }
    
    [download release];
    download = nil;
    
    if (isNeedReleaseSelf) {
        [self release];
    }
    

}
#pragma mark -
#pragma mark NSXMLParser callbacks

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	[objectArray  release];
    objectArray = nil;
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
	}
	else if ([containArray containsObject: elementName]) {
        [currentElementName release];
		currentElementName = [elementName retain];
		[currentText release];
        [currentAttribute release];
        currentAttribute = [attributeDict retain];
		currentText = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
	[currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:currentElementName]) {
		[dictionary setValue: [currentAttribute valueForKey:@"value"] forKey: currentElementName];
        
        [currentAttribute release];
        currentAttribute = nil;
		[currentElementName release];
		currentElementName = nil;
		[currentText release];
		currentText = nil;
		
	} else if ([elementName isEqualToString:ITEM]) {
		[objectArray addObject:dictionary];
		[dictionary release];
		dictionary = nil;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([delegate respondsToSelector:@selector(XMLParseFinished: data:)]) {
        [delegate XMLParseFinished:self data:objectArray];
    }
    //==test测试数据
	[self writeToPath];
}


-(void)writeToPath
{
	if (!isCheckUpdate) {//如果是检测模式,就不写入本地
		NSString * comPath = [NSString stringWithFormat:@"Documents/%@",plistName];
		NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:comPath];
		if ([[NSFileManager defaultManager] fileExistsAtPath:path] ) {
			NSError * error;
			if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) {
				//NSLog(@"%@",[error description]);
				abort();
			}
		}
		if (![objectArray writeToFile:path atomically:NO]) {
			//NSLog(@"Plist文件保存出错");
			abort();
		}
		[objectArray release];
        objectArray = nil;
		
		//NSLog(@"%@ is finished",plistName);
	}

}
#pragma mark -


@end
