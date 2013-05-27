//
//  ETARootViewController.h
//  SimpleSAPContacts
//
//  Created by Amar Singh on 24/05/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ETAContactsViewController;

@interface ETARootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *invokeFetchContactsButton;
@property (retain, nonatomic) ETAContactsViewController *contactsViewController;

- (IBAction)invokeFetchContactsAction:(id)sender;


@end
