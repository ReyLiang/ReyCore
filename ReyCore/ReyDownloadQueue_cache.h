//
//  ReyDownloadQueue_cache.h
//  ReyCore
//
//  Created by rey liang on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReyDownloadQueue_cacheDelegate;

typedef enum 
{
    ReyDownloadQueue_cacheErrorDownload,
    ReyDownloadQueue_cacheErrorSave
}ReyDownloadQueue_cacheError;


@interface ReyDownloadQueue_cache : NSObject

{
    
    id<ReyDownloadQueue_cacheDelegate> delegate;
    
    //http下载地址
    NSArray * m_httpsArry;
    
    //下载失败地址
    NSMutableArray * m_httpsFaildArry;
    
    //存储文件夹名
    NSString * m_directory;
    
    //下载并发最大数
    int m_maxConcurrectCount;
    
    //当前并发下载数
    int m_concurrectCount;
    
    //准备下载的index
    int m_prepareDownload;
    
    //已下载完的数量
    int m_finishedCount;
}

@property (nonatomic , assign) id<ReyDownloadQueue_cacheDelegate> delegate;
@property (nonatomic , retain) NSArray * m_httpsArry;
@property (nonatomic , retain) NSMutableArray * m_httpsFaildArry;
@property (nonatomic , retain) NSString * m_directory;
@property (nonatomic) int m_maxConcurrectCount;

- (id)initWithHttps:(NSArray *)https directory:(NSString *)directory;

-(void)start;
@end

@protocol ReyDownloadQueue_cacheDelegate <NSObject>

//全部完成后调用
-(void)ReyDownloadQueue_cacheAllFinished:(ReyDownloadQueue_cache *)target faildArry:(NSArray *)faildArry;

//每个下载结束后,调用
-(void)ReyDownloadQueue_cacheFinished:(ReyDownloadQueue_cache *)target index:(int)index isSuccess:(bool)isSuccess error:(ReyDownloadQueue_cacheError)error;

@end
