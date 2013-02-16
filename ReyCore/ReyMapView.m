//
//  ReyMapView.m
//  ReyMapView
//
//  Created by rey liang on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReyMapView.h"

@implementation ReyMapView

@synthesize m_mapView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame mapType:(MKMapType)mapType showUser:(bool)showUser
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        m_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 
                                                                frame.size.width, 
                                                                frame.size.height)];
        m_mapView.delegate = self;
        m_mapView.mapType = mapType;
        m_mapView.showsUserLocation = showUser;
        
        [self addSubview:m_mapView];
        
    }
    return self;
}

-(void)dealloc
{
    [m_mapView release];
    [super dealloc];
}

-(void)setMapType:(MKMapType)mapType
{
    m_mapView.mapType = mapType;
}

-(void)setMapRegion:(MKCoordinateRegion)region
{
    [m_mapView setRegion:region animated:YES];
}


#pragma mark -

#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
//    [m_mapView setRegion:region animated:YES];
    [self setMapRegion:region];
}

#pragma mark -
#pragma mark MKMapViewDatasource

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    return [delegate ReyMapView:self viewForAnnotation:annotation];
}

#pragma mark -


@end
