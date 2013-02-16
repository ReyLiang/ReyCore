/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyDownload_Post.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/12 
 
 Description: 
 
 用于http下载模板类,使用post传值
 
 Others: 
 
 
 
 forShort：
 
 
 History:  

 
 
 *************************************************/ 

#import <Foundation/Foundation.h>
#import "ReyDownload.h"

@interface ReyDownload_Post : ReyDownload
{    
    //post的body值
    NSMutableString * strPostBody;
}
@property (nonatomic , retain) NSMutableString * strPostBody;

-(void)addPostFieldWithKey:(NSString *)key value:(NSString *)value;

+ (id)ReyDownloadWithURL:(NSURL * )url
                delegate:(id<ReyDownloadDelegate>) myDelegate
               postField:(NSDictionary *)postBody;

+ (id)ReyDownloadWithURL:(NSURL * )url
                delegate:(id<ReyDownloadDelegate>) myDelegate
               postField:(NSDictionary *)postBody
               extraData:(NSMutableDictionary *)extraData;

+ (id)ReyDownloadWithDelegate:(id<ReyDownloadDelegate>) myDelegate
                      request:(NSMutableURLRequest *)request;
@end
