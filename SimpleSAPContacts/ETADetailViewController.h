//
//  ETADetailViewController.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ETADetailViewController : UIViewController<MKMapViewDelegate>

@property (assign, nonatomic) NSFetchedResultsController *detailFetchedResultsController;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet MKMapView *localMapView;


@end
