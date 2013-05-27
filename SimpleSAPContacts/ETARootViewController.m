//
//  ETARootViewController.m
//  SimpleSAPContacts
//
//  Created by Amar Singh on 24/05/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import "ETARootViewController.h"

#import "ETAAppDelegate.h"
#import "ETAContactsViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kSAPContactsURL [NSURL URLWithString:@"http://207.188.73.86:8001/sap/zappkpart?sap-client=800"]

@interface ETARootViewController ()

@end

@implementation ETARootViewController

@synthesize invokeFetchContactsButton;

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
    ETAAppDelegate *delegate = (ETAAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (![self invokeFetchContactsButton].enabled) {
        [delegate managedObjectContext];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)invokeFetchContactsAction:(id)sender {
    ETAAppDelegate *delegate = (ETAAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UINavigationController *navigationController = (UINavigationController *)delegate.window.rootViewController;
//    ETAContactsViewController *controller = (ETAContactsViewController *)navigationController.topViewController;
    ETAContactsViewController *controller = [[ETAContactsViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.managedObjectContext = delegate.managedObjectContext;
    
    delegate.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    delegate.activityIndicator.color = [UIColor blueColor];
    delegate.activityIndicator.alpha = 1.0;
    delegate.activityIndicator.center = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2.0f, [UIScreen mainScreen].applicationFrame.size.height/2.0f);
    delegate.activityIndicator.hidesWhenStopped = NO;
    
    [self.view addSubview:delegate.activityIndicator];
    [self.view bringSubviewToFront:delegate.activityIndicator];
    [delegate.activityIndicator startAnimating];
    
//    if (![delegate coreDataHasEntriesForEntityName:@"Contact"]) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//        dispatch_async(kBgQueue,
//                       ^{
//                           NSData *jsonData = [NSData dataWithContentsOfURL:kSAPContactsURL];
//                           
//                           [delegate performSelectorOnMainThread:@selector(contactsDataReceived:) withObject:jsonData waitUntilDone:YES];
//                       });
//    }
//    else {
////        [controller performSelectorInBackground:@selector(reloadDataOnView) withObject:nil];
////        [controller performSelectorOnMainThread:@selector(reloadDataOnView) withObject:nil waitUntilDone:NO];
//    }
}

#pragma mark - Segue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ContactsView"]) {
        ETAAppDelegate *delegate = (ETAAppDelegate*)[[UIApplication sharedApplication] delegate];
        ETAContactsViewController *controller = (ETAContactsViewController*)segue.destinationViewController;
        controller.managedObjectContext = delegate.managedObjectContext;
        
        
        if (![delegate coreDataHasEntriesForEntityName:@"Contact"]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            dispatch_async(kBgQueue,
                           ^{
                               NSData *jsonData = [NSData dataWithContentsOfURL:kSAPContactsURL];
                               
                               [delegate performSelectorOnMainThread:@selector(contactsDataReceived:) withObject:jsonData waitUntilDone:YES];
                           });
        }
        else {
            //        [controller performSelectorInBackground:@selector(reloadDataOnView) withObject:nil];
            [controller performSelectorOnMainThread:@selector(reloadDataOnView) withObject:nil waitUntilDone:NO];
//            [controller reloadDataOnView];
        }
    }
}


@end
