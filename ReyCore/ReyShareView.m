//
//  ReyShareView.m
//  shareTeset
//
//  Created by 慧彬 梁 on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyShareView.h"
#import "ReyLoading.h"

@interface ReyShareView()
    <UIWebViewDelegate>


@property (nonatomic , retain) UIWebView * m_webView;
@property (nonatomic , retain) ReyLoading * m_loadingView;
@property (nonatomic , retain) NSString * m_redirect;

-(void)initData;
-(void)reloadWebView;
@end

@implementation ReyShareView

@synthesize m_webView;
@synthesize m_loadingView;
@synthesize delegate;
@synthesize m_redirect;


- (id)initWithFrame:(CGRect)frame withRedirect:(NSString *)redirect
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if ([redirect hasPrefix:@"http://"]) {
            m_redirect = [[redirect substringFromIndex:7] retain];
        }
        else {
            m_redirect = [redirect retain];
        }
        
        
        
        [self initData];
        
    }
    return self;
}

-(void)dealloc
{
    [m_redirect release];
    
    if (m_webView) {
        [m_webView stopLoading];
        [m_webView release];
        m_webView = nil;
    }
    
    if (m_loadingView) {
        [m_loadingView release];
        m_loadingView = nil;
    }
    
    [super dealloc];
}

-(void)initData
{
    m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
    m_webView.delegate = self;
    
    [self addSubview:m_webView];
    
    
    m_loadingView = [[ReyLoading alloc] initWithFrame:CGRectMake(0, 0, 
                                                                 m_webView.frame.size.width, 
                                                                 m_webView.frame.size.height)];
    
    m_loadingView.hidden = NO;
    
    [self addSubview:m_loadingView];
    
    [m_loadingView startActivityView];
    m_loadingView.hidden = NO;
    
    
    UIImage * closeImg = [UIImage imageNamed:@"Rey_close"];
    UIImage * closeImgH = [UIImage imageNamed:@"Rey_closeH"];
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - closeImg.size.height, closeImg.size.width, closeImg.size.height)];
    [closeBtn setBackgroundImage:closeImg forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:closeImgH forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn release];
}

//加载特定请求
-(void)loadShareRequest:(NSURLRequest *)request
{
    [m_webView loadRequest:request];
}

//TODO: 刷新
-(void)reloadWebView
{
    [m_webView reload];
}

//移除webview
-(void)hideShareView
{
    [m_webView stopLoading];
    [self removeFromSuperview];
}


#pragma mark UIWebViewDelegate


-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
    
    
    if (!m_loadingView.hidden) {
        [m_loadingView stopActivityView];
        m_loadingView.hidden = YES;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError \n%@",[error description]);
    
    if (m_isSuccessed) {
        return;
    }
    
    if (m_loadingView.hidden) {
        [m_loadingView startActivityView];
        m_loadingView.hidden = NO;
    }
    
    if ([delegate respondsToSelector:@selector(ReyShareView:faildWithError:)]) {
        if ([delegate ReyShareView:self faildWithError:error]) {
            [self hideShareView];
//            [self performSelectorOnMainThread:@selector(hideShareView) withObject:nil waitUntilDone:NO];
        }
        else
        {
            [self reloadWebView];
        }
    }
//    
}


- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (m_loadingView.hidden) {
        [m_loadingView startActivityView];
        m_loadingView.hidden = NO;
    }
    
//    NSLog(@"shouldStartLoadWithRequest");
    
    NSURL * url = [request URL];
//    NSLog(@"%@",[url absoluteString]);
    
    NSString * redirect = [NSString stringWithFormat:@"%@%@",[url host],[url path]];
    //排除无用信息
    NSRange range = [redirect rangeOfString:m_redirect];
    if (!range.length) {
        return YES;
    }
    
    //response_type =code 
    NSString * query = [url query];
    
    if (!query) {
        //response_type =token 
        query = [url fragment];
    }

    if (query) {
        
        m_isSuccessed = YES;
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:query,@"query",[NSNumber numberWithInt:navigationType],@"navigationType", nil];
        [self performSelectorOnMainThread:@selector(onMainThread:) withObject:dic waitUntilDone:NO];
        
        return NO;
        
    }
    
    
    
    m_isSuccessed = NO;
    return YES;
}

-(void)onMainThread:(NSDictionary*)dic
{
    NSString * query = [dic objectForKey:@"query"];
    UIWebViewNavigationType navigationType = [[dic objectForKey:@"navigationType"] intValue];
    if (delegate && [delegate respondsToSelector:@selector(GetStringFromOauth:response:navigationType:)]) {
        BOOL result =[delegate GetStringFromOauth:self response:query navigationType:navigationType];
        
        if (result) {
            [self hideShareView];
            return;
        }
        else
        {
            return;
        }
    }
}

@end
