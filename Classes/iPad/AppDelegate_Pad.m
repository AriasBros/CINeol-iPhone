//
//  AppDelegate_Pad.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright Yo 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "DAMainViewController.h"
#import "DACINeolManager.h"
#import "DACINeolUserDefaults.h"


@implementation AppDelegate_Pad

@synthesize mainViewController = _mainViewController;


- (void) initUserInterface {
    [FlurryAPI logEvent:DAFlurryEventUsingDevicePad];

    /*
    DAMainViewController_Pad *controller = [[DAMainViewController_Pad alloc] initWithNibName:nil 
                                                                                      bundle:nil];
    self.mainViewController = controller;
    [controller release];
     */
    
    self.mainViewController = [[DAMainViewController alloc] initWithNibName:nil bundle:nil];    
    self.mainViewController.selectedIndex = [DACINeolUserDefaults initialSection];
    [self.mainViewController release];
}

- (UIView*) mainView {
    return self.mainViewController.view;
}


#pragma mark -
#pragma mark Application delegate
/**
 Superclass implementation saves changes in the application's managed object context 
 before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[super dealloc];
}


@end

