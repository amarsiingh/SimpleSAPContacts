//
//  Contact.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/27/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactDetails;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSString * accountNumber;
@property (nonatomic, retain) ContactDetails *details;

@end
