//
//  ReyMapView.h
//  ReyMapView
//
//  Created by rey liang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol ReyMapViewDelegate;

@interface ReyMapView : UIView
    <MKMapViewDelegate>
{
    MKMapView * m_mapView;
    
    id<ReyMapViewDelegate> delegate;
}

@property (nonatomic , retain) MKMapView * m_mapView;
@property (nonatomic , assign) id<ReyMapViewDelegate> delegate;

-(void)setMapType:(MKMapType)mapType;
-(void)setMapRegion:(MKCoordinateRegion)region;


- (id)initWithFrame:(CGRect)frame mapType:(MKMapType)mapType showUser:(bool)showUser;
@end


@protocol ReyMapViewDelegate <NSObject>

//TODO: 添加注解视图
- (MKAnnotationView *)ReyMapView:(ReyMapView *)sender viewForAnnotation:(id <MKAnnotation>)annotation;

@end
