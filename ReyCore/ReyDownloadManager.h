/*************************************************
 
 Copyright (C), 2010-2020, Rey.
 
 File name:	ReyThreadManager.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2013/1/30
 
 Description:
 
 http下载管理类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import <Foundation/Foundation.h>
#import "ReyDownloadItem.h"

typedef enum {
    ReyDownMngerState_Inited,
    ReyDownMngerState_Start,
    ReyDownMngerState_Pause,
    ReyDownMngerState_Stop,
    ReyDownMngerState_Finished
}ReyDownMngerState;

@interface ReyDownloadManager : NSObject
{
    
    //并行数
    int m_paralleledNumber;
    
    //正在下载个数
    int m_downloadCount;
    
    //完成个数
    int m_finishedCount;
    
    
    //manager状态
    ReyDownMngerState m_state;
    
    
    //将要开始下载的
    NSMutableArray * m_readyArry;
    //正在下载的
    NSMutableArray * m_downloadArry;
    //已经下载完的
    NSMutableArray * m_finishedArry;
    //下载失败的
    NSMutableArray * m_failedArry;
    
    
    NSCondition * m_lock;
    
    
    
    //==============属性==============
    
    //下载后本地缓存
    BOOL m_chached;
    //缓存路径
    NSString * m_chachPath;
    
    //完成回调函数
    id m_finishedTarget;
    
    //example:(ReyDownloadManager *)sender
    SEL m_finishedSel;
    
    //==============End==============
}

@property (nonatomic) int m_paralleledNumber;

@property (nonatomic , retain) NSMutableArray * m_readyArry;
@property (nonatomic , retain) NSMutableArray * m_downloadArry;
@property (nonatomic , retain) NSMutableArray * m_finishedArry;
@property (nonatomic , retain) NSMutableArray * m_failedArry;

@property (nonatomic) BOOL m_chached;
@property (nonatomic , retain) NSString * m_chachPath;

@property (nonatomic , retain) id m_finishedTarget;


//==============类函数==============
+(ReyDownloadManager *)currentManager;
+(void)releaseManager;
//==============End==============


//==============主要功能函数==============
-(void)startDownload;
-(void)pauseDownload;
-(void)stopDownload;

-(BOOL)hasFinishedAll;

//==============End==============


//==============缓存==============
-(void)setCachePath:(NSString *)cachePath;
//==============End==============


//==============Manager回调==============
-(void)setFinishedCallBack:(id)target sel:(SEL)sel;
//==============End==============



//==============添加item==============
-(void)addDownloadWithItem:(ReyDownloadItem *)item;
-(void)addDownloadWithArray:(NSArray *)array;
//==============End==============


//==============删除item==============
-(BOOL)delDownloadWithItem:(ReyDownloadItem *)item;
-(BOOL)delDownloadWithUrl:(NSString *)url;
-(BOOL)delDownloadWithCacheName:(NSString *)cacheName;
//==============End==============


//==============获取item状态==============
-(ReyDownloadItemState)checkDownloadStateWithItem:(ReyDownloadItem *)item;
-(ReyDownloadItemState)checkDownloadStateWithUrl:(NSString *)url;
-(ReyDownloadItemState)checkDownloadStateWithCacheName:(NSString *)cacheName;
//==============End==============

@end
