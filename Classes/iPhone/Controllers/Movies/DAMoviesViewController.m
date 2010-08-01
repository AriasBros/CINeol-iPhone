//
//  DAMoviesViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 29/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAMoviesViewController.h"
#import "DAMovieViewController.h"
#import "DASearchMoviesViewController.h"

#import "DACINeolFacade.h"
#import "DACINeolUserDefaults.h"

#import "DATableViewCellMovie.h"

#import "DAMovie.h"
#import "DAPhoto.h"

#define TOOLBAR_BUTTON_WEB  0
#define TOOLBAR_BUTTON_SEND 1

@interface DAMoviesViewController ()

@property (nonatomic, retain) NSFetchedResultsController *localSearchResults;

@property (nonatomic, retain) DAMovieViewController *movieViewController;
@property (nonatomic, retain) NSArray               *cellItems;
@property (nonatomic, retain) DAMovie               *selectedMovieWithLongTap;
@property (nonatomic, assign) DAMovieSortCategory   currentSortCategory;

- (void) presentSearchMoviesViewController:(id)sender;
- (void) presentMailComposeViewControllerWithMovie:(DAMovie*)movie;

- (DAMovie*) movieForRowAtIndexPath:(NSIndexPath*)indexPath atTableView:(UITableView*)tableView;

- (void) cineolDidChangeMovieSortCategory:(NSNotification*)notification;

- (NSUInteger) indexPageFromIndexPath:(NSIndexPath*)indexPath;

- (void) showSortMoviesSheet:(id)sender;

@end



@implementation DAMoviesViewController

@synthesize localSearchResults          = _localSearchResults;
@synthesize movieViewController         = _movieViewController;
@synthesize cellItems                   = _cellItems;
@synthesize selectedMovieWithLongTap    = _selectedMovieWithLongTap;
@synthesize currentSortCategory         = _currentSortCategory;


- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.hidesSearchBar = NO;
        _currentSortCategory = DAMovieSortByTitle;
        _moviesViewControllerFlags.searchDisplayControllerIsPresent = false;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
        
    self.searchBar.placeholder = @"Buscar película";

    /** Configuramos el panel **/
    ((DATableView*)self.tableView).tableEmptyView.backgroundColor = self.tableView.tableFooterView.backgroundColor;
    self.panel.titleLabel.text = @"No hay ninguna película guardada";
    self.panel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [self configureBackBarButtonItem];
    [self configureRightBarButtonItem];
    [self configureLeftBarButtonItem];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    [self.navigationController setToolbarHidden:YES animated:animated];
}


#pragma mark -
#pragma mark Public Methods.
- (DAMovieViewController*) movieViewController {
    if (_movieViewController == nil) {
        self.movieViewController = [[DAMovieViewController alloc] initWithNibName:nil bundle:nil];
        _movieViewController.delegate = self;
    }
    
    return _movieViewController;
}

- (void) configureBackBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Películas"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:nil
                                                            action:nil];
    self.navigationItem.backBarButtonItem = item;
    [item release];    
}

- (void) configureRightBarButtonItem {
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DASearchToolbarIcon.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(presentSearchMoviesViewController:)];
    self.navigationItem.rightBarButtonItem = search;
    [search release];
}

- (void) configureLeftBarButtonItem {
    UIBarButtonItem *shortItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  target:self
                                  action:@selector(showSortMoviesSheet:)];
    self.navigationItem.leftBarButtonItem = shortItem;
    [shortItem release];
}

- (DAMovieSortCategory) sortMovieCategoryForButtonAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            return DAMovieSortByPremierDate;
            
        case 1:
            return DAMovieSortByTitle;
            
        case 2:
            return DAMovieSortByDuration;
            
        case 3:
            return DAMovieSortByRating;
            
        case 4:
            return DAMovieSortByGenre;
    }
    
    return DAMovieSortByPremierDate;
}

- (NSInteger) buttonIndexForSortMovieCategory:(DAMovieSortCategory)category {
    
    switch (category) {
        case DAMovieSortByPremierDate:
            return 0;
            
        case DAMovieSortByTitle:
            return 1;
            
        case DAMovieSortByDuration:
            return 2;
            
        case DAMovieSortByRating:
            return 3;
            
        case DAMovieSortByGenre:
            return 4;
    }
    
    return 0;
}


#pragma mark -
#pragma mark DACINeolObjectsViewController Methods
- (NSFetchedResultsController*) fetchedResultsController {
    if (!_fetchedResultsController) {
        self.fetchedResultsController = [DACINeolFacade fetchedResultsForStoredMoviesSortedBy:_currentSortCategory];        
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void) configureTabBarItem {
    self.title = @"Películas Guardadas";

    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Películas"
                                                       image:[UIImage imageNamed:@"DAMoviesTabBarIcon.png"]
                                                         tag:kMoviesViewControllerTag];
    self.tabBarItem = item;
    [item release];
}


#pragma mark -
#pragma mark UITableView DataSource Methods.
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.localSearchResults.fetchedObjects count];
    }
    else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return [super numberOfSectionsInTableView:tableView];
    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DATableViewCellMovie";
    
    DATableViewCellMovie *cell = (DATableViewCellMovie*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DATableViewCellMovie alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                            reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.allowLongTouch = YES;
    }
    
    DAMovie *movie = [self movieForRowAtIndexPath:indexPath atTableView:tableView];

    cell.textLabel.text = movie.title;
    cell.detailTextLabel.text = movie.synopsis;    
    
    if (movie.poster.thumbnailURL != nil) {
        cell.imageView.image = movie.poster.thumbnail;            
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"DAMoviesEmptyThumbnail-small.png"];
    }
    
    cell.genreLabel.text = movie.genre;
    cell.durationLabel.text = [NSString stringWithFormat:@"%i min.", movie.duration];
    cell.ratingView.rating = movie.rating;
    cell.ratingView.votes = movie.numberOfVotes;
    
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate Methods.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    _currentSelectedMovie = [self indexPageFromIndexPath:indexPath];
    
    //_currentSelectedMovie = indexPath;
    
    DAMovie *movie = [self movieForRowAtIndexPath:indexPath atTableView:tableView];
    self.movieViewController.movie = movie;
    [self.navigationController pushViewController:self.movieViewController animated:YES];    
}


#pragma mark -
#pragma mark DATableView Delegate Methods.
- (NSArray*) tableView:(UITableView*)tableView
cellButtonItemsForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.cellItems == nil) {
        DACellButtonItem *web = [[DACellButtonItem alloc] initWithImage:[UIImage imageNamed:@"DAGoToCINeolToolbarIcon.png"]
                                                                    tag:0];
        
        DACellButtonItem *send = [[DACellButtonItem alloc] initWithImage:[UIImage imageNamed:@"DASendCINeolNewsToolbarIcon.png"]
                                                                     tag:1];
        
        DACellButtonItem *flex = [[DACellButtonItem alloc] initWithCellButtonSystemItem:DACellButtonSystemItemFlexibleSpace 
                                                                                    tag:DACellButtonSystemTagFlexibleSpace];    
        
        self.cellItems = [[NSArray alloc] initWithObjects:flex, web, flex, send, flex, nil];
        [web release];
        [send release];
        [flex release];
    }
    
    return self.cellItems;
}

- (BOOL) tableView:(UITableView*)tableView 
cellButtonItemTapped:(DACellButtonItem*)item 
 forRowAtIndexPath:(NSIndexPath*)indexPath
{
    self.selectedMovieWithLongTap = [self movieForRowAtIndexPath:indexPath atTableView:tableView];

    NSString *title = @"";
    switch (item.tag) {
        case TOOLBAR_BUTTON_WEB:
            title = @"Ver película en Safari";
            UIActionSheet *info = [[UIActionSheet alloc] initWithTitle:self.selectedMovieWithLongTap.title
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancelar"
                                                destructiveButtonTitle:title
                                                     otherButtonTitles:nil];
            info.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            info.tag = DAMoviesViewControllerActionSheetWeb;
            [info showFromTabBar: self.tabBarController.tabBar];
            [info release];
            
            return YES;
            
        case TOOLBAR_BUTTON_SEND:
            [self presentMailComposeViewControllerWithMovie:self.selectedMovieWithLongTap];
            
            return YES;
    }
    
    return YES;
}


#pragma mark -
#pragma mark DAPAgeViewController Delegate Methods.
- (NSInteger) numberOfPagesInPageViewController:(DAPageViewController*)controller {
    if (_moviesViewControllerFlags.searchDisplayControllerIsPresent) {
        return [self.localSearchResults.fetchedObjects count];
    }
    else {
        return [self.fetchedResultsController.fetchedObjects count];
    }
}

- (NSInteger) currentPageInPageViewController:(DAPageViewController*)controller {
    return _currentSelectedMovie;
}

- (id) pageViewController:(DAPageViewController*)controller itemOnPage:(NSInteger)index {
    _currentSelectedMovie = index;

    if (_moviesViewControllerFlags.searchDisplayControllerIsPresent) {
        return [self.localSearchResults.fetchedObjects objectAtIndex:index - 1];
    }
    else {
        return [self.fetchedResultsController.fetchedObjects objectAtIndex:index - 1];
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods.
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    _moviesViewControllerFlags.searchDisplayControllerIsPresent = true;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    _moviesViewControllerFlags.searchDisplayControllerIsPresent = false;    
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    self.localSearchResults = [DACINeolFacade fetchedResultsForMoviesUsingSearchQuery:searchString];        
    return YES;
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (actionSheet.tag) {
        case DAMoviesViewControllerActionSheetSortMovies:
            self.currentSortCategory = [self sortMovieCategoryForButtonAtIndex:buttonIndex];
            break;
            
        case DAMoviesViewControllerActionSheetWeb:
            if (buttonIndex == DAMoviesViewControllerActionSheetButtonCancel)
                return;
            
            [DACINeolFacade openURLOnSafari:self.selectedMovieWithLongTap.CINeolURL];
            self.selectedMovieWithLongTap = nil;
            break;
    }
}


#pragma mark -
#pragma mark MFMailComposeViewController Delegate Methods.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error 
{	
    /*
	switch (result)
	{
		case MFMailComposeResultCancelled:
            NSLog(@"Cancelado.");    
            break;
		case MFMailComposeResultSaved:
            NSLog(@"Guardado.");    
			break;
		case MFMailComposeResultSent:
            NSLog(@"Enviado.");    
			break;
		case MFMailComposeResultFailed:
            NSLog(@"Error.");    
			break;
		default:
            NSLog(@"No enviado.");    
			break;
	}
    */
    
	[self.navigationController dismissModalViewControllerAnimated:YES];
}




#pragma mark -
#pragma mark Private Methods.
- (void) setCurrentSortCategory:(DAMovieSortCategory)category {
    if (_currentSortCategory != category) {
        
        _currentSortCategory = category;
        
        self.fetchedResultsController = nil;
        
        if (self.navigationController.view.superview != nil) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            self.tableView.alpha = 0.0;
        }

        [self.tableView reloadData];
        
        if (self.navigationController.view.superview != nil) {
            self.tableView.alpha = 1.0;
            [UIView commitAnimations];
        }
    }
}

- (void) showSortMoviesSheet:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Ordenar películas por:"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Fecha de estreno",
                                                                @"Título",
                                                                @"Duración",
                                                                @"Puntuación",
                                                                //@"Género", 
                                                                nil];
    sheet.destructiveButtonIndex = [self buttonIndexForSortMovieCategory:_currentSortCategory];
    sheet.tag = DAMoviesViewControllerActionSheetSortMovies;
    [sheet showInView:self.tabBarController.tabBar];
    [sheet release];
}


- (void) cineolDidChangeMovieSortCategory:(NSNotification*)notification {
    self.currentSortCategory = [[[notification userInfo] objectForKey:
                                 DACINeolUserDefaultsMovieSortCategoryUserInfoKey] integerValue];
}

- (DAMovie*) movieForRowAtIndexPath:(NSIndexPath*)indexPath atTableView:(UITableView*)tableView {
    DAMovie *movie = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        /** 
         *  Si en lugar de "objectAtIndex:" uso "objectAtIndexPath:" el programa peta
         *  ¿Por qué será?
         **/
        movie = [self.localSearchResults.fetchedObjects objectAtIndex:indexPath.row]; 
    }
    else {
        movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    return movie;
}

- (NSUInteger) indexPageFromIndexPath:(NSIndexPath*)indexPath {
    
    if (_moviesViewControllerFlags.searchDisplayControllerIsPresent ||
        [self.fetchedResultsController.sections count] == 1)
    {
        return indexPath.row + 1;
    }

    NSUInteger row = 1;
    id<NSFetchedResultsSectionInfo> section = nil;
    for (int i = 0; i < indexPath.section; i++) {
        section = [self.fetchedResultsController.sections objectAtIndex:i];
        row += section.numberOfObjects;
    }
    
    row += indexPath.row;
    
    return row;
}

- (void) presentSearchMoviesViewController:(id)sender {    
    DASearchMoviesViewController *controller = [[DASearchMoviesViewController alloc]
                                                initWithStyle:UITableViewStylePlain];    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void) presentMailComposeViewControllerWithMovie:(DAMovie*)movie {
    [DACINeolFacade presentMailComposeViewControllerInController:self
                                                           movie:movie];
}


#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];   
    
    if (_movieViewController.view.superview == nil)
        self.movieViewController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    if (_movieViewController.view.superview == nil)
        self.movieViewController = nil;
}

- (void)dealloc {
    [_movieViewController release];         _movieViewController = nil;
    [_cellItems release];                   _cellItems = nil;
    [_selectedMovieWithLongTap release];    _selectedMovieWithLongTap = nil;
    [_localSearchResults release];          _localSearchResults = nil;
    [super dealloc];
}

@end