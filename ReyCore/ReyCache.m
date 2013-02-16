//
//  ReyCache.m
//  ReyCore
//
//  Created by rey liang on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyCache.h"
#import "ReyDownloadQueue_cache.h"
#import "ReyXMLParser_imgurl.h"

@interface ReyCache()
<ReyDownloadQueue_cacheDelegate,ReyXMLParserDelegate>

@end

@implementation ReyCache

@synthesize delegate;
@synthesize m_downloadQueue;
@synthesize m_directory;
@synthesize imgsCount;
@synthesize faildError;
@synthesize isAutoRelease;


+(id)CacheWithDelegate:(id<ReyCacheDelegate>) adelegate 
                   URL:(NSURL *)url 
             directory:(NSString *)directory 
              postBody:(NSDictionary *)postBody
{
    ReyCache * cache = [[ReyCache alloc] initWithURL:url directory:directory postBody:postBody];
    cache.delegate = adelegate;
    cache.isAutoRelease = YES;
    return cache;
}


-(id)initWithURL:(NSURL *)url directory:(NSString *)directory postBody:(NSDictionary *)postBody
{
    self = [super init];
    if (self) {
        m_directory = [directory retain];
        
        [ReyXMLParser_imgurl startXMLParserWithURL:url plistName:nil postBody:postBody delegate:self];
    }
    
    return self;
}

-(void)dealloc
{
    [faildError release];
    [m_downloadQueue release];
    [m_directory release];
    [super dealloc];
}

-(void)startDownloadQueue:(NSArray *)httpsArry
{
    imgsCount = [httpsArry count];
    
    for (NSString * str in httpsArry) {
        //NSLog(str);
    }
    if (imgsCount == 1) {
        faildError = [httpsArry objectAtIndex:0];
        if (delegate && [delegate respondsToSelector:@selector(ReyCacheDelegateXMLFailed:)]) {
            [delegate ReyCacheDelegateXMLFailed:self];
        }
    }
    
    if (delegate && [delegate respondsToSelector:@selector(ReyCacheDelegateStartCache:)]) {
        [delegate ReyCacheDelegateStartCache:self];
    }
    
    m_downloadQueue = [[ReyDownloadQueue_cache alloc] initWithHttps:httpsArry directory:m_directory];
    m_downloadQueue.m_maxConcurrectCount = 3;
    m_downloadQueue.delegate = self;
    [m_downloadQueue start];
}

-(void)AutoRelease
{
    [NSThread sleepForTimeInterval:0.5];
    if (isAutoRelease) {
        [self release];
    }
}


#pragma mark - 
#pragma mark ReyDownloadQueue_cacheDelegate

//全部完成后调用
-(void)ReyDownloadQueue_cacheAllFinished:(ReyDownloadQueue_cache *)target faildArry:(NSArray *)faildArry
{
    if (delegate && [delegate respondsToSelector:@selector(ReyCacheDelegateAllFinished: faildArry:)]) {
        [delegate ReyCacheDelegateAllFinished:self faildArry:faildArry];
    }
    
    [self performSelectorOnMainThread:@selector(AutoRelease) withObject:nil waitUntilDone:NO];
    
}


//每个下载结束后,调用
-(void)ReyDownloadQueue_cacheFinished:(ReyDownloadQueue_cache *)target 
                                index:(int)index
                            isSuccess:(bool)isSuccess 
                                error:(ReyDownloadQueue_cacheError)error
{
    if (delegate && [delegate respondsToSelector:@selector(ReyCacheDelegateFinished:index:isSuccess:)]) {
        [delegate ReyCacheDelegateFinished:self index:index isSuccess:isSuccess];
    }
}

#pragma mark -


#pragma mark ReyXMLParserDelegate

-(void)XMLParseFinished:(ReyXMLParser *)xmlParser data:(id)parsedData
{
    [self performSelectorOnMainThread:@selector(startDownloadQueue:) withObject:parsedData waitUntilDone:NO];
}

-(void)XMLParseFailed:(ReyXMLParser *)xmlParser
{
    if (delegate && [delegate respondsToSelector:@selector(ReyCacheDelegateXMLFailed:)]) {
        [delegate ReyCacheDelegateXMLFailed:self];
    }
}

#pragma mark - 

@end
