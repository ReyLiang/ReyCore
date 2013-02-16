//
//  ReyLoation.h
//  ReyMapView
//
//  Created by rey liang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//可以同时具有多种类型
typedef enum {
    ReyLocationHeading = 0x001,
    ReyLocationLocation = 0x002,
    ReyLocationSignificant = 0x004
    
}ReyLocationType;


//减少delegate的函数
typedef enum {
    ReyLocationErrorAuthorization, //授权错误 errorData: CLAuthorizationStatus *
    ReyLocationErrorFailed, //locationManager错误 errorData: NSError *
    ReyLocationErrorRegion //区域检测错误 errorData: NSDictionary * (CLRegion * => @"region" , NSError * => @"error")
}ReyLocationError;


@protocol ReyLocationDelegate;


@interface ReyLocation : NSObject

{
    //
    CLLocationManager * m_locationMager;
    
    ReyLocationType m_type;
    
    
    id<ReyLocationDelegate> delegate;
    
    //是否已经授权
    bool m_authorization;
}

@property (nonatomic , retain) CLLocationManager * m_locationMager;

@property (nonatomic , assign) id<ReyLocationDelegate> delegate;


-(void)startRegion:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy;

-(void)startRegion:(CLRegion *)region;

//停止区域检测
-(void)stopRegion:(CLRegion *)region;


-(id)initWithDelegate:(id<ReyLocationDelegate>)Adelegate
                 type:(ReyLocationType)type
             accuracy:(CLLocationAccuracy)accuracy 
             distance:(CLLocationDistance)distance;
@end


@protocol ReyLocationDelegate <NSObject>

-(void)ReyLocationWithError:(ReyLocation *)sender 
                      Error:(ReyLocationError)error 
                  ErrorData:(void *)data;

-(void)ReyLocationWithLocation:(ReyLocation *)sender 
                    toLocation:(CLLocation *)toLocation 
                  fromLocation:(CLLocation *)fromLocation;

-(void)ReyLocationWithHeading:(ReyLocation *)sender
                      heading:(CLHeading *)heading;

-(void)ReyLocationWithEnterRegion:(ReyLocation *)sender
                           region:(CLRegion *)region;

-(void)ReyLocationWithExitRegion:(ReyLocation *)sender 
                          region:(CLRegion *)region;

@end
