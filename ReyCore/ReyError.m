/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyError.m
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/13 
 
 Description: 
 
 错误提示类.支持本地化提示,不支持多线程模式下使用.多线程需要把ShowError放到mainThread上调用.
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import "ReyError.h"
#import "ReyAutoDisconnAlert.h"
#import "ReyOutGameAlert.h"




@implementation ReyError

#define IOS

//title,msg输入时直接输入ReyErro.strings中的key.
//需要添加确定响应
+(UIAlertView *)ShowError:(NSString *)title msg:(NSString *)msg errorType:(ReyErrorType)type
{
#ifdef IOS
    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:[ReyError getLocalize:title] 
                                                     message:[ReyError getLocalize:msg] 
                                                    delegate:self 
                                           cancelButtonTitle:[ReyError getLocalize:@"SUBMIT"] 
                                           otherButtonTitles: nil] autorelease];
    [alert show];
    
    return alert;
    
    
#else   

#endif
}

+(ReyAlert *)ShowError:(NSArray *)btnTitles
                   msg:(NSString *)msg 
             errorType:(ReyErrorType)type 
             superView:(UIView *)superView 
              delegate:(id)delegate 
                   tag:(int)tag
{
    
    
    UIImage * bgImg = [UIImage imageNamed:@"Rey_CA_bgimg"];
    UIImage * btnImg = [UIImage imageNamed:@"Rey_CA_btnBgimg"];
    UIImage * btnImgH = [UIImage imageNamed:@"Rey_CA_btnBgimgH"];
    
    NSMutableArray * imgsArry = [[NSMutableArray alloc] init];
    NSMutableArray * titlesArry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [btnTitles count]; i++) {
        [imgsArry addObject:btnImg];
        [imgsArry addObject:btnImgH];
        [titlesArry addObject:[ReyError getLocalize:[btnTitles objectAtIndex:i]]];
    }
    
    ReyAlert * test = [[[ReyAlert alloc] initWithFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height) 
                                              delegate:delegate 
                                       backgroundImage:bgImg 
                                               message:[ReyError getLocalize:msg] 
                                            buttonImgs:imgsArry 
                                          buttonTitles:btnTitles 
                                                   tag:tag] autorelease];
    if ( UIDeviceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]) ) 
    {
        test.frame = CGRectMake(0, 0, 480, 320);
    }
    else {
        test.frame = CGRectMake(0, 0, 320, 480);
    }
    [superView addSubview:test];
    [imgsArry release];
    [titlesArry release];
    return test;
    
}


//TODO: msg不带本地化的
+(ReyAlert *)ShowNormalError:(NSArray *)btnTitles
                   msg:(NSString *)msg 
             errorType:(ReyErrorType)type 
             superView:(UIView *)superView 
              delegate:(id)delegate 
                   tag:(int)tag
{
    
    
    UIImage * bgImg = [UIImage imageNamed:@"Rey_CA_bgimg"];
    UIImage * btnImg = [UIImage imageNamed:@"Rey_CA_btnBgimg"];
    UIImage * btnImgH = [UIImage imageNamed:@"Rey_CA_btnBgimgH"];
    
    NSMutableArray * imgsArry = [[NSMutableArray alloc] init];
    NSMutableArray * titlesArry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [btnTitles count]; i++) {
        [imgsArry addObject:btnImg];
        [imgsArry addObject:btnImgH];
        [titlesArry addObject:[ReyError getLocalize:[btnTitles objectAtIndex:i]]];
    }

    ReyAlert *test = [[[ReyAlert alloc] initWithFrame:CGRectMake(0, 0, 
                                                                  superView.frame.size.width, 
                                                                  superView.frame.size.height) 
                                              delegate:delegate 
                                       backgroundImage:bgImg 
                                               message:msg 
                                            buttonImgs:imgsArry 
                                          buttonTitles:btnTitles 
                                                   tag:tag] autorelease];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) 
    {
        test.frame = CGRectMake(0, 0, 480, 320);
    }
    else {
        test.frame = CGRectMake(0, 0, 320, 480);
    }
    [superView addSubview:test];
    [imgsArry release];
    [titlesArry release];
    return test;
    
}


+(ReyAlert *)ShowOutGame:(NSArray *)btnTitles
                   msg:(NSString *)msg 
             errorType:(ReyErrorType)type 
             superView:(UIView *)superView 
              delegate:(id)delegate 
                   tag:(int)tag
{
    
    
    UIImage * bgImg = [UIImage imageNamed:@"Rey_CA_bgimg"];
    UIImage * btnImg = [UIImage imageNamed:@"Rey_CA_btnBgimg"];
    UIImage * btnImgH = [UIImage imageNamed:@"Rey_CA_btnBgimgH"];
    
    NSMutableArray * imgsArry = [[NSMutableArray alloc] init];
    NSMutableArray * titlesArry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [btnTitles count]; i++) {
        [imgsArry addObject:btnImg];
        [imgsArry addObject:btnImgH];
        [titlesArry addObject:[ReyError getLocalize:[btnTitles objectAtIndex:i]]];
    }
    
    ReyOutGameAlert * test = [[[ReyOutGameAlert alloc] initWithFrame:CGRectMake(0, 0, 
                                                                  superView.frame.size.width, 
                                                                  superView.frame.size.height) 
                                              delegate:delegate 
                                       backgroundImage:bgImg 
                                               message:[ReyError getLocalize:msg] 
                                            buttonImgs:imgsArry 
                                          buttonTitles:btnTitles 
                                                   tag:tag] autorelease];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) 
    {
        test.frame = CGRectMake(0, 0, 480, 320);
    }
    else {
        test.frame = CGRectMake(0, 0, 320, 480);
    }
    
    [superView addSubview:test];
    [imgsArry release];
    [titlesArry release];
    return test;
    
}


+(ReyAlert *)ShowAutoDisconnect:(UIView *)superView 
                 delegate:(id)delegate 

{
    
    NSArray * btnTitles = [NSArray arrayWithObjects:@"继续游戏",@"断开链接", nil];
    NSString * msg = @"AUTODISCONNECT TITLE";
    
    UIImage * bgImg = [UIImage imageNamed:@"Rey_CA_bgimg"];
    UIImage * btnImg = [UIImage imageNamed:@"Rey_CA_btnBgimg"];
    UIImage * btnImgH = [UIImage imageNamed:@"Rey_CA_btnBgimgH"];
    
    NSMutableArray * imgsArry = [[NSMutableArray alloc] init];
    NSMutableArray * titlesArry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [btnTitles count]; i++) {
        [imgsArry addObject:btnImg];
        [imgsArry addObject:btnImgH];
        [titlesArry addObject:[ReyError getLocalize:[btnTitles objectAtIndex:i]]];
    }
    
    ReyAutoDisconnAlert * test = [[[ReyAutoDisconnAlert alloc] initWithFrame:CGRectMake(0, 0, 480, 320) 
                                                                   delegate:delegate 
                                                            backgroundImage:bgImg 
                                                                    message:[ReyError getLocalize:msg] 
                                                                 buttonImgs:imgsArry 
                                                               buttonTitles:btnTitles 
                                                                        tag:0] autorelease];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) 
    {
        test.frame = CGRectMake(0, 0, 480, 320);
    }
    else {
        test.frame = CGRectMake(0, 0, 320, 480);
    }
    [superView addSubview:test];
    [imgsArry release];
    [titlesArry release];
    return test;
    
}



+(void)showAlertOnMainThread:(NSDictionary *)dic
{
    
}

+(NSString *)getLocalize:(NSString *)key
{
    return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:@"ReyError"];
}


@end
