//
//  DACreditsViewController.m
//  Tickler
//
//  Created by David Arias Vazquez on 30/03/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Availability.h>
#import "DAAboutViewController.h"


@interface DAAboutViewController ()

@property(retain, nonatomic) DAOverlayView *overlayView;

@end


@implementation DAAboutViewController

@synthesize overlayView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overlayView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:animated];
    
    [FlurryAPI logEvent:DAFlurryEventShowAboutView];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];    
}

- (void) overlayViewDidTouch {
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self && self.view.superview) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) goToWeb:(NSString*) link {
    //NSLog(@"%@", link);
}

- (IBAction) goToLeafsoft:(id)sender {
    //NSString *link = @"http://www.leafsoft.es";
    //[self goToWeb:link];
}

- (IBAction) goToWebBeyer:(id)sender {
    //NSString *link = @"http://www.androidicons.com";
    //[self goToWeb:link];
}

- (IBAction) goToCINeol:(id)sender {
    //NSString *link = @"http://www.cineol.net";
    //[self goToWeb:link];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.overlayView = nil;
}


- (void)dealloc {
    [overlayView release];  overlayView = nil;
    [super dealloc];
}


@end
