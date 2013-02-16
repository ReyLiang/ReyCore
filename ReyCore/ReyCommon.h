/*************************************************
 
 Copyright (C), 2010-2015, Rey mail=>rey0@qq.com.
 
 File name:	ReyCommon.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/2/5
 
 Description:
 
 公用类
 (该类由于涉及到其他工程,以后会详细拆封整理.)
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 
 
 *************************************************/

#import <Foundation/Foundation.h>

extern int ReyCommon_GameID;

//完整版,包含所有图片
//0,差量更新版本
#define VERSION_FULL 1


//log

#define REYDEBUG

#ifdef REYDEBUG

#define REYDEBUG_LOG(STR) NSLog(STR); 

#else

#define REYDEBUG_LOG(STR)

#endif


typedef enum {
    ReyDevice_iPhone = 1,
    ReyDevice_iPad,
    ReyDevice_iPhoneRetina,
    ReyDevice_iPadRetina
}ReyDevice;

@interface ReyCommon : NSObject

//TODO: 振动调用
+(void)invokeVibration;

//TODO: 显示AppStore中某个应用的评论
//主要用于提醒用户书写评论
+(void)showAppStoreCommentWithAppID:(int)appID;

//TODO: 获得系统版本
+(float)getSystemVersion;

//TODO: 获得设备标识
+(ReyDevice)getDevice;

+(void)addProximityWithObserver:(id)observer sel:(SEL)sel;




//TODO: 初始化帮助信息
+(void)initHelpInfo;

//TODO: 释放帮助信息
+(void)releaseHelpInfo;

//TODO: 用户显示帮助信息
+(void)ShowHelpView:(UIView *)superView 
         isVertical:(bool)isVertical 
             gameID:(int)gameID 
         isUserShow:(bool)isUserShow;



//TODO: 显示help界面
+(void)addHelpView:(UIView *)superView 
        isVertical:(bool)isVertical 
            gameID:(int)gameID 
        isUserShow:(bool)isUserShow;

+(CGPoint)getShowPoint:(int)gameID;

+(CGPoint)getJumpPoint:(int)gameID;

+(void)setHelpInfoShow:(int)gameID;

//获取图片
+(UIImage *)imageNamed:(NSString *)imgName;

//UIButton设置高亮模式
+(void)exchangeButtonBackgroundImage:(UIButton *)btn;

//TODO: 获得对应的ipad坐标
+(CGPoint)getLargePoint:(CGPoint)point;

//TODO: 强制旋转屏幕
+(void)forceRotateInterfaceOrientation:(UIInterfaceOrientation)orientation;

//获取APNS设备令牌
+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken;

//TODO: 从字符串中获得英文其中包含的英文个数
+(int)getEnglishCharacterLength:(NSString *)str;

//TODO: 字母顺序从小到达排序
+(NSArray *)sortChaFromSmallToLarge:(NSArray *)arry;


+(NSStringEncoding)getGBKEncoding;

+(CGRect)rescale:(CGRect)oldRect toRect:(CGRect)toRect;

+(UIImage *)getImageFromView:(UIView *)view;

@end
