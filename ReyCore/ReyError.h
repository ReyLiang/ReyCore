/************************************************* 
 
 Copyright (C), 2010-2020, yatou Tech. Co., Ltd. 
 
 File name:	ReyError.h	
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2011/12/13 
 
 Description: 
 
 错误提示类.支持本地化提示,不支持多线程模式下使用.多线程需要把ShowError放到mainThread上调用.
 
 Others: 
 
 
 
 forShort：
 
 
 History:  
 
 
 
 *************************************************/ 

#import <Foundation/Foundation.h>
#import "ReyAlert.h"


/**************************************************
 name:	ReySocketStatue
 
 description:  socket错误
 
 values: 
 
 calledby:  
 
 
 
 **************************************************/
typedef enum
{
    ReySocketStatueError,
    ReySocketStatueConnected,
    ReySocketStatueReceiving,
    ReySocketStatueSending,
    ReySocketStatueNO
} ReySocketStatue;


/**************************************************
 name:	ReyErrorType
 
 description:  socket错误
 
 values: 
 
 calledby:  
 
 
 
 **************************************************/
typedef enum
{
    ReyErrorTypeWarming,
    ReyErrorTypeError
} ReyErrorType;



@interface ReyError : NSObject

/************************************************* 
 
 Function: getLocalize: 
 
 Description: 获得本地化字符串
 
 Input:  
 
 key:	ReyError.strings文件中的key
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
+(NSString *)getLocalize:(NSString *)key;

/************************************************* 
 
 Function: ShowError: msg:
 
 Description: 获得本地化字符串
 
 Input:  
 
 title:	ReyError.strings文件中的key.用于UIAlertView的title.
 
 msg: ReyError.strings文件中的key.用于UIAlertView的message.
 
 Output:  
 
 Return: 
 
 Others: 
 
 *************************************************/
+(UIAlertView *)ShowError:(NSString *)title msg:(NSString *)msg errorType:(ReyErrorType)type;




+(ReyAlert *)ShowError:(NSArray *)btnTitles
             msg:(NSString *)msg 
       errorType:(ReyErrorType)type 
       superView:(UIView *)superView 
        delegate:(id)delegate 
             tag:(int)tag;

+(ReyAlert *)ShowNormalError:(NSArray *)btnTitles
                         msg:(NSString *)msg 
                   errorType:(ReyErrorType)type 
                   superView:(UIView *)superView 
                    delegate:(id)delegate 
                         tag:(int)tag;

+(ReyAlert *)ShowOutGame:(NSArray *)btnTitles
                     msg:(NSString *)msg 
               errorType:(ReyErrorType)type 
               superView:(UIView *)superView 
                delegate:(id)delegate 
                     tag:(int)tag;

+(ReyAlert *)ShowAutoDisconnect:(UIView *)superView 
                 delegate:(id)delegate ;

@end
