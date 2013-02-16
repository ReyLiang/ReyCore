//
//  ReyDownload.m
//  ReyScrollView
//
//  Created by I Mac on 11-1-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReyDownload.h"

@interface ReyDownload()
    <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
//TODO: 获得request,方便post子类重载.
-(NSMutableURLRequest *)getRequestWithURL:(NSURL *)url;
@end

@implementation ReyDownload

@synthesize delegate;
@synthesize m_request;
@synthesize Connection,myData;
@synthesize finished;
@synthesize m_autoRelease;
@synthesize cancleTimer;
@synthesize m_extraData;



+ (id)ReyDownloadWithDelegate:(id<ReyDownloadDelegate>) myDelegate
                 request:(NSMutableURLRequest *)request
{
    
    ReyDownload * autoRelese = [[ReyDownload alloc] init];
    autoRelese.m_autoRelease = YES;
    autoRelese.m_request = request;
    
    [autoRelese downloadWithURL:nil delegate:myDelegate];
    
    return autoRelese;
    
    
}

//模拟oc做的自动释放函数
+ (id)ReyDownloadWithURL:(NSURL * )url delegate:(id<ReyDownloadDelegate>) myDelegate
{
    ReyDownload * autoRelese = [[ReyDownload alloc] init];
    autoRelese.m_autoRelease = YES;
    [autoRelese downloadWithURL:url delegate:myDelegate];
    
    return autoRelese;
}

+ (id)ReyDownloadWithURL:(NSURL * )url
                delegate:(id<ReyDownloadDelegate>) myDelegate
               extraData:(NSMutableDictionary *)extraData
{
    ReyDownload * autoRelese = [[ReyDownload alloc] init];
    autoRelese.m_autoRelease = YES;
    autoRelese.m_extraData = extraData;
    [autoRelese downloadWithURL:url delegate:myDelegate];
    
    return autoRelese;
}



- (void)downloadWithURL:(NSURL * )url delegate:(id<ReyDownloadDelegate>) myDelegate
{
	
	delegate = myDelegate;
    m_cancelTimer = 0;
	
	[NSThread detachNewThreadSelector:@selector(startDownload:) toTarget:self withObject:url];
	//[self startDownloadWithMainThread:url];
	
	
}

//TODO: 获得request,方便post子类重载.
-(NSMutableURLRequest *)getRequestWithURL:(NSURL *)url
{
    if (m_request) {
        
        cancleTimer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(cancelTimer) userInfo:nil repeats:NO] retain];
        
        return m_request;
    }
    NSMutableURLRequest * request =[[[NSMutableURLRequest alloc] init]autorelease];
	[request setTimeoutInterval:10];
	[request setURL:url];
    
    cancleTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cancelTimer) userInfo:nil repeats:NO] retain];
    return request;
}


-(void)cancelTimer
{
    if (m_cancelTimer == 10) {
        [self ConnectFailed];
        return;
    }
    
    m_cancelTimer++;
}

-(void)connectCancel
{
    if (Connection) {
        [Connection cancel];
        [Connection release];
        Connection = nil;
    }
}

-(void)ConnectFailed
{
    //NSLog(@"connection cancle");
    if (Connection) {
        [Connection cancel];
        [Connection release];
        Connection = nil;
        finished = YES;
        if ([delegate respondsToSelector:@selector(DownloadFailed:)]) {
            [self FailedSelector:nil];
        }
    }
	
}

//TODO: 主线程上下载,快
-(void)startDownloadWithMainThread:(NSURL *)url
{
	myData = [[NSMutableData alloc] init];
	NSMutableURLRequest * request =[self getRequestWithURL:url];
	Connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//TODO: 多线程下载,稍慢
-(void)startDownload:(NSURL *)url
{
	//	sleep(1);
	NSAutoreleasePool * pool =[[NSAutoreleasePool alloc] init];
	
	myData = [[NSMutableData alloc] init];
	////NSLog(@"%@",url);
    
//    NSLog(@"ReyDownload thread start");
	
	NSMutableURLRequest * request =[self getRequestWithURL:url];	
	Connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (Connection) {
		//用于接收链接消息
		while(!finished) {
			
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
			
			
		}
	}
	else {
		//NSLog(@"connec to url is failed!");
	}

	
//    NSLog(@"ReyDownload thread finish");
	if (m_autoRelease) {
        [self release];
    }
	[pool release];
	
}

- (void)dealloc {
	//NSLog(@"ReyDownload dealloc");
    
    if (m_extraData) {
        [m_extraData release];
        m_extraData = nil;
    }
    
    if (m_request) {
        [m_request release];
        m_request = nil;
    }
    if (cancleTimer) {
        [cancleTimer invalidate];
        [cancleTimer release];
        cancleTimer = NULL;
    }
    
	if (!finished) {
        finished = YES;
		[Connection cancel];
        
	}
	if ([myData length]) {
		[myData release];
		myData = nil;
	}
	if (Connection) {
		[Connection release];
		Connection = nil;
	}
    [super dealloc];
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
//    NSLog(@"%d,%d,%d",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    
    m_cancelTimer = 0;
    
}
//TODO: 接收回复,用于初始化进度条
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //已经连上server,无需cancle计时器
    if (cancleTimer) {
        [cancleTimer invalidate];
        [cancleTimer release];
        cancleTimer = NULL;
    }
    
    if ([delegate respondsToSelector:@selector(didReceiveWithResponse:)]) {
        [delegate didReceiveWithResponse:(NSHTTPURLResponse *)response];
    }
    
	if ([response expectedContentLength] != NSURLResponseUnknownLength) {
		totaleFileSize = [response expectedContentLength];
		if ([delegate respondsToSelector:@selector(didReceiveResponse:)]) {
			[delegate didReceiveResponse:totaleFileSize];
		}
	}
	else {
		if ([delegate respondsToSelector:@selector(didReceiveResponse:)]) {
			[delegate didReceiveResponse:-1];
		}
	}


}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	////NSLog(@"didReceiveData  %@",[NSThread currentThread]strin]);
    [self.myData appendData:data];
	if ([delegate respondsToSelector:@selector(receiveData:)]) {
		[delegate receiveData:myData];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    if (Connection) {
		[Connection release];
		Connection = nil;
	}
    
    //error
    //NSLog(@"connection failed");
    //NSLog(@"%@",[error description]);
    
    
    
	if ([delegate respondsToSelector:@selector(DownloadFailed:)]) {
		[self FailedSelector:error];
	}
    
	finished = YES;
	
}
-(void)FailedSelector:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(DownloadFailed:error:)]) {
        [delegate DownloadFailed:self error:error];
        return;
    }
	[delegate DownloadFailed:error];
}

//TODO: 继承类可以重载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	
//	//判断有无响应delegate和实现协议函数
//	NSAssert(delegate&&[delegate respondsToSelector:@selector(DownloadFinished:)],
//			 @"\n\n\nNSURLdownloadImage's   connectionDidFinishLoading: error!\n Description: \
//			 delegate == nil or didn't respond to selector (DownloadImageFinished:)\n\n\n");
	
	//在主线程中加载
	//[self performSelectorOnMainThread:@selector(delegateSelector:) withObject:self.myData waitUntilDone:NO];
	
	//在多线程中加载
	[self delegateSelector:self.myData];
	
	
    
	
	// Clear the activeDownload property to allow later attempts
	if ([myData length]) {
		[myData release];
		myData = nil;
	}
    
    
    // Release the connection now that it's finished
	if (Connection) {
		[Connection release];
		Connection = nil;
	}
	finished = YES;
}

//TODO: 继承类可以重载
-(void)delegateSelector:(id)downloaded
{
    if ([delegate respondsToSelector:@selector(DownloadFinished:data:)]) {
        [delegate DownloadFinished:self data:downloaded];
        
        return;
    }
    
    if ([delegate respondsToSelector:@selector(DownloadFinished:)]) {
        [delegate DownloadFinished:downloaded];
        
        return;
    }
	
}
#pragma mark -


@end
