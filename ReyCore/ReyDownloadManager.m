/*************************************************
 
 Copyright (C), 2010-2020, Rey.
 
 File name:	ReyThreadManager.m
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2013/1/30
 
 Description:
 
 http下载管理类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import "ReyDownloadManager.h"
#import "ReyDownload.h"
#import "ReyDownload_Post.h"
#import "ReyDownloadItem_private.h"

//全局变量.所有操作基本定为类方法
ReyDownloadManager * g_downloadManager;


@interface ReyDownloadManager ()
    <ReyDownloadDelegate>

@property (nonatomic , retain) NSCondition * m_lock;

-(void)initDatas;
//缓存数据
-(BOOL)cacheFile:(NSString *)fileName fileData:(NSData *)fileData;

//检测是否可以开始下载.
-(BOOL)checkCouldStart;
-(void)startNext;
@end

@implementation ReyDownloadManager

@synthesize m_paralleledNumber;
@synthesize m_finishedArry,m_downloadArry,m_readyArry,m_failedArry;
@synthesize m_chached,m_chachPath;

@synthesize m_finishedTarget;
@synthesize m_lock;


//最大并行个数
#define PARALLELED_NUMBER 5;


#pragma mark -
#pragma mark Class Method

+(ReyDownloadManager *)currentManager
{
    if (!g_downloadManager) {
        g_downloadManager = [[ReyDownloadManager alloc] init];
    }
    
    return g_downloadManager;
}

+(void)releaseManager
{
    if (g_downloadManager) {
        [g_downloadManager release];
        g_downloadManager = nil;
    }
}

#pragma mark -
#pragma mark Init Method
-(id)init
{
    self = [super init];
    
    if (self) {
        [self initDatas];
    }
    
    return self;
}

-(void)dealloc
{
    if (m_finishedTarget) {
        [m_finishedTarget release];
        m_finishedTarget = nil;
        m_finishedSel = nil;
    }
    
    if (m_lock) {
        [m_lock release];
    }
    
    [m_chachPath release];
    
    [m_failedArry removeAllObjects];
    [m_failedArry release];
    
    [m_downloadArry removeAllObjects];
    [m_downloadArry release];
    
    [m_finishedArry removeAllObjects];
    [m_finishedArry release];
    
    [m_readyArry removeAllObjects];
    [m_readyArry release];
    
    [super dealloc];
}


-(void)initDatas
{
    m_state = ReyDownMngerState_Inited;
    
    m_chached = NO;
    
    m_paralleledNumber = PARALLELED_NUMBER;
    m_downloadCount = 0;
    m_finishedCount = 0;
    
    m_readyArry = [[NSMutableArray alloc] init];
    m_downloadArry = [[NSMutableArray alloc] init];
    m_finishedArry = [[NSMutableArray alloc] init];
    m_failedArry = [[NSMutableArray alloc] init];
    
    m_lock = [[NSCondition alloc] init];

    
}

#pragma mark -
#pragma mark Paralleled Number Method

-(void)setM_paralleledNumber:(int)paralleledNumber
{
    m_paralleledNumber = paralleledNumber;
    
    
    [self checkCouldStart];
}


#pragma mark -
#pragma mark Main function Method

//开始下载
-(void)startDownload
{
    //continue
    if (m_state == ReyDownMngerState_Pause) {
        
    }
    
    m_state = ReyDownMngerState_Start;
    
    [self checkCouldStart];
}

//暂停下载
-(void)pauseDownload
{
    //先暂停已有下载
    if (m_state == ReyDownMngerState_Start) {
        
    }
    
    m_state = ReyDownMngerState_Pause;
}

//停止下载
-(void)stopDownload
{
    m_state = ReyDownMngerState_Stop;
}

//检测加载结束
-(BOOL)hasFinishedAll
{
    if (m_state == ReyDownloadItemState_Finished) {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark Add Download Method

-(void)addDownloadWithArray:(NSArray *)array
{
    [m_readyArry addObjectsFromArray:array];
    
    [self checkCouldStart];



}

-(void)addDownloadWithItem:(ReyDownloadItem *)item
{
    [m_readyArry addObject:item];
    
    [self checkCouldStart];
}

#pragma mark -
#pragma mark Del Download Method

//只处理还未开始的item,如果开始就不会进行.
-(BOOL)delDownloadWithItem:(ReyDownloadItem *)item
{
    if ([m_readyArry containsObject:item]) {
        
        [m_readyArry removeObject:item];
        return YES;
    }
    
    //已经完成,或者正在下载.
    return NO;
}

-(BOOL)delDownloadWithUrl:(NSString *)url
{
    for (ReyDownloadItem * item in m_readyArry) {
        if ([item.url isEqualToString:url]) {
            return YES;
        }
    }
    
    //已经完成,或者正在下载.
    return NO;
}

-(BOOL)delDownloadWithCacheName:(NSString *)cacheName
{
    for (ReyDownloadItem * item in m_readyArry) {
        if ([item.cacheName isEqualToString:cacheName]) {
            return YES;
        }
    }
    
    //已经完成,或者正在下载.
    return NO;
}

#pragma mark -
#pragma mark Check State Method

-(ReyDownloadItemState)checkDownloadStateWithItem:(ReyDownloadItem *)item
{
    if ([m_readyArry containsObject:item]) {
        
        return ReyDownloadItemState_Ready;
    }
    
    if ([m_downloadArry containsObject:item]) {
        
        return ReyDownloadItemState_Download;
    }
    
    if ([m_finishedArry containsObject:item]) {
        
        return ReyDownloadItemState_Finished;
    }
    
    return ReyDownloadItemState_NotFound;
}

-(ReyDownloadItemState)checkDownloadStateWithUrl:(NSString *)url
{
    for (ReyDownloadItem * item in m_readyArry) {
        if ([item.cacheName isEqualToString:url]) {
            return ReyDownloadItemState_Ready;
        }
    }
    
    for (ReyDownloadItem * item in m_downloadArry) {
        if ([item.url isEqualToString:url]) {
            return ReyDownloadItemState_Download;
        }
    }
    
    for (ReyDownloadItem * item in m_finishedArry) {
        if ([item.url isEqualToString:url]) {
            return ReyDownloadItemState_Finished;
        }
    }
    
    
    return ReyDownloadItemState_NotFound;
}


-(ReyDownloadItemState)checkDownloadStateWithCacheName:(NSString *)cacheName
{
    for (ReyDownloadItem * item in m_readyArry) {
        if ([item.cacheName isEqualToString:cacheName]) {
            return ReyDownloadItemState_Ready;
        }
    }
    
    for (ReyDownloadItem * item in m_downloadArry) {
        if ([item.cacheName isEqualToString:cacheName]) {
            return ReyDownloadItemState_Download;
        }
    }
    
    for (ReyDownloadItem * item in m_finishedArry) {
        if ([item.cacheName isEqualToString:cacheName]) {
            return ReyDownloadItemState_Finished;
        }
    }
    
    
    return ReyDownloadItemState_NotFound;
}

#pragma mark -
#pragma mark Download Method

//默认在子线程中回调FinishedCallBack
-(void)finishAllItems
{
    if (m_finishedTarget) {
        [m_finishedTarget performSelector:m_finishedSel withObject:self];
    }
}

//检测是否可以开始下载.
-(BOOL)checkCouldStart
{
    
    //下载完成后,不自动开启下载,需由外部开启
    if (m_state != ReyDownMngerState_Start) {
        return NO;
    }

    
    
    
    
    if (m_downloadCount < m_paralleledNumber) {
        
        int count = m_paralleledNumber - m_downloadCount;
        for (int i =0; i<count; i++) {
            if (m_state != ReyDownMngerState_Finished) {
                [self startNext];
                
            }
            else    //已结束,跳出循环
            {
                break;
            }
        }
    }
    
    //无法实现在finishAllItems的回调函数中Release Manager,故将其放到unlock以后
//    if (m_state == ReyDownMngerState_Finished) {
////        [self finishAllItems];
//        [self performSelectorOnMainThread:@selector(finishAllItems) withObject:nil waitUntilDone:NO];
//        
//        return NO;
//    }
    
    return YES;
}

//开始下一个下载.
-(void)startNext
{
    
    //已经下载完
    if (![m_readyArry count] ) {
        if (![m_downloadArry count] && m_state != ReyDownMngerState_Finished) {
            m_state = ReyDownMngerState_Finished;
        }
        
        return;
    }
    
    
    
    
    m_downloadCount ++;
    
    ReyDownloadItem * item = [[m_readyArry objectAtIndex:0] retain];
    

    
    
    
    ReyDownloadItemType type = item.type;
    NSMutableDictionary * extraData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:item,@"item", nil];
    
    switch (type) {
        case ReyDownloadItemType_Normal:
        {
            [ReyDownload ReyDownloadWithURL:[NSURL URLWithString:item.url]
                                   delegate:self
                                  extraData:extraData];
            break;
        }
        case ReyDownloadItemType_Post:
        {
            
            [ReyDownload_Post ReyDownloadWithURL:[NSURL URLWithString:item.url]
                                        delegate:self
                                       postField:item.postBoty
                                       extraData:extraData];
            
            break;
        }

    }
    
    [extraData release];
    
    [m_downloadArry addObject:item];
    
    [m_readyArry removeObject:item];
    
    [item release];
    
    
    
    
}


//下载完成.还在线程中
-(void)finishItem:(ReyDownloadItem *)item data:(id)downloaded
{
    [m_lock lock];
    
    
    
    if (m_chached) {
        [self cacheFile:item.cacheName fileData:downloaded];
    }
    
    item.loadData = downloaded;
    
    [item.target performSelector:item.finishedSel withObject:item];
    
    m_downloadCount --;
    m_finishedCount ++;
 
    [m_finishedArry addObject:item];
    [m_downloadArry removeObject:item];
    
    
    
    [self checkCouldStart];
    
    [m_lock unlock];
    
    //担心线程同步多次调用
    if (m_state == ReyDownMngerState_Finished) {
        [self finishAllItems];        
    }
}


//下载完成.还在线程中
-(void)failedItem:(ReyDownloadItem *)item error:(id)error
{
    [m_lock lock];
    
    
    [item.target performSelector:item.failedSel withObject:item];
    
    m_downloadCount --;
    m_finishedCount ++;
    
    [m_downloadArry removeObject:item];
    [m_failedArry addObject:item];
    
    
    
    
    [self checkCouldStart];
    
    [m_lock unlock];
    
    //担心线程同步多次调用
    if (m_state == ReyDownMngerState_Finished) {
               [self finishAllItems];
    }
}



#pragma mark -
#pragma mark Download CallBack Method

-(void)DownloadFinished:(id)sender data:(id)downloaded
{
    ReyDownload * download = sender;
    

    [self finishItem:[download.m_extraData objectForKey:@"item"] data:downloaded];
}

-(void)DownloadFailed:(id)sender error:(NSError *)error
{
    ReyDownload * download = sender;
    [self failedItem:[download.m_extraData objectForKey:@"item"] error:error];
}

////每次接收到数据回调函数
//-(void)receiveData:(NSData *)data
//{
//    
//}
////主要用于通知文件大小,如果未知,则传-1
//-(void)didReceiveResponse:(long long )totalSize
//{
//    
//}
//
//-(void)didReceiveWithResponse:(NSHTTPURLResponse *)response
//{
//    
//}

#pragma mark -
#pragma mark Cache Method

//设置缓存路径并开启本地缓存
//默认前缀是NSHomeDirectory()
//无需添加最后一个"/"
-(void)setCachePath:(NSString *)cachePath
{
    if (cachePath == NULL) {
        return;
    }
    
    [m_chachPath release];
    
    
    m_chached = YES;
    
    m_chachPath = [[NSHomeDirectory() stringByAppendingPathComponent:cachePath] retain];
}


//缓存数据
-(BOOL)cacheFile:(NSString *)fileName fileData:(NSData *)fileData
{
    if ([[NSFileManager defaultManager] createDirectoryAtPath:m_chachPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil])
    {
        NSString * path = [NSString stringWithFormat:@"%@/%@",m_chachPath,fileName];
        
        [fileData writeToFile:path atomically:NO];
        
        return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark Finish Callback Method

//设置完成回调函数
-(void)setFinishedCallBack:(id)target sel:(SEL)sel
{
    [m_finishedTarget release];
    m_finishedTarget = [target retain];
    m_finishedSel = sel;
    
}

#pragma mark -



@end
