    //
//  DASearchMoviesViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 29/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DASearchMoviesViewController.h"
#import "DAMovieViewController.h"

#import "DACoreDataManager.h"

#import "DACINeolManager.h"
#import "DACINeolFacade.h"
#import "DAParseSearchMoviesOperation.h"
#import "UISearchDisplayControllerAdds.h"

#import "DAMovie.h"


@interface DASearchMoviesViewController ()

@property (nonatomic, copy) NSString *currentQuery;
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) NSArray *dataSource;

- (void) cineolWillSearchMovies:(NSNotification*)notification;
- (void) cineolDidSearchMovies:(NSNotification*)notification;
- (void) cineolDidFailToSearchMovies:(NSNotification*)notification;

- (DAMovie*) movieAtIndexPath:(NSIndexPath*)indexPath;

@end


@implementation DASearchMoviesViewController

@synthesize currentQuery = _currentQuery;
@synthesize operationQueue = _operationQueue;
@synthesize dataSource = _dataSource;


- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.hidesSearchBar = NO;
        self.hidesBottomBarWhenPushed = YES;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        _searchMoviesViewControllerFlags.searching = false;
        
        self.title = @"Buscar Películas";
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        self.operationQueue = queue;
        [queue release];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Buscar en CINeol.net";
    self.searchBar.showsCancelButton = YES;
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolWillSearchMovies:)
                                                 name:DACINeolWillSearchMoviesNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidSearchMovies:)
                                                 name:DACINeolDidSearchMoviesNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidFailToSearchMovies:)
                                                 name:DACINeolDidFailToSearchMoviesNotification
                                               object:[DACINeolManager sharedManager]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchBar.tintColor = [UIColor colorWithRed:0.301 green:0.596 blue:0.807 alpha:1.0];
    
    ((DATableView*)self.tableView).tableEmptyView.hidden = YES;
    
    // Mostramos la SearchBar por defecto.
    CGPoint currentOffset = self.tableView.contentOffset;
    currentOffset.y -= self.searchBar.frame.size.height;
    self.tableView.contentOffset = currentOffset;
    
    [self.searchDisplayController setActive:YES animated:NO];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    
    if ([self.searchDisplayController.searchResultsTableView numberOfRowsInSection:0] == 0)
        [self.searchBar becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

/*
- (NSArray*) dataSource {
    if (_dataSource == nil) {
        NSArray *array = [[NSArray alloc] init];
        self.dataSource = array;
        [array release];
    }
    
    return _dataSource;
}
*/


#pragma mark -
#pragma mark UISearchBar Delegate Methods.
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return _searchMoviesViewControllerFlags.searching == false;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {    
    self.dataSource = nil;
    
    [self.searchDisplayController performSelector:@selector(setNoResultsLabelText:)
                                       withObject:@""
                                       afterDelay:0.05];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {  
    self.currentQuery = [searchBar.text stringByAddingPercentEscapesUsingEncoding:
                         NSUTF8StringEncoding];

    [[DACINeolManager sharedManager] searchMovies:self.currentQuery];
    [self.searchDisplayController setNoResultsLabelText:@"Buscando..."];
    
    [FlurryAPI logEvent:DAFlurryEventSearchInCINeol withSearchQuery:searchBar.text];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods.
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark DACINeolManager Notification Methods.
- (void) cineolWillSearchMovies:(NSNotification*)notification {
    _searchMoviesViewControllerFlags.searching = true;
}

- (void) cineolDidSearchMovies:(NSNotification*)notification {
    _searchMoviesViewControllerFlags.searching = false;
    
    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];
    
    DAParseSearchMoviesOperation *operation = [[DAParseSearchMoviesOperation alloc]
                                               initWithData:data delegate:self];
    [self.operationQueue addOperation:operation];
    [operation release];
}

- (void) cineolDidFailToSearchMovies:(NSNotification*)notification {
    [self.searchDisplayController setNoResultsLabelText:@"Error al conectar con CINeol.net"];
}


#pragma mark -
#pragma mark DAXMLParser Delegate Methods.
- (void) parserDidEndDocument:(id)parser {
    _searchMoviesViewControllerFlags.searching = false;
    
    self.dataSource = [[parser searchResults] sortedArrayUsingDescriptors:
                       [DACINeolFacade sortDescriptorsForSearchMovies]];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    if ([self.dataSource count] == 0)
        [self.searchDisplayController setNoResultsLabelText:@"Ningún resultado"];
}


#pragma mark -
#pragma mark UITableView DataSource Methods.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                            reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    
    DAMovie *movie = [self movieAtIndexPath:indexPath];
        
    cell.textLabel.text = movie.indexTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", movie.year];
    
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate Methods.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    _currentSelectedMovie = indexPath.row + 1;
    
    DAMovie *movie = [self movieAtIndexPath:indexPath];
    self.movieViewController.movie = movie;
    [self.navigationController pushViewController:self.movieViewController animated:YES];
}


#pragma mark -
#pragma mark DAPAgeViewController Delegate Methods.
- (NSInteger) numberOfPagesInPageViewController:(DAPageViewController*)controller {
    return [self.dataSource count];
}

- (id) pageViewController:(DAPageViewController*)controller itemOnPage:(NSInteger)index {
    _currentSelectedMovie = index;
        
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
    return [self movieAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark Private Methods.
- (DAMovie*) movieAtIndexPath:(NSIndexPath*)indexPath {
    DAMovie *movie = [self.dataSource objectAtIndex:indexPath.row];    
    movie = (DAMovie*)[[[DACoreDataManager sharedManager] managedObjectContext] 
                       objectWithID:[movie objectID]];
    
    return movie;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_currentQuery release];    _currentQuery = nil;
    [_operationQueue release];  _operationQueue = nil;
    [_dataSource release];      _dataSource = nil;
    
    [super dealloc];
}

@end