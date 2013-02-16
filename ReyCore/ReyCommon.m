//
//  ReyCommon.m
//  ReyCore
//
//  Created by rey liang on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyCommon.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ReyHelpView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReyCommon



//初始化
NSMutableDictionary * helpInfoDic;
NSMutableDictionary * gameIDDic;

//TODO: 初始化帮助信息
+(void)initHelpInfo
{
    NSString  *helpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HelpInfo.plist"];
    
    //第一次初始化
    if (![[NSFileManager defaultManager] fileExistsAtPath:helpPath]) {
        NSString * helpSrcPath = [[NSBundle mainBundle] pathForResource:@"HelpInfo.plist" ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:helpSrcPath toPath:helpPath error:nil];
    }
    
    helpInfoDic = [[NSMutableDictionary alloc] initWithContentsOfFile:helpPath];
    
    
}

//TODO: 释放帮助信息
+(void)releaseHelpInfo
{
    if (helpInfoDic) {
        [helpInfoDic release];
        helpInfoDic = nil;
    }
}

//TODO: 自动显示帮助信息
//用户一进入界面就显示
+(void)ShowHelpView:(UIView *)superView 
         isVertical:(bool)isVertical 
             gameID:(int)gameID 
         isUserShow:(bool)isUserShow
{
    if (!isUserShow) {
        NSDictionary * dic = [helpInfoDic objectForKey:[NSString stringWithFormat:@"%d",gameID]];
        NSNumber * showNum = [dic objectForKey:@"show"];
        if (![showNum boolValue]) {
            return;
        }
    }
    
    
    [ReyCommon addHelpView:superView isVertical:isVertical gameID:gameID isUserShow:isUserShow];
}



//TODO: 显示help界面
+(void)addHelpView:(UIView *)superView 
        isVertical:(bool)isVertical 
            gameID:(int)gameID 
        isUserShow:(bool)isUserShow
{
    
    NSDictionary * dic = [helpInfoDic objectForKey:[NSString stringWithFormat:@"%d",gameID]];
    
    NSArray * imgNameArry = [dic objectForKey:@"images"];
    NSMutableArray * arry = [[NSMutableArray alloc] init];
    
    for (NSString * str in imgNameArry) {
        if (gameID == 1000) {
            UIImage * image = [UIImage imageNamed:str];
            [arry addObject:image];
        }
        else
          {
            UIImage * image = [ReyCommon imageNamed:str];
            [arry addObject:image];
          }
    }
    
    
    CGRect frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    ReyHelpView * helpView = [[ReyHelpView alloc] initWithFrame:frame 
                                                     isVertical:isVertical 
                                                   helpsImgArry:arry 
                                                     isUserShow:isUserShow 
                                                         gameID:gameID];
    [superView addSubview:helpView];
    [helpView release];
    [arry release];
}

//TODO: 获得设备标识
+(ReyDevice)getDevice
{
    
    NSString * ret = [[UIDevice currentDevice] model];
    NSRange range = [ret rangeOfString:@"iPad"];
    if (range.length) {
        //ipad
        return ReyDevice_iPad;
    }
    
    //iphone or ipod
    return ReyDevice_iPhone;
}

//TODO: 获得对应的ipad坐标
+(CGPoint)getLargePoint:(CGPoint)point
{
    if ([ReyCommon getDevice] == 1) {
        return point;
    }
    
    float x = point.x/480 * 1024;
    
    float y = point.y/320 * 768;
    
    return CGPointMake(x, y);
}

+(CGPoint)getShowPoint:(int)gameID
{
    NSDictionary * itemDic = [helpInfoDic objectForKey:[NSString stringWithFormat:@"%d",gameID]];
    NSString * point = [itemDic objectForKey:@"showPoint"];
    
    return [ReyCommon getLargePoint:CGPointFromString(point)];
}

+(CGPoint)getJumpPoint:(int)gameID
{
    NSDictionary * itemDic = [helpInfoDic objectForKey:[NSString stringWithFormat:@"%d",gameID]];
    NSString * point = [itemDic objectForKey:@"jumpPoint"];
    
    return [ReyCommon getLargePoint:CGPointFromString(point)];
}


+(void)setHelpInfoShow:(int)gameID
{
    NSDictionary * itemDic = [helpInfoDic objectForKey:[NSString stringWithFormat:@"%d",gameID]];
    
    NSMutableDictionary * newItemDic = [[NSMutableDictionary alloc] initWithDictionary:itemDic];
    
    [newItemDic setValue:[NSNumber numberWithBool:NO] forKey:@"show"];
    
    [helpInfoDic setValue:newItemDic forKey:[NSString stringWithFormat:@"%d",gameID]];
    [newItemDic release];
    
    NSString  *helpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HelpInfo.plist"];
    [helpInfoDic writeToFile:helpPath atomically:NO];
    
    
}


//TODO: 振动调用
+(void)invokeVibration
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

//TODO: 显示AppStore中某个应用的评论
//主要用于提醒用户书写评论
+(void)showAppStoreCommentWithAppID:(int)appID
{
    NSString *str = [NSString stringWithFormat:  
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",  
                     appID ];     
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//TODO: 获得系统版本
+(float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


//接近传感器
//播放声音的时候才能用
+(void)addProximityWithObserver:(id)observer sel:(SEL)sel
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel 
                                                 name:UIDeviceProximityStateDidChangeNotification 
                                               object:nil];
}


//获取图片
+(UIImage *)imageNamed:(NSString *)imgName
{
    UIImage * img ;
    
    if (VERSION_FULL) {
        img = [UIImage imageNamed:imgName];
    }
    else
      {
        if (!gameIDDic) {
            NSString * path = [[NSBundle mainBundle] pathForResource:@"GameList.plist" ofType:nil];
            gameIDDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
        }
        
        NSString * directory = [NSString stringWithFormat:@"Documents/%d/%@@2x.png",ReyCommon_GameID,imgName];
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:directory];
        img = [UIImage imageWithContentsOfFile:path];
        
      }
    
    return  img;
}

//UIButton设置高亮模式
+(void)exchangeButtonBackgroundImage:(UIButton *)btn
{
    UIImage * img = [[btn backgroundImageForState:UIControlStateNormal] retain];
    UIImage * imgH = [[btn backgroundImageForState:UIControlStateHighlighted] retain];
    [btn setBackgroundImage:imgH forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    
    [img release];
    [imgH release];
}


//TODO: 强制旋转屏幕
+(void)forceRotateInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = [window.subviews objectAtIndex:0];
    [view removeFromSuperview];
    [window addSubview:view];
    
    //强制转换 app store 有可能不通过
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//    {
//        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
//                                       withObject:(id)UIDeviceOrientationPortrait];
//    }
}

//获取APNS设备令牌
+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken
{
    NSMutableString * deviceTokenStr = [NSMutableString stringWithFormat:@"%@",deviceToken];
    
    NSRange allRang;
    allRang.location = 0;
    allRang.length = deviceTokenStr.length;
    
    [deviceTokenStr replaceOccurrencesOfString:@" " withString:@"" options:NULL range:allRang];
    
    NSRange begin = [deviceTokenStr rangeOfString:@"<"];
    
    NSRange end = [deviceTokenStr rangeOfString:@">"];
    
    NSRange deviceRange;
    deviceRange.location = begin.location + 1;
    deviceRange.length = end.location - begin.location -1;
    
    return [deviceTokenStr substringWithRange:deviceRange];
}

//TODO: 从字符串中获得英文其中包含的英文个数
+(int)getEnglishCharacterLength:(NSString *)str
{
    int engLength = 0;
    for (int i =0; i<[str length]; i++) {
        int character = [str characterAtIndex:i];
        if (character < 255) {
            engLength ++;
        }
    }
    
    return engLength;
}


+(NSArray *)sortChaFromSmallToLarge:(NSArray *)arry
{
    return [arry sortedArrayUsingSelector:@selector(compare:options:)];
}

//获得中文gbk编码
+(NSStringEncoding)getGBKEncoding
{
    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
}


//imageview的oldrect,要适配torect大小,等比例全部显示.
+(CGRect)rescale:(CGRect)oldRect toRect:(CGRect)toRect
{
    float imgWidth = oldRect.size.width;
    float imgHeight = oldRect.size.height;
    
    float imgRateWH = imgWidth/imgHeight;
    
    float viewRate = toRect.size.width/toRect.size.height;
    
    
    
    
    float newWidth , newHeight;
    float x,y;
    
    if (imgRateWH > 1) {
        
        
        if (imgRateWH < viewRate) {
            newHeight = toRect.size.height;
            //imgw/imgh = neww/newh
            newWidth = imgWidth/imgHeight*newHeight;
            
            x = -(newWidth - toRect.size.width)/2;
            y = 0;
            
        }
        else
        {
            newWidth = toRect.size.width;
            newHeight = imgHeight/imgWidth * newWidth;
            
            x = 0;
            y = -(newHeight - toRect.size.height)/2;
        }
    }
    else if (imgRateWH < 1)
    {
        
        
        if (imgRateWH < viewRate) {
            newHeight = toRect.size.height;
            //imgw/imgh = neww/newh
            newWidth = imgWidth/imgHeight*newHeight;
            
            x = -(newWidth - toRect.size.width)/2;
            y = 0;
            
        }
        else
        {
            newWidth = toRect.size.width;
            newHeight = imgHeight/imgWidth * newWidth;
            
            x = 0;
            y = -(newHeight - toRect.size.height)/2;
        }
    }
    else
    {
        if (toRect.size.width > toRect.size.height) {
            newHeight = toRect.size.height;
            //imgw/imgh = neww/newh
            newWidth = imgWidth/imgHeight*newHeight;
            
            x = -(newWidth - toRect.size.width)/2;
            y = 0;
        }
        else
        {
            newWidth = toRect.size.width;
            newHeight = imgHeight/imgWidth * newWidth;
            
            x = 0;
            y = -(newHeight - toRect.size.height)/2;
        }
    }
    
    
    
    CGRect newRect = CGRectMake(oldRect.origin.x + x, oldRect.origin.y + y, newWidth, newHeight);
    
    return newRect;
}

+(UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.layer.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end
