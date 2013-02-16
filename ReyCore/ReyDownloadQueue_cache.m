//
//  ReyDownloadQueue_cache.m
//  ReyCore
//
//  Created by rey liang on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyDownloadQueue_cache.h"
#import "ReyDownload_cache.h"

@interface ReyDownloadQueue_cache()
    <ReyDownload_cacheDelegate>
-(void)callDelegate:(int)tag isSuccess:(bool)success error:(ReyDownloadQueue_cacheError)error;
-(bool)startNextDownload;
@end

@implementation ReyDownloadQueue_cache

@synthesize delegate;
@synthesize m_httpsArry;
@synthesize m_httpsFaildArry;
@synthesize m_directory;
@synthesize m_maxConcurrectCount;

- (id)initWithHttps:(NSArray *)https directory:(NSString *)directory
{
    self = [super init];
    if (self) {
        // Initialization code
        
        m_httpsArry = [https retain];
        
        m_directory = [directory retain];
        
        m_httpsFaildArry = [[NSMutableArray alloc] init];
        
        //默认并发数为1
        m_maxConcurrectCount = 1;
        
        m_prepareDownload = 0;
        
        m_finishedCount = 0;
    }
    return self;
}

-(void)dealloc
{
    
    
    [m_httpsArry release];
    [m_httpsFaildArry release];
    [m_directory release];
    
    [super dealloc];
}

//开始下载
-(void)start
{
    m_prepareDownload = 0;
    
    m_finishedCount = 0;
    
    for (int i = 0 ; i < m_maxConcurrectCount; i++) {
        [self startNextDownload];
    }
}

//开启
-(bool)startNextDownload
{
//    NSLog(@"startNextDownload m_prepareDownload = %d",m_prepareDownload);

    [self performSelectorOnMainThread:@selector(startHttpDownload) withObject:nil waitUntilDone:NO];
    return YES;

}

//开启线程下载
-(void)startHttpDownload
{
    if (m_concurrectCount < m_maxConcurrectCount && m_prepareDownload < [m_httpsArry count]) {
        
        //NSLog(@"test m_prepareDownload = %d",m_prepareDownload);
        ReyDownload_cache * cache = [ReyDownload_cache downloadCacheWithURL:[NSURL URLWithString:[m_httpsArry objectAtIndex:m_prepareDownload]]
                                                                   delegate:self
                                                             savedDirectory:m_directory 
                                                                   fileName:NULL];
        cache.tag = m_prepareDownload;
        m_prepareDownload++;
        m_concurrectCount++;
    }

}

-(void)callDelegate:(int)tag isSuccess:(bool)success error:(ReyDownloadQueue_cacheError)error
{
//    NSLog(@"finished $%d",m_finishedCount);
    
    
    
    
    if (delegate && [delegate respondsToSelector:@selector(ReyDownloadQueue_cacheFinished: index: isSuccess: error:)]) {
        [delegate ReyDownloadQueue_cacheFinished:self index:tag isSuccess:success error:error];
    }
    
    if (m_finishedCount == [m_httpsArry count] -1) {
        if (delegate && [delegate respondsToSelector:@selector(ReyDownloadQueue_cacheAllFinished: faildArry: )]) {
            [delegate ReyDownloadQueue_cacheAllFinished:self faildArry:m_httpsFaildArry ];
        }
        
        return;
    }
    
    m_finishedCount ++ ;
    
    [self startNextDownload];
}

#pragma mark -
#pragma mark ReyDownload_cacheDelegate

//存储失败
-(void)ReyDownload_cacheSaveFaild:(ReyDownload_cache *)target
{
    m_concurrectCount--;
    [m_httpsFaildArry addObject:[m_httpsArry objectAtIndex:target.tag]];
    
    [self callDelegate:target.tag isSuccess:NO error:ReyDownloadQueue_cacheErrorSave];

}

//存储成功
-(void)ReyDownload_cacheSaveSuccess:(ReyDownload_cache *)target
{
    m_concurrectCount--;
    
    [self callDelegate:target.tag isSuccess:YES error:-1];
}

//下载失败
-(void)ReyDownload_cacheDownloadFaild:(ReyDownload_cache *)target
{
    m_concurrectCount--;
    [m_httpsFaildArry addObject:[m_httpsArry objectAtIndex:target.tag]];
    
    [self callDelegate:target.tag isSuccess:NO error:ReyDownloadQueue_cacheErrorDownload];
}

#pragma mark -


@end
