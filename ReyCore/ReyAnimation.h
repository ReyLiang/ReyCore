/*************************************************
 
 Copyright (C), 2010-2015, Rey  rey0@qq.com
 
 File name:	ReyAnimation.h
 
 Author: Rey
 
 Version: 1.0
 
 Date: 2012/1/15
 
 Description:
 
 动画集成类
 
 Others:
 
 
 
 forShort：
 
 
 History:
 
 *************************************************/

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    ReyAnimationRockDirectionRandom = 0,
    ReyAnimationRockDirectionLeft,
    ReyAnimationRockDirectionRight
}ReyAnimationRockDirection;

@interface ReyAnimation : NSObject

//获得一个animation
+(CAAnimation *)GetOpacityAnimation:(float)fromValue toValue:(float)toValue;
+(CAAnimation *)GetPointMoveBasicAnimation:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
+(CAAnimation *)GetRotationBasicAnimation:(float)fromAngle toAngle:(float)toAngle;
+(CAAnimation *)GetTransform3DBasicAnimation:(CATransform3D)startTransform3D 
                                         end:(CATransform3D)endTransform3D;
+(CAAnimation *)GetAffineTransformBasicAnimation:(CGAffineTransform)startAffineTransform 
                                             end:(CGAffineTransform)endAffineTransform;

+(CAAnimation *)GetPointMoveKeyAnimationWithShake:(int)shakeCount 
                                   shakeDirection:(bool)isVertical 
                                       startPoint:(CGPoint)startPoint 
                                         endPoint:(CGPoint)endPoint;
+(CAAnimation *)GetRockerKeyAnimation:(float)angle direction:(ReyAnimationRockDirection)direction;


//TODO: 放大缩小的animation
//shakeCount颤抖次数
//scalesize是缩放后的长度比缩放前的
//isFromView YES,从view缩放,NO,缩放到view大小
+(CAAnimation *)GetKeyAnimationWithScale:(CGSize)scaleSize
                             transform3D:(CATransform3D)transform
                              isFromView:(BOOL)isFromView;
//TODO: 放大缩小的animation
+(CAAnimation *)GetKeyAnimationWithScaleRect:(CGRect)scaleRect
                                 transform3D:(CATransform3D)transform
                                  isFromView:(BOOL)isFromView;




//为view设置一个animation
+(void)SetPointMoveBasicAnimation:(UIView *)targetView 
                         delegate:(id)delegate 
                              key:(NSString *)key
                         duration:(float)duration
                       startPoint:(CGPoint)startPoint 
                         endPoint:(CGPoint)endPoint;

+(void)SetPointMoveShakeAnimation:(UIView *)targetView 
                         delegate:(id)delegate 
                              key:(NSString *)key
                       shakeCount:(int)shakeCount
                       isVertical:(bool)isVertical
                         duration:(float)duration
                       startPoint:(CGPoint)startPoint 
                         endPoint:(CGPoint)endPoint;


+(void)SetRockerKeyAnimation:(UIView *)targetView 
                    delegate:(id)delegate 
                         key:(NSString *)key
                    duration:(float)duration
                       angle:(float)angle 
                   direction:(ReyAnimationRockDirection)direction;


+(void)SetRockerKeyAnimation:(UIView *)targetView 
                    delegate:(id)delegate 
                         key:(NSString *)key
                    duration:(float)duration
                       angle:(float)angle;

+(void)SetScaleKeyAnimation:(UIView *)targetView 
                   delegate:(id)delegate 
                        key:(NSString *)key
                   duration:(float)duration 
                  scaleSize:(CGSize)scaleSize;

+(void)SetScaleKeyAnimation:(UIView *)targetView
                   delegate:(id)delegate
                        key:(NSString *)key
                   duration:(float)duration
                  scaleSize:(CGSize)scaleSize
                 isFromView:(BOOL)isFromView;

+(void)SetScaleRectKeyAnimation:(UIView *)targetView
                       delegate:(id)delegate
                            key:(NSString *)key
                       duration:(float)duration
                      scaleRect:(CGRect)scaleRect
                     isFromView:(BOOL)isFromView;

+(void)SetFlipKeyAnimation:(UIView *)targetView
                  delegate:(id)delegate
                       key:(NSString *)key
                      time:(float)time;

+(void)SetRotationBasicAnimation:(UIView *)targetView
                        delegate:(id)delegate
                             key:(NSString *)key
                        duration:(float)duration
                       fromAngle:(float)fromAngle
                         toAngle:(float)toAngle;

+(void)SetOpacityBasicAnimation:(UIView *)targetView
                       delegate:(id)delegate
                            key:(NSString *)key
                       duration:(float)duration
                      fromValue:(float)fromValue
                        toValue:(float)toValue;

@end
