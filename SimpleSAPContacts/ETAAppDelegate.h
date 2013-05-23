//
//  ETAAppDelegate.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol LocationUpdateDelegate <NSObject>

- (void)delegate:(id)delegate didGetLocationUpdate:(NSArray *)locations;

@end


@interface ETAAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) id<LocationUpdateDelegate> mapDelegate;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)contactsDataReceived:(NSData*)receivedData;
- (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName;

@end
