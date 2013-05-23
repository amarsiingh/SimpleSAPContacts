//
//  ETADetailMapViewController.m
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/28/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import "ETADetailMapViewController.h"
#import "ETADetailViewController.h"
#import "ETAAppDelegate.h"

#import "Contact.h"
#import "ContactDetails.h"

#import "ETAClientLocation.h"

#import <CoreLocation/CoreLocation.h>


#define MAX_DISTANCE (1000000.0000)
#define METERS_PER_MILE 1609.344

#define COMPLETION_NOTIF_NAME @"FinishedDistanceComparision"

static int centreOnce = 0;

@interface ETADetailMapViewController ()

- (void)refreshMapViewWithCoordinates;
- (void)compareCoordinatesWithCurrentLocation;
- (void)checkDistanceWithLocationAndIndex:(NSArray*)locationWithIndex;

@end

@implementation ETADetailMapViewController
@synthesize globalMapView = _globalMapView;
@synthesize delegate = _delegate;
@synthesize mapsFetchedResultsController = _mapsFetchedResultsController;
@synthesize currentLocation = _currentLocation;
@synthesize nearbyLocations = _nearbyLocations;
@synthesize locationIndexes = _locationIndexes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 2
    [self.globalMapView setRegion:viewRegion animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.currentLocation = [(ETAAppDelegate*)[UIApplication sharedApplication].delegate currentLocation];
    
    [(ETAAppDelegate*)[UIApplication sharedApplication].delegate setMapDelegate:self];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMapViewWithCoordinates:) name:COMPLETION_NOTIF_NAME object:nil];
    for (id<MKAnnotation> annotation in self.globalMapView.annotations) {
        [self.globalMapView removeAnnotation:annotation];
    }
    
//    if (self.nearbyLocations == nil) {
        self.nearbyLocations = [[NSMutableArray alloc] initWithCapacity:1];
    self.locationIndexes = [[NSMutableArray alloc] initWithCapacity:4];
//    }
    
    
    NSLog(@"vi.nearbylocation.count: %d", [self.nearbyLocations count]);
    
    [self performSelectorOnMainThread:@selector(compareCoordinatesWithCurrentLocation) withObject:nil waitUntilDone:YES];

//    [self compareCoordinatesWithCurrentLocation];
    
//    [self performSelectorOnMainThread:@selector(refreshMapViewWithCoordinates) withObject:nil waitUntilDone:NO];
//    [self refreshMapViewWithCoordinates];
}

- (void)viewDidUnload {
    self.globalMapView = nil;
    self.mapsFetchedResultsController = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    MKCoordinateRegion worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
    [self.globalMapView setRegion:worldRegion];
    centreOnce = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance

- (void)compareCoordinatesWithCurrentLocation {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//                   ^{
                       id <NSFetchedResultsSectionInfo> sectionInfo = [[self.mapsFetchedResultsController sections] objectAtIndex:0];
    NSLog(@"currLat: %.4f, currLng: %.4f", [self.currentLocation coordinate].latitude, [self.currentLocation coordinate].longitude);
                       for (int i = 0; i < [sectionInfo numberOfObjects]; i++) {
                           Contact *aContact = [self.mapsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                           ContactDetails *contactDetail = aContact.details;
                           
                           if (CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake([contactDetail.latitude doubleValue], [contactDetail.longitude doubleValue]))) {
                               CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:[contactDetail.latitude doubleValue] longitude:[contactDetail.longitude doubleValue]];
                               
                               CLLocationDistance distance = [self.currentLocation distanceFromLocation:toLocation];
                               //
                               [self performSelectorOnMainThread:@selector(checkDistanceWithLocationAndIndex:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:distance], toLocation, [NSNumber numberWithInt:i], nil] waitUntilDone:YES];
                           } else {
                               CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                               NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", contactDetail.houseNumber, contactDetail.street, contactDetail.city, contactDetail.country];
                               [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
                                   //Pick at the top one.
                                   CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
                                   NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                                   NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
//                                   NSLog(@"latM: %@, lngM: %@", latDest1, lngDest1);
                                   
                                   //update coordinates as well
                                   contactDetail.latitude = [NSNumber numberWithDouble:aPlacemark.location.coordinate.latitude];
                                   contactDetail.longitude = [NSNumber numberWithDouble:aPlacemark.location.coordinate.longitude];
                                   
                                   __block CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:[contactDetail.latitude doubleValue] longitude:[contactDetail.longitude doubleValue]];
                                   
                                   __block CLLocationDistance distance = [self.currentLocation distanceFromLocation:toLocation];
                                   //
                                   [self performSelectorOnMainThread:@selector(checkDistanceWithLocationAndIndex:) withObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:distance], toLocation, [NSNumber numberWithInt:i], nil] waitUntilDone:YES];
                               }];//__Geocoder_Block_
                           }//___else__
//                           if ((i + 1) == ([sectionInfo numberOfObjects])) {
//                               NSLog(@"************* posting notif.....(i= %d, objects:%d)", i, [sectionInfo numberOfObjects]);
//                               [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETION_NOTIF_NAME object:nil];
//                           }
                       }//___for__
//                   });//___GCD__
}

- (void)refreshMapViewWithCoordinates {//:(NSNotification*)notif {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //Clean up slate
    for (id<MKAnnotation> annotation in self.globalMapView.annotations) {
        [self.globalMapView removeAnnotation:annotation];
    }
    
    // 1
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 2
    [self.globalMapView setRegion:viewRegion animated:YES];
    
    int i = 0;
    NSLog(@"nearbyLocations.count: %d/%d", [self.nearbyLocations count], [self.locationIndexes count]);
    for (CLLocation *aLocation in self.nearbyLocations) {
        Contact *aContact = [self.mapsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[[self.locationIndexes objectAtIndex:i++] intValue] inSection:0]];
        ContactDetails *contactDetail = aContact.details;
        // 3
        NSLog(@"latF: %f, lngF: %f", aLocation.coordinate.latitude, aLocation.coordinate.longitude);
//        CLLocationCoordinate2D zoomLocation;
//        zoomLocation.latitude = [[coordinates objectAtIndex:0] doubleValue];
//        zoomLocation.longitude= [[coordinates objectAtIndex:1] doubleValue];
        NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", contactDetail.houseNumber, contactDetail.street, contactDetail.city, contactDetail.country];
        

        
        ETAClientLocation *annotation = [[ETAClientLocation alloc] initWithName:aContact.accountName address:address coordinate:aLocation.coordinate];
        
        [self.globalMapView addAnnotation:annotation];
    }
    
}

- (void)checkDistanceWithLocationAndIndex:(NSArray *)locationWithIndex {
    CLLocationDistance distance = [[locationWithIndex objectAtIndex:0] doubleValue];
    CLLocation *toLocation = [locationWithIndex objectAtIndex:1];
    int i = [[locationWithIndex objectAtIndex:2] intValue];
    
    if (centreOnce == 0) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 1.5*distance, 1.5*distance);
        // 2
        [self.globalMapView setRegion:viewRegion animated:YES];
        centreOnce = 1;
    }
    
    if (distance <= MAX_DISTANCE) {
        [self.nearbyLocations addObject:toLocation];
        [self.locationIndexes addObject:[NSNumber numberWithInt:i]];
        NSLog(@"In.distance: %.2f meters(%d/%d)", distance, [self.nearbyLocations count], [self.locationIndexes count]);
        
        Contact *aContact = [self.mapsFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        ContactDetails *contactDetail = aContact.details;
        // 3
        NSLog(@"latF: %f, lngF: %f", toLocation.coordinate.latitude, toLocation.coordinate.longitude);
        //        CLLocationCoordinate2D zoomLocation;
        //        zoomLocation.latitude = [[coordinates objectAtIndex:0] doubleValue];
        //        zoomLocation.longitude= [[coordinates objectAtIndex:1] doubleValue];
        NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@", contactDetail.houseNumber, contactDetail.street, contactDetail.city, contactDetail.country];
        
        
        
        ETAClientLocation *annotation = [[ETAClientLocation alloc] initWithName:aContact.accountName address:address coordinate:toLocation.coordinate];
        
        [self.globalMapView addAnnotation:annotation];
    }
    else {
        NSLog(@"Out.distance: %.2f meters", distance);
    }
}

#pragma mark - 


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *anIdentifier = @"globalLocation";
    
    if ([annotation isKindOfClass:[ETAClientLocation class]]) {
        MKPinAnnotationView *annocationView = (MKPinAnnotationView*)[self.globalMapView dequeueReusableAnnotationViewWithIdentifier:anIdentifier];
        
        if (annocationView == nil) {
            annocationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIdentifier];
            annocationView.enabled = YES;
            annocationView.canShowCallout = YES;
            annocationView.animatesDrop = YES;
            annocationView.pinColor = MKPinAnnotationColorPurple;
        } else {
            annocationView.annotation = annotation;
        }
        
        return annocationView;
    }
    
    return nil;
}

#pragma mark - 

- (void)delegate:(id)delegate didGetLocationUpdate:(NSArray *)locations {
    centreOnce = 0;
    NSLog(@"--------------- check-----------");
    [self compareCoordinatesWithCurrentLocation];
}


@end
