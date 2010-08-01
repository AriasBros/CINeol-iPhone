//
//  DAMainViewController.m
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAMainViewController_Pad.h"
#import "DALateralBarView.h"
#import "DAContentViewController.h"

@interface DAMainViewController_Pad ()

- (CGRect) rectForContentView;

@end


@implementation DAMainViewController_Pad

@synthesize lateralBarView        = _lateralBarView;
@synthesize contentViewController = _contentViewController;

- (void)loadView {
    [super loadView];
    
    NSArray *sections = [NSArray arrayWithObjects:@"Noticias", @"Estrenos de la Semana", @"Críticas", nil];
    
    self.lateralBarView = [[DALateralBarView alloc]
                           initWithFrame:CGRectMake(0.0, 0.0, 100, self.view.frame.size.height) 
                           sectionTitles:sections];
    
    self.contentViewController = [[DAContentViewController alloc] initWithNumberOfSections:3];
    self.contentViewController.view.frame = [self rectForContentView];
    self.contentViewController.view.backgroundColor = [UIColor colorWithRed:220.0/255
                                                                      green:220.0/255 
                                                                       blue:220.0/255 
                                                                      alpha:1.0];
    
    [self.view addSubview:self.lateralBarView];
    [self.view addSubview:self.contentViewController.view];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private Methods.
- (CGRect) rectForContentView {
    CGRect rect;
    
    rect.origin.x = self.lateralBarView.frame.size.width;
    rect.origin.y = 0.0;
    rect.size.width = self.view.frame.size.width - self.lateralBarView.frame.size.width;
    rect.size.height = self.view.frame.size.height;
    
    return rect;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    if (self.contentViewController.view.superview == nil)
        self.contentViewController = nil;
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.lateralBarView = nil;
    self.contentViewController = nil;
}


- (void)dealloc {
    [_lateralBarView release];
    [_contentViewController release];
    
    [super dealloc];
}


@end
