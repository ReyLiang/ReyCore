//
//  ReyLoation.m
//  ReyMapView
//
//  Created by rey liang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyLocation.h"

@interface ReyLocation() 
    <CLLocationManagerDelegate>

-(void)startLocationManager;
-(void)stopLocationManager;
@end

@implementation ReyLocation

@synthesize m_locationMager;
@synthesize delegate;


-(id)initWithDelegate:(id<ReyLocationDelegate>)Adelegate
                 type:(ReyLocationType)type
             accuracy:(CLLocationAccuracy)accuracy 
             distance:(CLLocationDistance)distance
{
    self = [super init];
    
    if (self) {
        
        delegate = Adelegate;
        
        m_authorization = NO;
        
        m_locationMager = [[CLLocationManager alloc] init];
        m_locationMager.delegate = self;
        m_locationMager.desiredAccuracy = accuracy;
        m_locationMager.distanceFilter = distance;
        
        //不需要显示指南针校准
        [m_locationMager dismissHeadingCalibrationDisplay];
        
        m_type = type;
        
        [self startLocationManager];
    }
    
    return self;
}

-(void)dealloc
{
    [self stopLocationManager];
    [m_locationMager release];
    
    [super dealloc];
}

-(void)startLocationManager
{
    if (m_type & ReyLocationHeading) {
        [m_locationMager startUpdatingHeading];
    }
    
    if (m_type & ReyLocationLocation) {
        [m_locationMager startUpdatingLocation];
    }
    
    if (m_type & ReyLocationSignificant) {
        [m_locationMager startMonitoringSignificantLocationChanges];
    }
}

//停止获取location的相关信息
//未停止region.
-(void)stopLocationManager
{
    if (m_type & ReyLocationHeading) {
        [m_locationMager stopUpdatingHeading];
    }
    
    if (m_type & ReyLocationLocation) {
        [m_locationMager stopUpdatingLocation];
    }
    
    if (m_type & ReyLocationSignificant) {
        [m_locationMager stopMonitoringSignificantLocationChanges];
    }
    
}


-(void)startRegion:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy
{
    [m_locationMager startMonitoringForRegion:region desiredAccuracy:accuracy];
}

-(void)startRegion:(CLRegion *)region
{
    [m_locationMager startMonitoringForRegion:region];
}

-(void)stopRegion:(CLRegion *)region
{
    [m_locationMager stopMonitoringForRegion:region];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

//用户拒绝回调
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

// kCLAuthorizationStatusNotDetermined: //用户未选择是否使用location
//
// kCLAuthorizationStatusRestricted: //用户不能决定的状态,飞行模式
//
// kCLAuthorizationStatusDenied: //用户在设置中单独关闭本location
//
// kCLAuthorizationStatusAuthorized: //location可用
    
    if (kCLAuthorizationStatusAuthorized == status) {
        m_authorization = YES;
    }
    else {
        [delegate ReyLocationWithError:self Error:ReyLocationErrorAuthorization ErrorData:&status];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [delegate ReyLocationWithError:self Error:ReyLocationErrorFailed ErrorData:error];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    [delegate ReyLocationWithHeading:self heading:newHeading];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation
{
    [delegate ReyLocationWithLocation:self toLocation:newLocation fromLocation:oldLocation];
}


//ios 5.0 目前不处理
//- (void)locationManager:(CLLocationManager *)manager 
//didStartMonitoringForRegion:(CLRegion *)region
//{
//    
//}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [delegate ReyLocationWithEnterRegion:self region:region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [delegate ReyLocationWithExitRegion:self region:region];
}

- (void)locationManager:(CLLocationManager *)manager 
monitoringDidFailForRegion:(CLRegion *)region 
              withError:(NSError *)error
{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:region, @"region", error, @"error", nil];
    [delegate ReyLocationWithError:self Error:ReyLocationErrorRegion ErrorData:dic];
}

//指南针校准
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return NO;
}
#pragma mark -




@end
