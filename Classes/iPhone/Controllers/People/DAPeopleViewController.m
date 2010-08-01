    //
//  DAPeopleViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 13/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAPeopleViewController.h"
#import "DACINeolFacade.h"

@implementation DAPeopleViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark DADownloableItemsViewController Methods.
- (NSFetchedResultsController*) fetchedResultsController {
    return nil;
}

- (void) configureTabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Gente"
                                                       image:[UIImage imageNamed:@"DAPeopleTabBarIcon.png"]
                                                         tag:kPeopleViewControllerTag];
    self.tabBarItem = item;
    [item release];
}

- (void) configureRightBarButtonItem {
    return;
}

- (void) configureLeftBarButtonItem {
    return;
}


#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


@end
