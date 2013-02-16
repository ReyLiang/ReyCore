//
//  ReyCache.h
//  ReyCore
//
//  Created by rey liang on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReyCacheDelegate;
@class ReyDownloadQueue_cache;

@interface ReyCache : NSObject

{
    id<ReyCacheDelegate> delegate;
    
    ReyDownloadQueue_cache * m_downloadQueue;
    
    NSString * m_directory;
    
    int imgsCount;
    
    //错误代码
    NSString * faildError;
    
    bool isAutoRelease;
}

@property (nonatomic , assign) id<ReyCacheDelegate> delegate;

@property (nonatomic , retain) ReyDownloadQueue_cache * m_downloadQueue;

@property (nonatomic , retain) NSString * m_directory;

@property (nonatomic , retain) NSString * faildError;

@property (nonatomic) int imgsCount;

@property (nonatomic) bool isAutoRelease;

-(id)initWithURL:(NSURL *)url directory:(NSString *)directory postBody:(NSDictionary *)postBody;

+(id)CacheWithDelegate:(id<ReyCacheDelegate>) adelegate 
                   URL:(NSURL *)url 
             directory:(NSString *)directory 
              postBody:(NSDictionary *)postBody;

@end

@protocol ReyCacheDelegate <NSObject>

-(void)ReyCacheDelegateXMLFailed:(ReyCache *)target;

-(void)ReyCacheDelegateStartCache:(ReyCache *)target;

-(void)ReyCacheDelegateAllFinished:(ReyCache *)target faildArry:(NSArray *)faildArry;

-(void)ReyCacheDelegateFinished:(ReyCache *)target 
                                index:(int)index
                            isSuccess:(bool)isSuccess;

@end
