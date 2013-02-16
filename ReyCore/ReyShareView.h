/************************************************* 
 
 Copyright (C), 2012-2015, Rey mail=>rey0@qq.com.
 
 File name:	ReyShareView.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/8/14
 
 Description: 

 主要配合支持OAuth2.0的网页授权.

 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@protocol ReyShareViewDelegate;
@class ReyLoading;

@interface ReyShareView : UIView
{
    id<ReyShareViewDelegate> delegate;
    
    
    //================
    //private
    UIWebView * m_webView;
    
    ReyLoading * m_loadingView;
    
    NSString * m_redirect;
    
    BOOL m_isSuccessed;
}

@property (nonatomic , assign) id<ReyShareViewDelegate> delegate;

-(void)loadShareRequest:(NSURLRequest *)request;

- (id)initWithFrame:(CGRect)frame withRedirect:(NSString *)redirect;

@end


@protocol ReyShareViewDelegate <NSObject>

//return yes hide this view.
-(BOOL)GetStringFromOauth:(ReyShareView *)shareView response:(NSString *)response navigationType:(UIWebViewNavigationType)navigationType;
-(BOOL)ReyShareView:(ReyShareView *)sender faildWithError:(NSError *)error;

@end
