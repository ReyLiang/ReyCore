//
//  ReyWebViewController.m
//  ReyHTML5View
//
//  Created by rey liang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyWebViewController.h"
#import "ReyCommon.h"

@interface ReyWebViewController ()
    <UIWebViewDelegate>
@property (nonatomic , retain) ReyWebView * m_webView;
@property (nonatomic , retain) ReyLoading * m_loadingView;
//@property (nonatomic , retain) UIActivityIndicatorView * m_loadingView ;

-(void)backController;

-(NSURLRequest *)getRequestWithURL:(NSURL *)requestUrl;
@end

@implementation ReyWebViewController

@synthesize m_webView;
@synthesize m_loadingView;
//@synthesize m_loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [ReyCommon forceRotateInterfaceOrientation:UIInterfaceOrientationPortrait];
    
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self.navigationController set

//    [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    

}

-(void)viewDidDisappear:(BOOL)animated
{
    if (m_webView) {
        [m_webView release];
        m_webView = nil;
    }
    
    [ReyCommon forceRotateInterfaceOrientation:[[UIDevice currentDevice] orientation]];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    
    // Release any retained subviews of the main view.
    if (m_webView) {
        [m_webView release];
        m_webView = nil;
    }
    
//    [super viewDidUnload];
    
    if (m_loadingView) {
        [m_loadingView release];
        m_loadingView = nil;
    }
    
    [super viewDidUnload];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    if (m_loadingView) {
        [m_loadingView release];
        m_loadingView = nil;
    }
    if (m_webView) {
        [m_webView release];
        m_webView = nil;
    }
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    float bigger;
    float smaller;
    if (self.view.frame.size.width > self.view.frame.size.height) {
        bigger = self.view.frame.size.width;
        smaller = self.view.frame.size.height;
    }
    else {
        bigger = self.view.frame.size.height;
        smaller = self.view.frame.size.width;
    }
    if (UIInterfaceOrientationPortrait == interfaceOrientation || UIInterfaceOrientationPortraitUpsideDown == interfaceOrientation) {
        self.view.frame = CGRectMake(0, 0, smaller, bigger);
        m_webView.frame = CGRectMake(0, 0, smaller, bigger);
        m_loadingView.frame = CGRectMake(0, 0, smaller, bigger);
        
    }
    else {
        
//        self.view.frame = CGRectMake(0, 0, smaller, bigger);
//        m_webView.frame = CGRectMake(0, 0, smaller, bigger);
//        m_loadingView.frame = CGRectMake(0, 0, smaller, bigger);
        //不支持横屏
        return NO;
        
        self.view.frame = CGRectMake(0, 0, bigger, smaller);
        m_webView.frame = CGRectMake(0, 0, bigger, smaller);
        m_loadingView.frame = CGRectMake(0, 0, bigger, smaller);
        
    }
    
    [self.view setNeedsDisplay];
    
//    m_loadingView.center = m_webView.center;
    
//    NSLog(@"@@@@@@@@@@@@@@@@ %d %@",interfaceOrientation,NSStringFromCGRect(self.view.frame));
    return YES;
}

//TODO: 隐藏viewController
-(void)backController
{
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


//初始化webview
-(void)initWebViewWithURL:(NSURL *)requestUrl
{
    m_webView = [[ReyWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    m_webView.delegate = self;
    m_webView.scalesPageToFit = YES;
    m_webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_webView];
    
    [m_webView loadRequest:[self getRequestWithURL:requestUrl]];
    
    
    m_loadingView = [[ReyLoading alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 
                                                                 self.view.frame.size.height)];

    m_loadingView.hidden = NO;
    
    [self.view addSubview:m_loadingView];
    
    
    
    UIImage * image = [UIImage imageNamed:@"back1"];
    UIImage * imageH = [UIImage imageNamed:@"back1H"];
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 
                                                                    image.size.width, 
                                                                    image.size.height)];
    [backBtn addTarget:self action:@selector(backController) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
    
    [self.view addSubview:backBtn];
    
    [backBtn release];
}

//TODO: 重载预留 如需支持Post继承该函数
-(NSURLRequest *)getRequestWithURL:(NSURL *)requestUrl
{
    NSMutableURLRequest * request = [[[NSMutableURLRequest alloc] initWithURL:requestUrl] autorelease];
    
    return request;
}

//TODO: 刷新
-(void)reloadWebView
{
    [m_webView reload];
}


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
//    NSLog(@"didFailLoadWithError");
    
    if (m_loadingView.hidden) {
        [m_loadingView startActivityView];
        m_loadingView.hidden = NO;
    }
    
    [self reloadWebView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSURL * url = [request URL];
//    NSLog(@"shouldStartLoadWithRequest \n %@ \n",[url absoluteString]);
    
    if (m_loadingView.hidden) {
        [m_loadingView startActivityView];
        m_loadingView.hidden = NO;
    }

    
    return YES;
}

@end
