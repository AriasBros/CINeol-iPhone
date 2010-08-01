//
//  DAMainViewController.m
//  Cineol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAMainViewController.h"
#import "DANewsListViewController.h"
#import "DAMovieShowtimesViewController.h"
#import "DAMoviesViewController.h"
#import "DAReviewsViewController.h"
#import "DAPeopleViewController.h"
#import "DASettingsViewController.h"

@interface DAMainViewController ()

- (UINavigationController*) newsListViewController;
- (UINavigationController*) movieShowtimesViewController;
- (UINavigationController*) moviesViewController;
- (UINavigationController*) reviewsViewController;
- (UINavigationController*) peopleViewController;
- (UINavigationController*) settingsViewController;

@end


@implementation DAMainViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [FlurryAPI countPageViews:self];
    [FlurryAPI countPageViews:[self newsListViewController]];
    [FlurryAPI countPageViews:[self movieShowtimesViewController]];
    [FlurryAPI countPageViews:[self moviesViewController]];
    [FlurryAPI countPageViews:[self settingsViewController]];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:
                            [self newsListViewController], 
                            [self movieShowtimesViewController],
                            [self moviesViewController],
                            //[self reviewsViewController],
                            //[self peopleViewController],
                            [self settingsViewController],
                            nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Private Methods.
- (UINavigationController*) newsListViewController {
    DANewsListViewController *controller = [[DANewsListViewController alloc]
                                            initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navigation = [[[UINavigationController alloc] 
                                           initWithRootViewController:controller] autorelease];
    [controller release];
    
    return navigation;
}

- (UINavigationController*) movieShowtimesViewController {
    DAMovieShowtimesViewController *controller = [[DAMovieShowtimesViewController alloc]
                                                  initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navigation = [[[UINavigationController alloc] 
                                           initWithRootViewController:controller] autorelease];
    [controller release];
    
    return navigation;
}

- (UINavigationController*) moviesViewController {
    DAMoviesViewController *controller = [[DAMoviesViewController alloc]
                                          initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navigation = [[[UINavigationController alloc] 
                                           initWithRootViewController:controller] autorelease];
    [controller release];
    
    return navigation;    
}

- (UINavigationController*) reviewsViewController {
    DAReviewsViewController *controller = [[DAReviewsViewController alloc]
                                           initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navigation = [[[UINavigationController alloc] 
                                           initWithRootViewController:controller] autorelease];
    [controller release];
    
    return navigation;    
}

- (UINavigationController*) peopleViewController {
    DAPeopleViewController *controller = [[DAPeopleViewController alloc]
                                          initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navigation = [[[UINavigationController alloc] 
                                           initWithRootViewController:controller] autorelease];
    [controller release];
    
    return navigation;    
}

- (UINavigationController*) settingsViewController {
    DASettingsViewController *controller = [[DASettingsViewController alloc]
                                            initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navigation = [[[UINavigationController alloc] 
                                           initWithRootViewController:controller] autorelease];
    [controller release];
    
    return navigation;      
}

@end
