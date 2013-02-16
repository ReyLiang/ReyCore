//
//  ReyDownload_soap.h
//  ReyCore
//
//  Created by 慧彬 梁 on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReyDownload_Post.h"

@interface ReyDownload_soap : ReyDownload_Post
{
    //soap操作里webserver中规定的xmlns.
    NSString * soap_xmlns_tag;
    NSString * soap_xmlns_space;
    
    //soap操作定义.调用方法名称
    NSString * soap_action;
    
    //postbody items
    NSMutableArray * soap_itemsArry;
    
    
    
}

@property (nonatomic , retain) NSString * soap_xmlns_tag;
@property (nonatomic , retain) NSString * soap_xmlns_space;
@property (nonatomic , retain) NSString * soap_action;

@property (nonatomic , retain) NSMutableArray * soap_itemsArry;


+ (id)ReyDownloadWithURL:(NSURL * )url 
                delegate:(id<ReyDownloadDelegate>) myDelegate 
               postField:(NSDictionary *)postBody;
@end
