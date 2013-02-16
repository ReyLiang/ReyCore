/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyDownload.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/1/24 
 
 Description: 
 
 用于http下载模板类
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 2011/10/11 Rey 添加版本信息
 2011/12/12 Rey 添加post传递方式
 2013/01/30 Rey 为了实现ReyDownloadManager类.
                添加m_extraData变量及DownloadFinished:data:函数.
 
 
 *************************************************/ 

#import <Foundation/Foundation.h>

/**************************************************
 name:	NSURLdownloadImageDelegate
 
 description:  图片下载的委托
 
 input: 下载好的图片
 
 calledby:  
 
 
 **************************************************/

@protocol ReyDownloadDelegate <NSObject>

//TODO: deprecated,please use DownloadFinished:data:
-(void)DownloadFinished:(id)downloaded;


//13-01-30 由ReyDownloadManager需求产生.
-(void)DownloadFinished:(id)sender data:(id)downloaded;

//每次接收到数据回调函数
-(void)receiveData:(NSData *)data;

//TODO: deprecated,please use DownloadFailed:error:
-(void)DownloadFailed:(NSError *)error;

//13-01-30 由ReyDownloadManager需求产生.
-(void)DownloadFailed:(id)sender error:(NSError *)error;

//主要用于通知文件大小,如果未知,则传-1
-(void)didReceiveResponse:(long long )totalSize;

-(void)didReceiveWithResponse:(NSHTTPURLResponse *)response;
@end



@interface ReyDownload : NSObject 
{
	
	/**************************************************
	 name:	delegate
	 
	 description:  调用本类的委托
	 
	 values: ReyDownloadDelegate
	 
	 calledby:  
	 
	 
	 
	 **************************************************/
	id<ReyDownloadDelegate> delegate;
    
	/**************************************************
	 name:	m_request
	 
	 description:  url请求数据
	 
	 values: NSMutableURLRequest *
	 
	 calledby:
	 
	 
	 
	 **************************************************/
    NSMutableURLRequest * m_request;
	
	
	/**************************************************
	 name:	myData
	 
	 description:  用于存储下载好的数据
	 
	 values: NSMutableData
	 
	 calledby:  
	 
	 
	 
	 **************************************************/
	NSMutableData * myData;
	
	
	/**************************************************
	 name:	Connection
	 
	 description:  用于建立链接
	 
	 values: NSURLConnection
	 
	 calledby:  
	 
	 
	 
	 **************************************************/
	NSURLConnection * Connection;
	
	
	/**************************************************
	 name:	finished
	 
	 description:  用于抛出的多线程跟进状态
	 
	 values: bool
	 
	 calledby:  
	 
	 
	 
	 **************************************************/
	bool finished;
	
	
	/**************************************************
	 name:	totaleFileSize
	 
	 description:  下载文件的大小
	 
	 values: bool
	 
	 calledby:  
	 
	 
	 
	 **************************************************/
	long long totaleFileSize;
    
    /**************************************************
	 name:	m_autoRelease
	 
	 description:  自动释放模式
	 
	 values: bool
	 
	 calledby:  
	 
	 
	 
	 **************************************************/
	bool m_autoRelease;
    
    NSTimer * cancleTimer;
    
    int m_cancelTimer;
    
    //存放额外数据.由ReyDownloadManager需求产生.
    NSMutableDictionary * m_extraData;
	
}

@property (nonatomic , assign) id<ReyDownloadDelegate> delegate;
@property (nonatomic , retain) NSMutableURLRequest * m_request;
@property (nonatomic , assign) NSMutableData * myData;
@property (nonatomic , assign) NSURLConnection * Connection;
@property (nonatomic) bool finished;
@property (nonatomic) bool m_autoRelease;
@property (nonatomic , retain) NSTimer * cancleTimer;
@property (nonatomic , retain) NSMutableDictionary * m_extraData;


/************************************************* 
 
 Function: ReyDownloadWithURL: delegate:
 
 Description: 模拟oc做的自动释放函数
 
 Input:  
 
 url:	图片的url地址
 
 delegate: 委托
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
+ (id)ReyDownloadWithURL:(NSURL * )url delegate:(id<ReyDownloadDelegate>) myDelegate;


/*************************************************
 
 Function: ReyDownloadWithURL: delegate: extraData:
 
 Description: 模拟oc做的自动释放函数
 
 Input:
 
 url:	图片的url地址
 
 delegate: 委托
 
 extraData: 额外数据由ReyDownloadManager而生
 
 Output:
 
 Return:
 
 Others:
 
 *************************************************/
+ (id)ReyDownloadWithURL:(NSURL * )url
                delegate:(id<ReyDownloadDelegate>) myDelegate
               extraData:(NSMutableDictionary *)extraData;


/************************************************* 
 
 Function: ReyDownloadWithURL: delegate: request:
 
 Description: 模拟oc做的自动释放函数
 
 Input:  
 
 url:	图片的url地址
 
 delegate: 委托
 
 request:  请求数据
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
+ (id)ReyDownloadWithDelegate:(id<ReyDownloadDelegate>) myDelegate
                     request:(NSMutableURLRequest *)request;


/************************************************* 
 
 Function: downloadWithURL: 
 
 Description: 初始化本类并进行下载
 
 Input:  
 
 url:	图片的url地址
 
 delegate: 委托
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
- (void)downloadWithURL:(NSURL * )url delegate:(id<ReyDownloadDelegate>) myDelegate;


/************************************************* 
 
 Function: delegateSelector: 
 
 Description: 执行协议函数
 //TODO: - (void)connectionDidFinishLoading:(NSURLConnection *)connection 继承类可以重载
 //TODO: -(void)delegateSelector:(id)downloaded 继承类可以重载
 Input:  
 
 url:	图片的url地址
 
 delegate: 委托
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/

-(void)delegateSelector:(id)downloaded;


/************************************************* 
 
 Function: startDownload: 
 
 Description: 多线程下载,稍慢
 
 Input:  
 
 url:	图片的url地址
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)startDownload:(NSURL *)url;

/************************************************* 
 
 Function: startDownloadWithMainThread: 
 
 Description: 主线程上下载,快
 
 Input:  
 
 url:	图片的url地址
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
-(void)startDownloadWithMainThread:(NSURL *)url;

-(void)FailedSelector:(NSError *)error;

-(void)connectCancel;
@end
