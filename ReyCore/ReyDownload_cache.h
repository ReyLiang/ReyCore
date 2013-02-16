//
//  ReyDownload_cache.h
//  ReyCore
//
//  Created by rey liang on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReyDownload_cacheDelegate;


@interface ReyDownload_cache : NSObject

{
    id<ReyDownload_cacheDelegate> m_delegate;
    
    //文件下载后存储的文件夹名
    NSString * m_directory;
    
    //下载后存储文件名
    NSString * m_fileName;
    
    //url
    NSURL * m_url;
    
    //标识
    int tag;
    
    int m_faildCount;
    
    //自动释放标识
    bool m_isAutoRelease;
}
@property (nonatomic , assign) id<ReyDownload_cacheDelegate> m_delegate;

@property (nonatomic , retain) NSString * m_directory;

@property (nonatomic , retain) NSString * m_fileName;

@property (nonatomic , retain) NSURL * m_url;

@property (nonatomic) int tag;
@property (nonatomic) bool m_isAutoRelease;


-(id)initWithURL:(NSURL *)url delegate:(id<ReyDownload_cacheDelegate>)delegate savedDirectory:(NSString *)savedDirectory fileName:(NSString *)fileName;

+(id)downloadCacheWithURL:(NSURL *)url 
                 delegate:(id<ReyDownload_cacheDelegate>)delegate 
           savedDirectory:(NSString *)savedDirectory 
                 fileName:(NSString *)fileName;

@end


@protocol ReyDownload_cacheDelegate <NSObject>

//存储失败
-(void)ReyDownload_cacheSaveFaild:(ReyDownload_cache *)target;

//存储成功
-(void)ReyDownload_cacheSaveSuccess:(ReyDownload_cache *)target;

//下载失败
-(void)ReyDownload_cacheDownloadFaild:(ReyDownload_cache *)target;

@end
