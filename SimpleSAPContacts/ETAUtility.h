//
//  ETAUtility.h
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 3/1/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETAUtility : NSObject

+ (void)beginIgnoringInteractionsWithWaitCursorForView:(UIView *)theView;
+ (void)endIgnoringInteractionsWithWaitCursor;

+ (UIView*)waitCursorHUD;

+ (UIView*)waitCursor;
@end
