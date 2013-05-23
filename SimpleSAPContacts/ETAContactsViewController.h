//
//  ETAContactsViewController.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAContactsViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *viewGlobalMapButton;


- (void)parseFetchedContactsData:(NSData*)responseData;
- (void)reloadDataOnView;

- (IBAction)returnFromMapView:(UIStoryboardSegue *)segue;

@end
