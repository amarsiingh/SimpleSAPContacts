//
//  ETAClientLocation.m
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 2/28/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import "ETAClientLocation.h"
#import <AddressBook/AddressBook.h>

@interface ETAClientLocation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end



@implementation ETAClientLocation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"<unknown name>";
        }
        self.address = address;
        self.theCoordinate = coordinate;
    }
    
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}


- (MKMapItem *)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey: _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    mapItem.name = self.title;
    mapItem.accessibilityLabel = @"mapItemLabel";
    mapItem.accessibilityHint = @"mapItemHint";
    
    
    return mapItem;
}

@end
