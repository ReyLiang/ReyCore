//
//  ReyDownload_cache.m
//  ReyCore
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyDownload_cache.h"
#import "ReyDownload.h"

@interface ReyDownload_cache()
    <ReyDownloadDelegate>
-(void)autoRelease;
@end

@implementation ReyDownload_cache

#define FAILD_MAX  2

@synthesize m_delegate;
@synthesize m_fileName;
@synthesize m_directory;
@synthesize m_url;
@synthesize tag;
@synthesize m_isAutoRelease;

+(id)downloadCacheWithURL:(NSURL *)url 
        delegate:(id<ReyDownload_cacheDelegate>)delegate 
  savedDirectory:(NSString *)savedDirectory 
        fileName:(NSString *)fileName
{
    ReyDownload_cache * autoRelease = [[ReyDownload_cache alloc] initWithURL:url delegate:delegate savedDirectory:savedDirectory fileName:fileName];
    autoRelease.m_isAutoRelease = YES;
    
    return autoRelease;
}

-(id)initWithURL:(NSURL *)url 
        delegate:(id<ReyDownload_cacheDelegate>)delegate 
  savedDirectory:(NSString *)savedDirectory 
        fileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        
        m_delegate = delegate;
        
        m_directory = [savedDirectory retain];
        
        m_url = [url retain];
        
        
        
        if (fileName) {
            m_fileName = [fileName retain];
        }
        else
          {
            m_fileName = [[url lastPathComponent] retain];
          }
        
        [ReyDownload ReyDownloadWithURL:m_url delegate:self];
        
    }
    
    return self;
}

-(void)dealloc
{
    [m_fileName release];
    [m_directory release];
    [m_url release];
    
    [super dealloc];
}

-(void)DownloadFinished:(id)downloaded
{
    NSData * imgData = (NSData *)downloaded;
    
    NSString * path =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString * directory =[NSString stringWithFormat:@"%@/%@",path,m_directory];
    
    //创建特定文件夹
    if (![[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil]) {
        if (m_delegate && [m_delegate respondsToSelector:@selector(ReyDownload_cacheSaveFaild:)]) {
            [m_delegate ReyDownload_cacheSaveFaild:self];
        }
    }
    
    bool success = [imgData writeToFile:[NSString stringWithFormat:@"%@/%@",directory,m_fileName] atomically:NO];

    if (success) {
        if (m_delegate && [m_delegate respondsToSelector:@selector(ReyDownload_cacheSaveSuccess:)]) {
            [m_delegate ReyDownload_cacheSaveSuccess:self];
        }
    }
    else    //失败后再存储一次
      {
        bool resuccess = [imgData writeToFile:[NSString stringWithFormat:@"%@/%@",directory,m_fileName] atomically:NO];
        
        if (resuccess) {
            if (m_delegate && [m_delegate respondsToSelector:@selector(ReyDownload_cacheSaveSuccess:)]) {
                [m_delegate ReyDownload_cacheSaveSuccess:self];
            }
        }
        else
          {
            if (m_delegate && [m_delegate respondsToSelector:@selector(ReyDownload_cacheSaveFaild:)]) {
                [m_delegate ReyDownload_cacheSaveFaild:self];
            }
          }


      }
    
    [self autoRelease];
}


-(void)DownloadFailed:(NSError *)error
{
    if (m_faildCount >= FAILD_MAX) {
        if (m_delegate && [m_delegate respondsToSelector:@selector(ReyDownload_cacheDownloadFaild:)]) {
            [m_delegate ReyDownload_cacheDownloadFaild:self];
        }
        
        [self autoRelease];
    }
    
    [ReyDownload ReyDownloadWithURL:m_url delegate:self];
    
    m_faildCount ++;
    
}

//主要用于通知文件大小,如果未知,则传-1
-(void)didReceiveResponse:(long long )totalSize
{
    
}

-(void)autoRelease
{
    if (m_isAutoRelease) {
        [self release];
    }
}



@end
