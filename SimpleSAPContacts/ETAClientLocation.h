//
//  ETAClientLocation.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/28/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ETAClientLocation : NSObject<MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

- (MKMapItem *)mapItem;

@end
