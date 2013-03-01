//
//  ETADetailMapViewController.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/28/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "ETAAppDelegate.h"

@interface ETADetailMapViewController : UIViewController<MKMapViewDelegate, LocationUpdateDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *globalMapView;
@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) NSFetchedResultsController *mapsFetchedResultsController;
@property (copy, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) __block NSMutableArray *nearbyLocations;
@property (strong, nonatomic) __block NSMutableArray *locationIndexes;

@end
