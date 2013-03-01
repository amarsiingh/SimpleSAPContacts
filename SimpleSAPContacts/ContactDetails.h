//
//  ContactDetails.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/28/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact;

@interface ContactDetails : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * houseNumber;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) Contact *info;

@end
