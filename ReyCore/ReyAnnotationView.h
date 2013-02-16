//
//  ReyAnnotationView.h
//  ReyMapView
//
//  Created by rey liang on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "I_ReyAnnotationView.h"

@interface ReyAnnotationView : MKAnnotationView


-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
