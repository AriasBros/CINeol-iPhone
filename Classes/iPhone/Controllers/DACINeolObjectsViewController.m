//
//  DADownloableItemsViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DACINeolObjectsViewController.h"
#import "DACINeolFacade.h"
#import "DACINeolObject.h"

@interface DACINeolObjectsViewController ()

@property (nonatomic, retain) DADownloadProgressView *downloadProgressView;
@property (nonatomic, retain) NSOperationQueue       *queue;

- (void) configureTabBarItem;
- (void) applicationDidEnterBackground:(NSNotification*)notification;

@end


@implementation DACINeolObjectsViewController

@synthesize queue = _queue;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize downloadProgressView     = _downloadProgressView;
@dynamic image;
@dynamic tag;


- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self configureTabBarItem]; 
        self.queue = [[NSOperationQueue alloc] init];
        
        self.downloadProgressView = [[DADownloadProgressView alloc]
                                     initWithStyle:DADownloadProgressViewStyleIndeterminate];
    }
    
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad]; 
    self.panel.scrollEnabled = NO; // Con esto hacemos que nuestra TableView responda al toque en la status bar.

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] &&
        [[UIDevice currentDevice] isMultitaskingSupported])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];        
    }
    
    self.panel.backgroundColor = [UIColor clearColor];
    self.panel.layer.cornerRadius = 0.0;
    self.panel.layer.borderWidth = 0.0;
    self.panel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.panel.titleLabel.minimumFontSize = 13;
    self.panel.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.panel.titleLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
    self.panel.titleLabel.shadowColor = [UIColor whiteColor];
    self.panel.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _limitOfObjectsInList = NSUIntegerMax;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Methods for subcalssing.
- (NSFetchedResultsController*) fetchedResultsController {
    return nil;
}

- (void) configureTabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"CINeol"
                                                       image:nil
                                                         tag:999];
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
#pragma mark Show no internet connection error.
- (void) showNoInternetConectionPanel:(id)sender {
    self.panel.style = DAPanelStyleFullSize;
    self.panel.imageView.image = [UIImage imageNamed:@"DANetworkError.png"];
    self.panel.titleLabel.text = @"Sin conexión a Internet";
    self.panel.messageView.text = @"No se ha podido conectar con CINeol.net";
    [self.panel setNeedsLayout];
    
    self.panel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.panel.messageView.font = [UIFont boldSystemFontOfSize:13];
    
    self.panel.titleLabel.textColor = [UIColor lightGrayColor];
    self.panel.messageView.textColor = [UIColor lightGrayColor];
    
    self.panel.titleLabel.textAlignment = UITextAlignmentCenter;
    self.panel.messageView.textAlignment = UITextAlignmentCenter;
    
    self.panel.frame = ((DATableView*)self.tableView).tableEmptyView.frame;
    self.panel.backgroundColor = [UIColor whiteColor];
    
    self.panel.alpha = 0.0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
        
    self.panel.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void) showDownloadProgressView:(id)sender {
    self.navigationItem.leftBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    self.downloadProgressView.hidden = NO;    
    self.navigationItem.titleView = self.downloadProgressView;
}

- (void) hideDownloadProgressView:(id)sender {
    [self configureLeftBarButtonItem];
    [self configureRightBarButtonItem];

    self.downloadProgressView.hidden = YES;
    self.navigationItem.titleView = nil;
}


#pragma mark -
#pragma mark UIScrollView Delegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [DATableViewCellSlide tableViewWillBeginDragging: self.tableView];
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}


#pragma mark -
#pragma mark Table view delegate



#pragma mark -
#pragma mark NSFetchedResultsController Delegate Methods.
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];   
    [self.tableView flashScrollIndicators];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo 
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type
{         
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sectionIndex];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:indexSet
                          withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:indexSet
                                  withRowAnimation:UITableViewRowAnimationBottom];
            break;
    }
    [indexSet release];
}


- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath
{    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            if (newIndexPath == nil)
                return;

            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            if (indexPath == nil)
                return;
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationBottom];
            break;

            
        case NSFetchedResultsChangeUpdate:
            if (newIndexPath == nil || indexPath == nil)
                return;
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

#pragma mark -
#pragma mark Private Methods.
- (void) applicationDidEnterBackground:(NSNotification*)notification {
    _CINeolObjectsViewControllerFlags.shouldReloadData = true;
    self.fetchedResultsController = nil;
}


#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
    self.fetchedResultsController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.downloadProgressView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_fetchedResultsController release];    _fetchedResultsController = nil;
    [_downloadProgressView release];        _downloadProgressView = nil;
    [_queue release];                       _queue = nil;
    [super dealloc];
}


@end