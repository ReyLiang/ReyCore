//
//  ReyDownloadItem.m
//  TestThreadManager
//
//  Created by Rey on 13-1-30.
//  Copyright (c) 2013年 Rey. All rights reserved.
//

#import "ReyDownloadItem.h"

@interface ReyDownloadItem ()

@property (nonatomic , retain) id m_downloader;
@end

@implementation ReyDownloadItem
@synthesize cacheName,finishedSel,failedSel,tag,target,url,postBoty;
@synthesize m_downloader;
@synthesize owner;
@synthesize loadData;

-(void)dealloc
{
    if (m_downloader) {
        [m_downloader release];
    }
    
    [postBoty release];
    [cacheName release];
    [loadData release];
    [target release];
    [url release];
    [owner release];
    [super dealloc];
}


@end
