/************************************************* 
 
 Copyright (C), 2010-2015, Rey mail=>rey0@qq.com. 
 
 File name:	ReyZBar.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/2/20 
 
 Description: 
 
 条形码和二维码解析
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import <Foundation/Foundation.h>

@protocol ReyZBarDelegate;


@interface ReyZBar : NSObject

{
    id<ReyZBarDelegate> delegate;
    UIViewController * m_viewController;
}

@property (nonatomic , assign) id<ReyZBarDelegate> delegate;
@property (nonatomic , retain) UIViewController * m_viewController;

-(id)initWithDelegate:(id<ReyZBarDelegate>)Adelegate withViewController:(UIViewController *)viewController;
-(void)showReyZBar;


@end


@protocol ReyZBarDelegate <NSObject>

-(void)ReyZBarDidFinished:(ReyZBar *)reader text:(NSString *)text;

-(void)ReyZBarDidFaildToRead:(ReyZBar *)reader withRetry:(BOOL)retry;

@end