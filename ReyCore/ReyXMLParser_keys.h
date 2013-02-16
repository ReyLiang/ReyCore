/************************************************* 
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com 
 
 File name:	ReyXMLParser_keys.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/15 
 
 Description: 
 
 按键信息和界面信息下载解析文档.
 下载解析完成后,不回调delegate函数.
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 *************************************************/ 
#import <Foundation/Foundation.h>
#import "ReyXMLParser.h"
@interface ReyXMLParser_keys : ReyXMLParser
{
    NSMutableArray * currentArray;
    NSString * directory;

}
@property (nonatomic , retain) NSMutableArray * currentArray;
@property (nonatomic , retain) NSString * directory;


//aDirectory存储路径
-(id)initWithURL:(NSURL *)url 
       plistName:(NSString *)PlistName 
        postBody:(NSDictionary *)postBody 
        delegate:(id<ReyXMLParserDelegate>)aDelegate 
       directory:(NSString *)aDirectory;
@end
