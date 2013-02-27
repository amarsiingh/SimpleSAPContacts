//
//  ETADetailViewController.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETADetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
