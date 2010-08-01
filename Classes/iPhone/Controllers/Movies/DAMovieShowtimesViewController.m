//
//  DAMovieShowtimesViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 05/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAMovieShowtimesViewController.h"

#import "DAMovie.h"
#import "DAPhoto.h"
#import "DATableViewCellMovie.h"

#import "DAXMLParserMovieShowtimesCINeol.h"

#import "DACINeolFacade.h"
#import "DACINeolKeys.h"
#import "DACINeolManager.h"
#import "DACINeolUserDefaults.h"

#import "DADeleteMoviesOperation.h"


@interface DAMovieShowtimesViewController ()

@property (nonatomic, assign) NSInteger numberOfWeeks;


- (void) cineolDidChangeNumberOfWeeks:(NSNotification*)notification;
- (void) cineolWillDownloadMovieShowtimes:(NSNotification*)notification;
- (void) cineolDidDownloadMovieShowtimes:(NSNotification*)notification;
- (void) cineolDidFailToDownloadMovieShowtimes:(NSNotification*)notification;
- (void) parser:(id)parser 
 foundAttribute:(NSString*)attributeName
      withValue:(id)value 
     forElement:(NSString *)elementName;
- (void) parserDidEndDocument:(id)parser;
- (void) parser:(DAXMLParser*)parser didEndElement:(NSString*)key;

- (void) deleteMoviesWithoutUse;

@end


@implementation DAMovieShowtimesViewController

@synthesize numberOfWeeks               = _numberOfWeeks;

- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Cartelera";
        self.hidesSearchBar = YES;
        _numberOfWeeks = -1;
        _currentSortCategory = [DACINeolUserDefaults movieSortCategoryInMovieShowtimesSection];        
        _CINeolObjectsViewControllerFlags.shouldReloadData = true;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
            
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidChangeNumberOfWeeks:)
                                                 name:DACINeolUserDefaultsDidChangeNumberOfWeeksNotification
                                               object:nil];   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidChangeMovieSortCategory:)
                                                 name:DACINeolUserDefaultsDidChangeMovieSortCategoryInMovieShowtimesNotification
                                               object:nil];   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolWillDownloadMovieShowtimes:)
                                                 name:DACINeolWillDownloadMovieShowtimesNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidDownloadMovieShowtimes:)
                                                 name:DACINeolDidDownloadMovieShowtimesNotification
                                               object:[DACINeolManager sharedManager]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidFailToDownloadMovieShowtimes:)
                                                 name:DACINeolDidFailToDownloadMovieShowtimesNotification
                                               object:[DACINeolManager sharedManager]];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_CINeolObjectsViewControllerFlags.shouldReloadData) {
        [[DACINeolManager sharedManager] movieShowtimesForNumberOfWeeks:self.numberOfWeeks];
        _CINeolObjectsViewControllerFlags.shouldReloadData = false;
    }
}

#pragma mark -
#pragma mark Public Methods.
- (void) configureRightBarButtonItem {
    return;
}


- (void) configureBackBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Cartelera"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:nil
                                                            action:nil];
    self.navigationItem.backBarButtonItem = item;
    [item release];    
}


#pragma mark -
#pragma mark UITableView DataSource Methods.


#pragma mark -
#pragma mark UITableView Delegate Methods.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_currentSortCategory != DAMovieSortByPremierDate)
        return nil;
    
    switch (section) {
        case 0:
            return @"Estrenos de la semana";

        default:
            return @"Otras películas en cartelera";
    }
}


#pragma mark -
#pragma mark CINeol XML Methods
- (void) cineolWillDownloadMovieShowtimes:(NSNotification*)notification { 
    [super showDownloadProgressView:nil];
    self.panel.titleLabel.text = @"Cargando Cartelera...";
    self.downloadProgressView.label.text = @"Comprobando si hay películas nuevas";
    [self.downloadProgressView setStyle:DADownloadProgressViewStyleIndeterminate animated:YES];
    [self.downloadProgressView setNeedsLayout];
}

- (void) cineolDidDownloadMovieShowtimes:(NSNotification*)notification {
    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];
    
    DAXMLParserMovieShowtimesCINeol *parser = [[DAXMLParserMovieShowtimesCINeol alloc] 
                                               initWithData:data delegate:self];
    [self.queue addOperation:parser];
    [parser release];
}   

- (void) cineolDidFailToDownloadMovieShowtimes:(NSNotification*)notification {
    [super showNoInternetConectionPanel:nil];
    [super hideDownloadProgressView:nil];
}

- (void) parser:(id)parser 
 foundAttribute:(NSString*)attributeName
      withValue:(id)value 
     forElement:(NSString *)elementName
{    
    _numberOfMovies = [value intValue];
     
    self.downloadProgressView.label.text = [NSString stringWithFormat:
                                            @"Descargando Película: 1/%i", _numberOfMovies];  
    [self.downloadProgressView setStyle:DADownloadProgressViewStyleDeterminate animated:YES];
}

- (void) parserDidEndDocument:(id)parser {
    self.panel.titleLabel.text = @"Cartelera Cargada";
    [super hideDownloadProgressView:nil];
    [self deleteMoviesWithoutUse];
}

- (void) parser:(DAXMLParser*)parser didEndElement:(NSString*)key {    
    static float count = 1;
    
    if ([key isEqualToString:kMovieKey]) {
        self.downloadProgressView.progressView.progress = count / _numberOfMovies;        
        self.downloadProgressView.label.text = [NSString stringWithFormat:
                                                @"Descargando Película: %i/%i",
                                                (int)count, _numberOfMovies];    
        if (count == _numberOfMovies) {
            count = 1;
        }else {
            count++;
        }
    }
}


#pragma mark -
#pragma mark DACINeolObjectsViewController Methods
- (NSFetchedResultsController*) fetchedResultsController {
    if (!_fetchedResultsController) {
        self.fetchedResultsController = [DACINeolFacade fetchedResultsForMoviesShowtimes:self.numberOfWeeks
                                                                                sortedBy:_currentSortCategory];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void) configureTabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Cartelera"
                                                       image:[UIImage imageNamed:@"DAMovieShowtimesTabBarIcon.png"]
                                                         tag:kMovieShowtimesViewControllerTag];
    self.tabBarItem = item;
    [item release];
}

#pragma mark -
#pragma mark Private Methods.
- (void) cineolDidChangeNumberOfWeeks:(NSNotification*)notification {
    _numberOfWeeks = [[[notification userInfo] objectForKey:
                       DACINeolUserDefaultsNumberOfWeeksUserInfoKey] integerValue];
    _CINeolObjectsViewControllerFlags.shouldReloadData = true;
    
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void) deleteMoviesWithoutUse {
    DADeleteMoviesOperation *operation = [[DADeleteMoviesOperation alloc]
                                          initWithNumberOfWeeks:self.numberOfWeeks];
    [self.queue addOperation:operation];
    [operation release];
}

- (NSInteger) numberOfWeeks {
    if (_numberOfWeeks == -1)
        _numberOfWeeks = [DACINeolUserDefaults numberOfWeeksInMoviesShowtimesSection];
    
    return _numberOfWeeks;
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