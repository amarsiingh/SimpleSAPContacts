//
//  ETADetailViewController.m
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import "ETADetailViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "Contact.h"
#import "ContactDetails.h"
#import "ETAClientLocation.h"
#import "ETADetailMapViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define METERS_PER_MILE 1609.344


@interface ETADetailViewController ()

@property (strong, nonatomic) NSString *address;

- (void)updateTheMapWithLatLong:(NSArray*)coordinates;

@end

@implementation ETADetailViewController

@synthesize accountNameLabel = _accountNameLabel;
@synthesize accountNumberLabel = _accountNumberLabel;
@synthesize addressLabel = _addressLabel;
@synthesize localMapView = _localMapView;
@synthesize detailFetchedResultsController = _detailFetchedResultsController;
@synthesize selectedIndexPath = _selectedIndexPath;

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
    
    Contact *aContact = [self.detailFetchedResultsController objectAtIndexPath:self.selectedIndexPath];
    ContactDetails *contactDetail = aContact.details;
//    NSLog(@"detail.name: %@", aContact.accountName);
    self.accountNameLabel.text = aContact.accountName;
    self.accountNumberLabel.text = aContact.accountNumber;

    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@,\n%@ - %@,\n%@.", contactDetail.houseNumber, contactDetail.street, contactDetail.city, contactDetail.zipCode, contactDetail.country];
    self.address = [self.addressLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
    dispatch_async(kBgQueue, ^{
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:self.address completionHandler:^(NSArray* placemarks, NSError* error){
            CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];

                // Process the placemark.
            NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
            NSLog(@"lat: %@, lng: %@", latDest1, lngDest1);
            [self performSelectorOnMainThread:@selector(updateTheMapWithLatLong:) withObject:[NSArray arrayWithObjects:latDest1, lngDest1, nil] waitUntilDone:YES];
        }];
    });
    
}

- (void)viewDidUnload {
    self.detailFetchedResultsController = nil;
    self.selectedIndexPath = nil;
    self.accountNameLabel = nil;
    self.accountNumberLabel = nil;
    self.addressLabel = nil;
    self.localMapView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instance

- (void)updateTheMapWithLatLong:(NSArray *)coordinates {
    //Clean up slate
    for (id<MKAnnotation> annotation in self.localMapView.annotations) {
        [self.localMapView removeAnnotation:annotation];
    }
    
    // 1
    NSLog(@"latF: %f, lngF: %f", [[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue]);
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[coordinates objectAtIndex:0] doubleValue];
    zoomLocation.longitude= [[coordinates objectAtIndex:1] doubleValue];
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [self.localMapView setRegion:viewRegion animated:YES];
    
    ETAClientLocation *annotation = [[ETAClientLocation alloc] initWithName:self.accountNameLabel.text address:self.address coordinate:zoomLocation];
    
    [self.localMapView addAnnotation:annotation];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *anIdentifier = @"ClientLocation";
    
    if ([annotation isKindOfClass:[ETAClientLocation class]]) {
        MKPinAnnotationView *annocationView = (MKPinAnnotationView*)[self.localMapView dequeueReusableAnnotationViewWithIdentifier:anIdentifier];
        
        if (annocationView == nil) {
            annocationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIdentifier];
            annocationView.enabled = YES;
            annocationView.canShowCallout = YES;
            annocationView.pinColor = MKPinAnnotationColorPurple;
        } else {
            annocationView.annotation = annotation;
        }
        
        return annocationView;
    }
    
    return nil;
}


#pragma mark - Unwinding Segue



#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");

}

@end
