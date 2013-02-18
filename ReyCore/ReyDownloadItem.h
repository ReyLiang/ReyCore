//
//  ReyDownloadItem.h
//  TestThreadManager
//
//  Created by Rey on 13-1-30.
//  Copyright (c) 2013年 Rey. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    ReyDownloadItemType_Normal,
    ReyDownloadItemType_Post
}ReyDownloadItemType;

typedef enum {
    ReyDownloadItemState_Ready,
    ReyDownloadItemState_Download,
    ReyDownloadItemState_Finished,
    ReyDownloadItemState_NotFound
}ReyDownloadItemState;

@interface ReyDownloadItem : NSObject
{
    ReyDownloadItemType type;
    
    NSString *  url;
    NSString *  cacheName;
    
    NSData *    loadData;
    
    int         tag;
    
    //用于下载后,进行操作
    id          target;
    
    //下载成功后,回调函数
    //example:(ReyDownloadItem *)item
    SEL         finishedSel;
    
    //下载失败回调
    SEL         failedSel;
    
    //type==ReyDownloadType_Post 必填
    NSDictionary * postBoty;
    
    
    //optional
    //item持有者
    id          owner;
    
    
    
    
    
    //预留接口.
    //只对ReyDownloadManager可以见
    id m_downloader;
}

@property (nonatomic)          ReyDownloadItemType type;
@property (nonatomic , retain) NSString *  url;
@property (nonatomic , retain) NSString *  cacheName;
@property (nonatomic , retain) NSData *    loadData;
@property (nonatomic)          int         tag;
@property (nonatomic , retain) id          target;
@property (nonatomic)          SEL         finishedSel;
@property (nonatomic)          SEL         failedSel;
@property (nonatomic , retain) NSDictionary * postBoty;

@property (nonatomic , retain) id          owner;

@end
