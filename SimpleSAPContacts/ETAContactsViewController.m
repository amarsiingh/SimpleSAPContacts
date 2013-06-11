//
//  ETAContactsViewController.m
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import "ETAContactsViewController.h"

#import "Contact.h"
#import "ContactDetails.h"
#import "ETADetailViewController.h"
#import "ETADetailMapViewController.h"
#import "ETAUtility.h"

//static int t_count = 0;

@interface ETAContactsViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ETAContactsViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize activityIndicator = _activityIndicator;
@synthesize viewGlobalMapButton = _viewGlobalMapButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    //self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
    self.activityIndicator = nil;
    self.viewGlobalMapButton = nil;
    
    self.tableView.isAccessibilityElement = YES;
    self.tableView.accessibilityLabel = @"contactsList";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    cell.accessibilityIdentifier = @"contactCellIdentifier";
    cell.accessibilityLabel = @"contactCellLabel";
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self performSegueWithIdentifier:@"showDetail" sender:[tableView cellForRowAtIndexPath:indexPath]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Instance

- (void)parseFetchedContactsData:(NSData *)responseData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error = nil;

//    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"zappkpart" ofType:@"txt"];
//    NSData *jsonStrinData = [NSData dataWithContentsOfFile:filePath];
//    NSString *test = [[NSString alloc] initWithData:jsonStrinData encoding:NSUTF8StringEncoding];
//    NSLog(@"jsonString: %@", test);
    
    NSArray *contactsData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"contacts: %@, error: %@", [contactsData description], [error description]);
    
//    const unsigned char *ptr = [responseData bytes];
//    
//    for(int i=0; i<[responseData length]; ++i) {
//        unsigned char c = *ptr++;
//        NSLog(@"char=%c hex=%x", c, c);
//    }

//    self.topCont = [contactsData objectAtIndex:1];

    for (NSDictionary *aContact in contactsData) {
        Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
        contact.accountName = [aContact objectForKey:@"accname"];
        contact.accountNumber = [aContact objectForKey:@"accnumber"];
        
        ContactDetails *contactDetails = [NSEntityDescription insertNewObjectForEntityForName:@"ContactDetails" inManagedObjectContext:self.managedObjectContext];
        contactDetails.city = [aContact objectForKey:@"city1"];
        contactDetails.country = [aContact objectForKey:@"country"];
        contactDetails.houseNumber = [aContact objectForKey:@"house_num1"];
        contactDetails.zipCode = [aContact objectForKey:@"post_code1"];
        contactDetails.street = [aContact objectForKey:@"street"];
        contactDetails.latitude = [NSNumber numberWithDouble:(-200.000000)];
        contactDetails.longitude = [NSNumber numberWithDouble:(400.000000)];
        
        contact.details = contactDetails;
        contactDetails.info = contact;
        
        NSError *err = nil;
        if (![self.managedObjectContext save:&err]) {
            NSLog(@"Whoa! couldn't save! : %@", [err localizedDescription]);
        }
    }
    
    [self performSelectorOnMainThread:@selector(reloadDataOnView) withObject:nil waitUntilDone:NO];
}

- (void)reloadDataOnView {
    [self.activityIndicator startAnimating];
    NSError *err = nil;
    
    if (![self.fetchedResultsController performFetch:&err]) {
        NSLog(@"Failed: %@", [err localizedDescription]);
    }
    [self.tableView reloadData];
    [self.viewGlobalMapButton setEnabled:YES];
    
    [((ETAAppDelegate*)[UIApplication sharedApplication].delegate).activityIndicator removeFromSuperview];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Contact *aContact = (Contact*)[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = aContact.accountName;
    NSLog(@"accountName: %@", aContact.accountName);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Account No. %@", aContact.accountNumber];
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController*)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    if (!self.managedObjectContext) {
        ETAAppDelegate *delegate = (ETAAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = delegate.managedObjectContext;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *event = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:event];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"accountName" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)];
//    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"accountName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    self.fetchedResultsController = theFetchedResultsController;
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        ETADetailViewController *controller = [segue destinationViewController];
        controller.detailFetchedResultsController = self.fetchedResultsController;
        controller.selectedIndexPath = [self.tableView indexPathForCell:(UITableViewCell*)sender];
    }
    else if ([segue.identifier isEqualToString:@"mapView"]) {
        ETADetailMapViewController *controller = [segue destinationViewController];
        
        controller.mapsFetchedResultsController = self.fetchedResultsController;
    }
}

#pragma mark - Unwinding Segue

- (void)returnFromMapView:(UIStoryboardSegue *)segue {
    NSLog(@"looks like it!");
}

@end
