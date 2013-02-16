/************************************************* 
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com
 
 File name:	ReyXMLParser.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/1/24 
 
 Description: 
 
 用于xml文档解析(模板类)
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 2011/12/12 Rey 添加attributeDict获取.
 2011/12/14 Rey 去除[self release]调用,改由其上层调用.
 
 *************************************************/ 


#import <Foundation/Foundation.h>
#import "ReyDownload_Post.h"

@protocol ReyXMLParserDelegate;


@interface ReyXMLParser : NSObject 
	<ReyDownloadDelegate ,NSXMLParserDelegate>
{
	//大类名称,用于保存为本地文件时的文件名
	NSString * plistName;

	NSXMLParser * xmlParser;
	
	
	//单个MenuObject对应的数据
	NSMutableDictionary * dictionary;
	
	//MenuObject数组
	NSMutableArray * objectArray;
	
	//xml中item中包含的信息的数组
	NSArray * containArray;
	
	//当前item中Element名字和内容
	NSString *currentElementName;
	NSMutableString *currentText;
    NSDictionary * currentAttribute;
	
	ReyDownload * download;
	
	//防止没有下载完成,把自己释放掉
	bool isFinished;
	
	//防止没有下载完成,把自己释放掉
	bool isFailed;
	
	//是否为检测更新模式
	bool isCheckUpdate;
    
    //标识释放为自身释放类型
    bool isNeedReleaseSelf;
    
    //委托指针
    id<ReyXMLParserDelegate> delegate;
	
	
}

@property (nonatomic , retain) NSString * plistName;
@property (nonatomic , retain) NSXMLParser * xmlParser;
@property (nonatomic , retain) NSMutableDictionary * dictionary;
@property (nonatomic , retain) NSMutableArray * objectArray;
@property (nonatomic , retain) NSArray * containArray;
@property (nonatomic , retain) NSString *currentElementName;
@property (nonatomic , retain) NSMutableString *currentText;
@property (nonatomic , retain) NSDictionary * currentAttribute;

@property (nonatomic , retain) ReyDownload * download;

@property (nonatomic) bool isFinished;
@property (nonatomic) bool isFailed;
@property (nonatomic) bool isCheckUpdate;
@property (nonatomic) bool isNeedReleaseSelf;

@property (nonatomic , assign) id<ReyXMLParserDelegate> delegate;

+(id)startXMLParserWithURL:(NSURL *)url
                   plistName:(NSString *)PlistName 
                    postBody:(NSDictionary *)postBody 
                    delegate:(id<ReyXMLParserDelegate>)aDelegate;

-(id)initWithURL:(NSURL *)url 
       plistName:(NSString *)PlistName 
        postBody:(NSDictionary *)postBody 
        delegate:(id<ReyXMLParserDelegate>)aDelegate;

//初始化xml解析字段,方便继承类修改
-(void)initContainArray;

-(void)writeToPath;


@end

@protocol ReyXMLParserDelegate <NSObject>

-(void)XMLParseFinished:(ReyXMLParser *)xmlParser data:(id)parsedData;

-(void)XMLParseFailed:(ReyXMLParser *)xmlParser;

@end
