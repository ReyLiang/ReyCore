//
//  ReyWebViewController.h
//  ReyHTML5View
//
//  Created by rey liang on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReyWebView.h"
#import "ReyLoading.h"

@interface ReyWebViewController : UIViewController
{
    ReyWebView * m_webView;
    
    
    //设备标示
    int m_deviceTag;
    
    ReyLoading * m_loadingView;
    
}



-(void)initWebViewWithURL:(NSURL *)requestUrl;
-(void)reloadWebView;

@end
