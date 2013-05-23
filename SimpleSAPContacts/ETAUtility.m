//
//  ETAUtility.m
//  SimpleSAPContacts
//
//  Created by Amarsingh Pardeshi on 3/1/13.
//  Copyright (c) 2013 Eat The Apple Inc. All rights reserved.
//

#import "ETAUtility.h"
#import <QuartzCore/QuartzCore.h>

//#import "ETAAppDelegate.h"

/*! Begin: Variables related to Ignore Events methods */
static UIView *g_BlockView = nil;
static UIActivityIndicatorView *g_WaitCursor = nil;
static UIView *g_CachedInteractionView = nil;
NSTimer *g_Timer = nil;
BOOL g_IsBlocking = NO;
static UIView *g_WaitCursorHUD = nil;

UIActivityIndicatorView* p_WaitCursor = nil;

@implementation ETAUtility

+ (void)beginIgnoringInteractionsWithWaitCursorForView:(UIView *)theView {
    /*! First cache the view which is blocked */
    g_CachedInteractionView = theView;
    
    /*! Instantiate blocking view.
     *  This view simply acts as a container view,
     *  with alpha set to indicate the inactivity of background view
     */
    g_BlockView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ([UIApplication sharedApplication].delegate).window.frame.size.width, ([UIApplication sharedApplication].delegate).window.frame.size.height)];
    g_BlockView.backgroundColor = [UIColor blackColor];
    g_BlockView.alpha = 0.5f;
    g_BlockView.userInteractionEnabled = NO;
    
    /*! Instantiate Activity Indicator.
     *  We're using WhiteLarge style of indicator here.
     */
    g_WaitCursor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    /*! Instantiate Activity Indicator Background holder view.
     *  It simply provides black colored background, apart from housing the indicator.
     */
    UIView *waitCursorHUD = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    waitCursorHUD.backgroundColor = [UIColor blackColor];
    //Center it within BlockView
    waitCursorHUD.center = CGPointMake(g_BlockView.bounds.size.width/2.0f, g_BlockView.bounds.size.height/2.0f);
    waitCursorHUD.alpha = 1.0f;
    //Make it rounded rectangle view. Nice iOS feel.
    ((CALayer*)waitCursorHUD.layer).cornerRadius = 5.0f;
    
    /*! Center the wait cursor within holder view !*/
    g_WaitCursor.center = CGPointMake(waitCursorHUD.bounds.size.width/2.0f, waitCursorHUD.bounds.size.height/2.0f);
    [waitCursorHUD addSubview:g_WaitCursor];
    //add activity indicator holder view to BlockView
    [g_BlockView addSubview:waitCursorHUD];

    
    //Add the BlockView at the top of the stack of the views.
    [([UIApplication sharedApplication].delegate).window addSubview:g_BlockView];
    
    /*!Disable background View's User Interactions. This is just preventive rather.!*/
    g_CachedInteractionView.userInteractionEnabled = NO;
    /*!Disable entire screen's User Interactions.!*/
    [([UIApplication sharedApplication].delegate).window setUserInteractionEnabled:NO];
    
    /*! Fire up the wait cursor !*/
    [g_WaitCursor startAnimating];
    
    
    /*! Are we blocking? !*/
    g_IsBlocking = YES;
}

+ (void)endIgnoringInteractionsWithWaitCursor {
    /*! Are we blocking? !*/
    if (!g_IsBlocking) {
        return;//return if we ain't!
    }
    g_IsBlocking = NO;
    /*!Enable blocked view's User Interactions.!*/
    g_CachedInteractionView.userInteractionEnabled = YES;
    /*!Enable entire screen's User Interactions.!*/
    [([UIApplication sharedApplication].delegate).window setUserInteractionEnabled:YES];
    /*! Rest the wait cursor !*/
    [g_WaitCursor stopAnimating];
    
    /*! Release the memory associated with Wait Cursor !*/
    [g_WaitCursor removeFromSuperview];
    
    /*! Let go of BlockView's associated memory !*/
    [g_BlockView removeFromSuperview];
}

+ (UIView *)waitCursorHUD {
    
    if (g_WaitCursorHUD != nil) {
        NSLog(@"((((WaitCursor is there)))");
        return g_WaitCursorHUD;
    }
    /*! Instantiate Activity Indicator.
     *  We're using WhiteLarge style of indicator here.
     */
    g_WaitCursor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    /*! Instantiate Activity Indicator Background holder view.
     *  It simply provides black colored background, apart from housing the indicator.
     */
    g_WaitCursorHUD = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    g_WaitCursorHUD.backgroundColor = [UIColor blackColor];
    //Center it within BlockView
    g_WaitCursorHUD.center = CGPointMake(g_BlockView.bounds.size.width/2.0f, g_BlockView.bounds.size.height/2.0f);
    g_WaitCursorHUD.alpha = 1.0f;
    //Make it rounded rectangle view. Nice iOS feel.
    ((CALayer*)g_WaitCursorHUD.layer).cornerRadius = 5.0f;
    
    /*! Center the wait cursor within holder view !*/
    g_WaitCursor.center = CGPointMake(g_WaitCursorHUD.bounds.size.width/2.0f, g_WaitCursorHUD.bounds.size.height/2.0f);
    [g_WaitCursorHUD addSubview:g_WaitCursor];
    
    return g_WaitCursorHUD;
}

+ (UIView *)waitCursor {
    if (p_WaitCursor != nil) {
        return p_WaitCursor;
    }
    
    p_WaitCursor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    p_WaitCursor.color = [UIColor redColor];
    p_WaitCursor.alpha = 1.0;
    //    activityIndicator.center = CGPointMake(160, 360);
    p_WaitCursor.hidesWhenStopped = NO;
    p_WaitCursor.center = CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2.0f, [UIScreen mainScreen].applicationFrame.size.height/2.0f);
    
    return p_WaitCursor;
}
@end
