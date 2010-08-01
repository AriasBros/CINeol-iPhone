//
//  DAMovieViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DAMovieViewController.h"
#import "DAPhotoGalleryViewController.h"
#import "DACommentViewController.h"

#import "DAMovieView.h"
#import "DAMovieCommentsView.h"
#import "DABarButtonItemComments.h"

#import "DATableViewCellComments.h"

#import "DAXMLParserMovieCINeol.h"
#import "DAParseCommentsOperation.h"

#import "DAMovie.h"
#import "DAPhoto.h"
#import "DATrailer.h"
#import "DAPerson.h"
#import "DACredit.h"
#import "DAComment.h"

#import "DACINeolFacade.h"
#import "DACINeolManager.h"
#import "DACINeolUserDefaults.h"

#define CINEOL_URL_BASE @"http://www.cineol.net/"

#define TOOLBAR_BUTTON_WEB      10
#define TOOLBAR_BUTTON_SEND     11
#define TOOLBAR_BUTTON_STORE    12
#define TOOLBAR_BUTTON_RATING   13
#define TOOLBAR_BUTTON_COMMENTS 14

#define BUTTON_OK               0
#define BUTTON_CANCEL           1


@interface DAMovieViewController ()

@property (nonatomic, retain) DAMovieView *movieView;
@property (nonatomic, retain) DADownloadProgressView        *downloadProgressView;
@property (nonatomic, retain) DAMoviePlayerViewController   *moviePlayerViewController;
@property (nonatomic, retain) DAPhotoGalleryViewController  *photoGalleryViewController;

@property (nonatomic, retain) NSArray                       *trailersDataSource;
@property (nonatomic, retain) NSArray                       *castDataSource;
@property (nonatomic, retain) NSArray                       *creditsDataSource;
@property (nonatomic, retain) NSArray                       *commentsDataSource;

@property (nonatomic, assign) DABarButtonItem               *ratingBarButttonItem;

@property (nonatomic, retain) NSOperationQueue *queue;

- (void) updateMovieView;
- (void) updateToolbarArrowsItems;
- (BOOL) needsDownloadMoreComments;

- (void) configureToolbarItemsAnimated:(BOOL)animated;
- (void) configureToolbarToDefaultItemsAnimated:(BOOL)animated;
- (void) configureToolbarToCommentsItemsAnimated:(BOOL)animated;
- (void) configureToolbarToDownloadingMovieItemsAnimated:(BOOL)animated;

- (void) barButtonItemDidTouch:(id)sender;
- (void) showMailComposeViewController:(id)sender;
- (void) flipToCommentsSide:(id)sender;
- (void) storeMovie:(id)sender;
- (void) deleteMovie:(id)sender;

- (void) cineolWillDownloadMovie:(NSNotification*)notification;
- (void) cineolDidDownloadMovie:(NSNotification*)notification;
- (void) cineolDidFailToDownloadMovie:(NSNotification*)notification;

- (void) cineolWillDownloadCommentsForMovie:(NSNotification*)notification;
- (void) cineolDidDownloadCommentsForMovie:(NSNotification*)notification;
- (void) cineolDidFailToDownloadCommentsForMovie:(NSNotification*)notification;

- (void) showTrailerErrorAlertDialog;

- (UITableViewCell*) detailsSection:(UITableView*)tableView 
              cellForRowAtIndexPath:(NSIndexPath*)indexPath;

- (UITableViewCell*) multimediaSection:(UITableView*)tableView 
                 cellForRowAtIndexPath:(NSIndexPath*)indexPath;

- (UITableViewCell*) castSection:(UITableView*)tableView 
           cellForRowAtIndexPath:(NSIndexPath*)indexPath;

- (UITableViewCell*) creditsSection:(UITableView*)tableView 
              cellForRowAtIndexPath:(NSIndexPath*)indexPath;

- (UITableViewCell*) commentsSecion:(UITableView*)tableView 
              cellForRowAtIndexPath:(NSIndexPath*)indexPath;

@end


@implementation DAMovieViewController

@synthesize movie = _movie;
@synthesize movieView = _movieView;
@synthesize downloadProgressView        = _downloadProgressView;
@synthesize moviePlayerViewController   = _moviePlayerViewController;
@synthesize photoGalleryViewController  = _photoGalleryViewController;

@synthesize trailersDataSource          = _trailersDataSource;
@synthesize castDataSource              = _castDataSource;
@synthesize creditsDataSource           = _creditsDataSource;
@synthesize commentsDataSource          = _commentsDataSource;

@synthesize queue                       = _queue;

@synthesize ratingBarButttonItem    = _ratingBarButttonItem;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed = YES;
        
        _movieViewControllerFlags.showingTrailer = false;
        _movieViewControllerFlags.showingPosterInFullScreenMode = false;
        _movieViewControllerFlags.showingComments = false;
        _movieViewControllerFlags.downloadingMovie = false;
        
        _downloadingPageOfComments = 0;
        
        self.queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void) loadView {
    CGRect frame = [UIScreen mainScreen].bounds;
    
    self.view = [[UIView alloc] initWithFrame:frame];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:
                                 [UIImage imageNamed:@"DATableViewStyleGroupedPattern1.png"]];
    
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                 UIViewAutoresizingFlexibleHeight;
    
    /*
    #if __IPHONE_OS_VERSION_MIN_REQUIRED > 30000
    if ([UIDevice currentDevice].multitaskingSupported) {
        frame.origin.x = 10.0;
        frame.origin.y = 10.0;
        frame.size.width -= 20.0;
        frame.size.height -= 20.0;        
    }
    #endif
    */
    
    self.movieView = [[DAMovieView alloc] initWithFrame:frame];
    self.movieView.synopsisLabel.text = @"Sinopsis";
    self.movieView.delegate = self;
    self.movieView.dataSource = self;
    
    [self.view addSubview:self.movieView];  
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolWillDownloadMovie:) 
                                                 name:DACINeolWillDownloadMovieNotification
                                               object:[DACINeolManager sharedManager]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidDownloadMovie:) 
                                                 name:DACINeolDidDownloadMovieNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidFailToDownloadMovie:) 
                                                 name:DACINeolDidFailToDownloadMovieNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolWillDownloadCommentsForMovie:) 
                                                 name:DACINeolWillDownloadCommentsForMovieNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidDownloadCommentsForMovie:) 
                                                 name:DACINeolDidDownloadCommentsForMovieNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidFailToDownloadCommentsForMovie:) 
                                                 name:DACINeolDidFailToDownloadDownloadCommentsForMovieNotification
                                               object:[DACINeolManager sharedManager]];    
    self.movie = self.movie;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    if (!_movieViewControllerFlags.showingComments) {
        self.movieView.currentSide = DAMovieViewSideInfo;
        //[self.movieView scrollToSection:DAMovieViewSectionSynopsis animated:NO];
        
        if ([self.movie needsDownloadContent]) {
            [[DACINeolManager sharedManager] movieWithID:self.movie.CINeolID];
        }
        else {
            [self updateMovieView];   
        }    
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.movieView flashScrollIndicatorsOfSynopsisView];
    
    [FlurryAPI logEvent:DAFlurryEventShowMovie withMovie:self.movie];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Properties.
- (void) setMovie:(DAMovie *)movie {
    _movieViewControllerFlags.downloadingMovie = false;
    _movieViewControllerFlags.movieFailToDownload = false;
    
    if (movie != _movie) {        
        [_movie release];
        _movie = movie;
        [_movie retain];
    }
    
    [self updateMovieView];
}

#pragma mark -
#pragma mark DataSources
- (NSArray*) trailersDataSource {
    if (_trailersDataSource == nil) {
        self.trailersDataSource = [[self.movie.trailers allObjects]
                                   sortedArrayUsingDescriptors:[DACINeolFacade sortDescriptorsForTrailers]];
    }
    
    return _trailersDataSource;
}

- (NSArray*) creditsDataSource {
    if (_creditsDataSource == nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type != %i", DACreditTypePerformer];
        NSSet *filteredSet = [self.movie.credits filteredSetUsingPredicate:predicate];
        
        self.creditsDataSource = [[filteredSet allObjects] sortedArrayUsingDescriptors:
                                  [DACINeolFacade sortDescriptorsForCredits]];
    }
    
    return _creditsDataSource;
}

- (NSArray*) castDataSource {
    if (_castDataSource == nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %i", DACreditTypePerformer];
        NSSet *filteredSet = [self.movie.credits filteredSetUsingPredicate:predicate];
        
        self.castDataSource = [filteredSet allObjects];
        
        self.castDataSource = [[filteredSet allObjects] sortedArrayUsingDescriptors:
                               [DACINeolFacade sortDescriptorsForCasting]];
    }
    
    return _castDataSource;
}

- (NSArray*) commentsDataSource {
    if (_commentsDataSource == nil) {
        self.commentsDataSource = [[self.movie.comments allObjects]
                                   sortedArrayUsingDescriptors:[DACINeolFacade sortDescriptorsForComments]];        
    }
    
    return _commentsDataSource;
}

#pragma mark -
#pragma mark Actions Methods.
- (void) storeMovie:(id)sender {
    self.movie.buffering = 0;
    
    //if (![self.movie isInserted])
    //    [DACINeolFacade insertMovie:self.movie];
    
    [self configureToolbarToDefaultItemsAnimated:YES];    
    
    [FlurryAPI logEvent:DAFlurryEventStoreMovie withMovie:self.movie];
}

- (void) deleteMovie:(id)sender {
    self.movie.buffering = 1;
    [self configureToolbarToDefaultItemsAnimated:YES];
}

- (void) previousPageOfComments:(id)sender {
    [self.movieView.commentsView goToPreviousPage:sender];

    if ([self needsDownloadMoreComments])
        [self.movieView.commentsView setState:DAMovieCommentsViewStateLoadingComments 
                                     animated:YES];
    else {
        [self.movieView.commentsView setState:DAMovieCommentsViewStateShowingComments
                                     animated:YES];        
        [self updateToolbarArrowsItems];
    }    
}

- (void) nextPageOfComments:(id)sender {
    [self.movieView.commentsView goToNextPage:sender];

    if ([self needsDownloadMoreComments])
        [self.movieView.commentsView setState:DAMovieCommentsViewStateLoadingComments 
                                     animated:YES];
    else {
        [self.movieView.commentsView setState:DAMovieCommentsViewStateShowingComments
                                     animated:YES];        
        [self updateToolbarArrowsItems];
    }    
}

- (void) showPhotoGallery:(id)sender {
    self.photoGalleryViewController = [[DAPhotoGalleryViewController alloc] 
                                       initWithPhotos:[[self.movie.photos allObjects]
                                                       sortedArrayUsingDescriptors:[DACINeolFacade sortDescriptorsForPhotos]]];
    
    [self.navigationController pushViewController:self.photoGalleryViewController animated:YES];
    [self.photoGalleryViewController release];
    
    [FlurryAPI logEvent:DAFlurryEventShowGallery withMovie:self.movie];
}

- (void) showTrailer:(DATrailer*)trailer {
    NSURL *url = [DACINeolFacade URLForDailymotionVideoWithVideoID:trailer.dailymotionID];
    
    if (url != nil) {
        DAMoviePlayerViewController *moviePlayerViewController = nil;
        
        moviePlayerViewController = [[DAMoviePlayerViewController alloc] initWithContentURL:url];
        
        [self presentModalViewController:moviePlayerViewController animated:YES];
        moviePlayerViewController.textLabel.text = @"Cargando trailer...";
        moviePlayerViewController.detailTextLabel.text = @"(Toca la pantalla para cancelar y cerrar)";
        [moviePlayerViewController release];
        
        [FlurryAPI logEvent:DAFlurryEventShowTrailer withTrailer:trailer];
    }
    else {
        [self showTrailerErrorAlertDialog];
    }
}

- (NSUInteger) numberOfCommentsForPageAtIndex:(NSUInteger)page {
    if (_movieViewControllerFlags.commentsFailToDownload)
        return 0;
    
    if (self.movieView.commentsView.numberOfPages == 1)
        return self.movie.numberOfComments;
    else if (page < self.movieView.commentsView.numberOfPages)
        return self.movieView.commentsView.numberOfCommentsPerPage;
    else {
        return self.movie.numberOfComments -
                self.movieView.commentsView.numberOfCommentsPerPage * 
                (self.movieView.commentsView.numberOfPages - 1);                
    }
}

- (void) flipToCommentsSide:(id)sender {
    _movieViewControllerFlags.showingComments = !_movieViewControllerFlags.showingComments;
    [self configureToolbarItemsAnimated:YES]; 
    
    if (_movieViewControllerFlags.showingComments) {
        self.title = @"Comentarios";
        
        [self.movieView.commentsView.tableView reloadData];
        
        if ([self needsDownloadMoreComments])
            [self.movieView.commentsView setState:DAMovieCommentsViewStateLoadingComments 
                                         animated:NO];
        else
            [self.movieView.commentsView setState:DAMovieCommentsViewStateShowingComments
                                         animated:NO];
        
        [self.movieView flipToSide:DAMovieViewSideComments animated:YES];
        
        [FlurryAPI logEvent:DAFlurryEventShowComments withMovie:self.movie];
    }
    else {
        self.title = @"Ficha";
        [self.movieView flipToSide:DAMovieViewSideInfo animated:YES];        
    }
    
    //_movieViewControllerFlags.showingComments = !_movieViewControllerFlags.showingComments;
    //[self configureToolbarItemsAnimated:YES]; 
}

#pragma mark -
#pragma mark Subclassing Methods.
- (void) updateItem:(id)item {
    self.movie = item;
}

#pragma mark -
#pragma mark Key Value Observing Methods.
- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change 
                        context:(void *)context
{
    if (_movieViewControllerFlags.showingPosterInFullScreenMode == true && 
        [keyPath isEqualToString:@"photo"] &&
        [self.movie.poster isPhotoLoaded])
    {
        self.movieView.posterView.image = self.movie.poster.photo;
    }
}

#pragma mark -
#pragma mark DAMovieView Delegate Methods.
- (BOOL) movieViewIsPosterLoaded:(DAMovieView*)movieView {
    return self.movie.poster.isPhotoLoaded;
}

- (BOOL) movieView:(DAMovieView*)movieView posterViewShouldEnterInFullScreenMode:(DAImageView*)posterView {
    BOOL value = _movieViewControllerFlags.downloadingMovie; // ¿Estamos descargando la peli?
    
    if (!value) {
        value = (self.movie.poster.photoURL == nil); // ¿Tiene poster grande la peli?
        
        if (value) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.movie.title
                                                                message:@"Lo sentimos, pero no disponemos del poster (en tamaño grande) de esta película."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cerrar"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    
    return !value;
}

- (void) movieView:(DAMovieView*)movieView posterViewWillEnterInFullScreenMode:(UIImageView*)posterView
{        
    [self.movie.poster addObserver:self forKeyPath:@"photo" options:0 context:NULL];

    _movieViewControllerFlags.showingPosterInFullScreenMode = true;
    
    if (self.movie.poster.photo != nil)
        self.movieView.posterView.image = self.movie.poster.photo;
    
    // Si la imagen del poster (la version grande) no esta descarga se pondra a descargar.
}

- (void) movieView:(DAMovieView*)movieView posterViewDidEnterInFullScreenMode:(UIImageView*)posterView
{
    /**
     *  Ocultando y mostrando la toolbar y la navigationBar cuando presentamos y quitamos el
     *  poster del modo full screen "matamos dos bugs de un tiro":
     *
     *  - Arreglamos el bug que hace que cuando rotamos el movil mientras vemos el poster
     *    las barras se superponian por enciama del poster durante la animacion de rotacion.
     *
     *  - Al igual que antes, si rotabamos y quitabamos el poster estando en la nueva posicion,
     *    la barra de estado se superponia por encima de nuestra vista.
     **/
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    if (self.movie.poster.photo != nil)
        self.movieView.posterView.image = self.movie.poster.photo; 
    
    [FlurryAPI logEvent:DAFlurryEventShowPoster withMovie:self.movie];
}

- (void) movieView:(DAMovieView*)movieView posterViewWillExitOfFullScreenMode:(UIImageView*)posterView 
{
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    @try {
        [self.movie.poster removeObserver:self forKeyPath:@"photo"];    
    }
    @catch (NSException * e) {
        NSLog(@"%@", e);
    }
    @finally {
    }
}

- (void) movieView:(DAMovieView*)movieView posterViewDidExitOfFullScreenMode:(UIImageView*)posterView
{
    self.movieView.posterView.image = self.movie.poster.thumbnail;
    _movieViewControllerFlags.showingPosterInFullScreenMode = false;
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == BUTTON_CANCEL)
        return;
    
    switch (actionSheet.tag) {
        case TOOLBAR_BUTTON_WEB:
            [FlurryAPI logEvent:DAFlurryEventShowMovieOnCINeol withMovie:self.movie];
            [DACINeolFacade openURLOnSafari:self.movie.CINeolURL];
            break;
            
        case TOOLBAR_BUTTON_SEND:
            break;
    }
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate Methods.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error 
{	
    if (error != nil)
        [FlurryAPI logError:DAFlurryErrorSendMail
                    message:@"Error sending movie for mail"
                      error:error];
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
            NSLog(@"Cancelado.");    
            break;
            
		case MFMailComposeResultSaved:
            NSLog(@"Guardado.");    
			break;
            
		case MFMailComposeResultSent:
            [FlurryAPI logEvent:DAFlurryEventSendMovieForMail withMovie:self.movie];
			break;
            
		case MFMailComposeResultFailed:
            NSLog(@"Error.");    
			break;
            
		default:
            NSLog(@"No enviado.");    
			break;
	}
    
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark DAPageViewController Delegate Methods.
- (NSInteger) numberOfPagesInPageViewController:(DAPageViewController*)controller {
    return [self.commentsDataSource count];
}

- (NSInteger) currentPageInPageViewController:(DAPageViewController*)controller {
    return _currentComment;
}

- (id) pageViewController:(DAPageViewController*)controller itemOnPage:(NSInteger)index {
    _currentComment = index;
    
    return [self.commentsDataSource objectAtIndex:index - 1];
}

#pragma mark -
#pragma mark DACINeolManager Notification Methods.
- (void) cineolWillDownloadMovie:(NSNotification*)notification { 

    NSUInteger ID = [[[notification userInfo] objectForKey:DACINeolMovieIDUserInfoKey] integerValue];
    if (self.movie.CINeolID != ID)
        return;
    
    _movieViewControllerFlags.downloadingMovie = true;
    
    // Configuramos el PageControl.
    self.movieView.pageControl.numberOfPages = 1;
    
    [self configureToolbarItemsAnimated:YES];
}

- (void) cineolDidDownloadMovie:(NSNotification*)notification {
    
    NSUInteger ID = [[[notification userInfo] objectForKey:DACINeolMovieIDUserInfoKey] integerValue];
    if (self.movie.CINeolID != ID)
        return;
    
    _movieViewControllerFlags.movieFailToDownload = false;

    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];
 
    DAXMLParserMovieCINeol *operation = nil;
    if (ID == self.movie.CINeolID) {
        operation = [[DAXMLParserMovieCINeol alloc] initWithData:data 
                                                        delegate:self
                                                           movie:self.movie];
    }
    else {
        operation = [[DAXMLParserMovieCINeol alloc] initWithData:data
                                                        delegate:self
                                               movieWithCINeolID:ID];
    }

    [self.queue addOperation:operation];
    [operation release];
}

- (void) cineolDidFailToDownloadMovie:(NSNotification*)notification {
    _movieViewControllerFlags.movieFailToDownload = true;
    _movieViewControllerFlags.downloadingMovie = false;
    
    [self.downloadProgressView.spinnerView stopAnimating];
    self.downloadProgressView.label.text = @"Error descargando la película";
    [self.downloadProgressView setNeedsLayout];
    
    [self performSelector:@selector(updateMovieView) withObject:nil afterDelay:2.0];
}

- (void) cineolWillDownloadCommentsForMovie:(NSNotification*)notification {
    _movieViewControllerFlags.downloadingComments = true;
    _downloadingPageOfComments = self.movieView.commentsView.currentPage;
    [self updateToolbarArrowsItems];
}

- (void) cineolDidDownloadCommentsForMovie:(NSNotification*)notification {   
    _movieViewControllerFlags.commentsFailToDownload = false;

    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];
    DAParseCommentsOperation *operation = [[DAParseCommentsOperation alloc]
                                           initWithData:data
                                               delegate:self
                                                  movie:self.movie];
    [self.queue addOperation:operation];
    [operation release];
}

- (void) cineolDidFailToDownloadCommentsForMovie:(NSNotification*)notification {
    _movieViewControllerFlags.commentsFailToDownload = true;
    [self.movieView.commentsView setState:DAMovieCommentsViewStateErrorLoadingComments
                                 animated:YES];
}

#pragma mark -
#pragma mark DAXMLParser Delegate Methods.
- (void) parserDidEndDocument:(id)parser {  
    if ([parser isKindOfClass:[DAParseCommentsOperation class]]) {
        self.commentsDataSource = nil;  // Reseteamos el Data Source de los comentarios para
                                        // que se añadan y se ordenen los nuevos comentarios.
        [self.movieView.commentsView setState:DAMovieCommentsViewStateShowingComments 
                                     animated:YES];
        _movieViewControllerFlags.downloadingComments = false;
        _downloadingPageOfComments = 0;
        [self updateToolbarArrowsItems];
    }
    else {
        _movieViewControllerFlags.downloadingMovie = false;
        _movieViewControllerFlags.movieFailToDownload = false;
        
        if ([parser managedObjectID] == [self.movie objectID]) {                    
            [self updateMovieView];   
        }
    }
}

#pragma mark -
#pragma mark UITableView DataSource Methods.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case DAMovieViewSectionDetails:
        default:
            return [self detailsSection:tableView cellForRowAtIndexPath:indexPath];
            
        case DAMovieViewSectionMultimedia:
            return [self multimediaSection:tableView cellForRowAtIndexPath:indexPath];
            
        case DAMovieViewSectionCast:
            return [self castSection:tableView cellForRowAtIndexPath:indexPath];
            
        case DAMovieViewSectionCredits:
            return [self creditsSection:tableView cellForRowAtIndexPath:indexPath];
            
        case DAMovieViewSideComments:
            return [self commentsSecion:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case DAMovieViewSectionDetails:
            return 7;
            
        case DAMovieViewSectionMultimedia:
            return [self.trailersDataSource count] + ([self.movie.photos count] > 0 ? 1 : 0);
            
        case DAMovieViewSectionCast:
            return [self.castDataSource count];
            
        case DAMovieViewSectionCredits:
            return [self.creditsDataSource count];
            
        case DAMovieViewSideComments:
            return [self numberOfCommentsForPageAtIndex:self.movieView.commentsView.currentPage];

        default:
            return 0;
    }
}


- (UITableViewCell*) detailsSection:(UITableView*)tableView 
              cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"DATableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.numberOfLines = 1;
        cell.detailTextLabel.numberOfLines = 1;
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];

        cell.textLabel.textColor = [UIColor colorWithWhite:21.0/255 alpha:1.0]; 
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:90.0/255 alpha:1.0]; 
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Año";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", self.movie.year];
            break;

        case 1:
            cell.textLabel.text = @"País";
            cell.detailTextLabel.text = self.movie.country;
            break;

        case 2:
            cell.textLabel.text = @"Formato";
            cell.detailTextLabel.text = self.movie.format;
            break;
            
        case 3:
            cell.textLabel.text = @"Título original";
            cell.detailTextLabel.text = self.movie.originalTitle;
            break;
            
        case 4:
            cell.textLabel.text = @"Estreno país de origen";
            if (self.movie.datePremierOrigin == nil)
                cell.detailTextLabel.text = @"No disponible";
            else
                cell.detailTextLabel.text = self.movie.datePremierOriginText;
            break;
            
        case 5:
            cell.textLabel.text = @"Recaudación España";
            if (self.movie.takingsSpain == 0)
                cell.detailTextLabel.text = @"No disponible";
            else {
                NSNumber *takings = [[NSNumber alloc] initWithFloat:self.movie.takingsSpain];
                cell.detailTextLabel.text = [[DAFormatter defaultFormatter] 
                                             stringFromNumber:takings
                                             withNumberStyle:NSNumberFormatterCurrencyStyle
                                             groupingSeperator:@"."
                                             decimalSeparator:@","
                                             localeIdentifier:@"es_ES"
                                             currencySymbol:@"€"
                                             currencyCode:@"EUR"];                
                [takings release];
            }
            break;
            
        case 6:
            cell.textLabel.text = @"Recaudación USA";
            if (self.movie.takingsUSA == 0)
                cell.detailTextLabel.text = @"No disponible";
            else {
                NSNumber *takings = [[NSNumber alloc] initWithFloat:self.movie.takingsUSA];
                cell.detailTextLabel.text = [[DAFormatter defaultFormatter] 
                                             stringFromNumber:takings
                                              withNumberStyle:NSNumberFormatterCurrencyStyle
                                            groupingSeperator:@","
                                             decimalSeparator:@"."
                                             localeIdentifier:@"en_US"
                                               currencySymbol:@"$"
                                                 currencyCode:@"USD"];                
                [takings release];
            }
            break;
    }
    
    return cell;
}

- (UITableViewCell*) multimediaSection:(UITableView*)tableView 
                 cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"DATableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];

        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.textLabel.numberOfLines = 1;
        cell.detailTextLabel.numberOfLines = 1;
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:21.0/255 alpha:1.0]; 
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:90.0/255 alpha:1.0];         
    }
        
    if ([self.movie.photos count] > 0 && indexPath.row == 0) {
        cell.textLabel.text = @"Galería de fotos";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i fotos", [self.movie.photos count]];
    }
    else {
        int row = indexPath.row;
        if ([self.movie.photos count] > 0)
            row--;
        
        DATrailer *trailer = [self.trailersDataSource objectAtIndex:row];
        
        cell.textLabel.text = trailer.desc;
        cell.detailTextLabel.text = [[DACalendar defaultCalendar] stringFromDate:trailer.date
                                                                  withDateFormat:@"dd - MMMM - yyyy"];
    }  
    
    return cell;
}

- (UITableViewCell*) castSection:(UITableView*)tableView 
           cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"DATableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.numberOfLines = 1;
        cell.detailTextLabel.numberOfLines = 1;
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:21.0/255 alpha:1.0]; 
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:90.0/255 alpha:1.0]; 
    }
    
    DACredit *credit = [self.castDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = credit.person.name;
    cell.detailTextLabel.text = credit.job;
    
    return cell;
}

- (UITableViewCell*) creditsSection:(UITableView*)tableView 
              cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"DATableViewCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.numberOfLines = 1;
        cell.detailTextLabel.numberOfLines = 1;
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:21.0/255 alpha:1.0]; 
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:90.0/255 alpha:1.0]; 
    }
    
    DACredit *credit = [self.creditsDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = credit.person.name;
    
    switch (credit.type) {
        case DACreditTypeDirector:
            cell.detailTextLabel.text = @"Director";
            break;
            
        case DACreditTypeProducer:
            cell.detailTextLabel.text = @"Productor";
            break;
            
        case DACreditTypeScriptwriter:
            cell.detailTextLabel.text = @"Guionista";
            break;
            
        case DACreditTypePhotographer:
            cell.detailTextLabel.text = @"Fotógrafo";
            break;
            
        case DACreditTypeMusician:
            cell.detailTextLabel.text = @"Músico";
            break;
    }
    
    return cell;    
}


- (UITableViewCell*) commentsSecion:(UITableView*)tableView 
              cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"DATableViewCellComments";
    
    DATableViewCellComments *cell = (DATableViewCellComments*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DATableViewCellComments alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.textLabel.numberOfLines = 1;
        cell.detailTextLabel.numberOfLines = 1;
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:21.0/255 alpha:1.0]; 
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:90.0/255 alpha:1.0]; 
        
        cell.allowLongTouch = NO;
    }
    
    NSUInteger index = self.movieView.commentsView.currentOffset + indexPath.row;
    
    if (index >= [self.commentsDataSource count])
        return cell;
    
    DAComment *comment = [self.commentsDataSource objectAtIndex:index];
    cell.textLabel.text = comment.user;
    cell.detailTextLabel.text = [[DACalendar defaultCalendar] stringFromDate:comment.date
                                                              withDateFormat:kCINeolDateCommentFormat];
    [cell loadComment:comment.message];
    
    return cell;
}


#pragma mark -
#pragma mark UITableView Delegate Methods.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (tableView.tag) {
        case DAMovieViewSectionDetails:
            return 40.0;
            
        case DAMovieViewSectionMultimedia:
            return 40.0;
            
        case DAMovieViewSectionCast:
            return 40.0;
            
        case DAMovieViewSectionCredits:
            return 40.0;
            
        case DAMovieViewSideComments:
            return 60.0;

        default:
            return 44.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.tag == DAMovieViewSectionMultimedia) {
        
        if ([self.movie.photos count] > 0 && indexPath.row == 0) {
            [self showPhotoGallery:nil];
        }
        else {
            int row = indexPath.row;
            if ([self.movie.photos count] > 0)
                row--;
            
            DATrailer *trailer = [self.trailersDataSource objectAtIndex:row];
            [self showTrailer:trailer];
        }
    }
    else if (tableView.tag == DAMovieViewSideComments) {
        _currentComment = self.movieView.commentsView.currentOffset + indexPath.row;
        DAComment *comment = [self.commentsDataSource objectAtIndex:_currentComment];
        _currentComment++;

        DACommentViewController *controller = [[DACommentViewController alloc]
                                               initWithComment:comment];
        controller.delegate = self;
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}



#pragma mark -
#pragma mark Private Methods.
- (void) showMailComposeViewController:(id)sender {
    [DACINeolFacade presentMailComposeViewControllerInController:self movie:self.movie];
}

- (BOOL) needsDownloadMoreComments {
    NSUInteger numberOfCommentsLoaded = [self.movie.comments count];
    NSUInteger currentOffset = self.movieView.commentsView.currentOffset + 1;
    
    BOOL needs = (currentOffset > numberOfCommentsLoaded);
    
    if (needs) {
        [[DACINeolManager sharedManager] downloadComments:self.movieView.commentsView.numberOfCommentsInCurrentPage
                                        startingInComment:currentOffset
                                                 forMovie:self.movie.CINeolID];
    }
    
    return needs;
    
}

- (void) updateToolbarArrowsItems {
    BOOL enabled = (self.movieView.commentsView.currentPage > 1);

    [[self.toolbarItems objectAtIndex:0] setEnabled:enabled];
    
    enabled = (_downloadingPageOfComments > self.movieView.commentsView.currentPage ||
               _downloadingPageOfComments == 0) &&
              (self.movieView.commentsView.currentPage < self.movieView.commentsView.numberOfPages);
    
    [[self.toolbarItems lastObject] setEnabled:enabled];
}

- (void) updateMovieView {    
    self.navigationItem.title = @"Ficha";
    
    _movieViewControllerFlags.downloadingComments = false;
    _movieViewControllerFlags.showingComments = false;
    _movieViewControllerFlags.showingPosterInFullScreenMode = false;
    _downloadingPageOfComments = 0;

    if (!_movieViewControllerFlags.movieFailToDownload) {
        if ([self.movie.trailers count] > 0 || [self.movie.photos count] > 0) {
            self.movieView.hidesMultimediaSection = NO;
        }
        else {
            self.movieView.hidesMultimediaSection = YES;
        }
        
        if (self.movie.poster.thumbnailURL != nil) {
            self.movieView.allowTouchPosterToEnterInFullScreen = YES;
            self.movieView.posterView.image = self.movie.poster.thumbnail;            
        }
        else {
            self.movieView.allowTouchPosterToEnterInFullScreen = NO;
            self.movieView.posterView.image = [UIImage imageNamed:@"DAMoviesEmptyThumbnail-small.png"];
        }

        self.movieView.title = self.movie.title;
        self.movieView.genreLabel.text = self.movie.genre;
        self.movieView.synopsisTextView.text = self.movie.synopsis;
        
        if (self.movie.duration > 0)
            self.movieView.durationLabel.text = [NSString stringWithFormat:@"%i min.", self.movie.duration];            
        else
            self.movieView.durationLabel.text = @"";

        NSString *date = self.movie.datePremierSpainText;
        if (date != nil)
            self.movieView.dateLabel.text = [@"Estreno el " stringByAppendingString:date];
        else
            self.movieView.dateLabel.text = [NSString stringWithFormat:@"%i", self.movie.year];
        
        self.movieView.rateView.rating = self.movie.rating;
        self.movieView.rateView.votes  = self.movie.numberOfVotes;    
        self.movieView.commentsView.numberOfComments = self.movie.numberOfComments;
        self.movieView.commentsView.currentPage = 1;
        
        self.trailersDataSource = nil;
        self.castDataSource = nil;    
        self.creditsDataSource = nil;
        self.commentsDataSource = nil;
        
        [self.movieView reloadSections];        
    }

    [self configureToolbarItemsAnimated:YES];
}

- (void) showTrailerErrorAlertDialog {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error abriendo el trailer"
                          message:@"Se ha producido un error mientras se intentaba reproducir un trailer."
                          delegate:nil
                          cancelButtonTitle:@"Cerrar"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void) configureToolbarToDefaultItemsAnimated:(BOOL)animated {
    UIBarButtonItem *web = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DAGoToCINeolToolbarIcon.png"]
                                                            style:UIBarButtonItemStylePlain 
                                                           target:self 
                                                           action:@selector(barButtonItemDidTouch:)];
    web.tag = TOOLBAR_BUTTON_WEB;
    web.imageInsets = UIEdgeInsetsMake(2.0, 0.0, -2.0, 0.0);
    
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DASendCINeolNewsToolbarIcon.png"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(showMailComposeViewController:)];
    send.tag = TOOLBAR_BUTTON_SEND;
    send.imageInsets = UIEdgeInsetsMake(3.0, 0.0, -3.0, 0.0);
    
    UIBarButtonItem *store = nil;
    if (!_movieViewControllerFlags.movieFailToDownload) {
        if (self.movie.buffering) {
            store = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                  target:self
                                                                  action:@selector(storeMovie:)];
        }
        else {
            store = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                  target:self
                                                                  action:@selector(deleteMovie:)];
        }
        store.tag = TOOLBAR_BUTTON_STORE;        
    } 


    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    /*
     self.ratingBarButttonItem = [[DABarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DAMyRatingToolbarIcon.png"] 
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(barButtonItemDidTouch:)];
     self.ratingBarButttonItem.tag = TOOLBAR_BUTTON_RATING;
     self.ratingBarButttonItem.selectedImage = [UIImage imageNamed:@"DAMovieInfoToolbarIcon.png"];
     self.ratingBarButttonItem.imageInsets = UIEdgeInsetsMake(2.0, 0.0, -2.0, 0.0);
     */
    
    DABarButtonItemComments *commentsBarButttonView = [[DABarButtonItemComments alloc]
                                                       initWithNumberOfComments:self.movie.numberOfComments 
                                                                         target:self 
                                                                         action:@selector(flipToCommentsSide:)];
    commentsBarButttonView.tag = TOOLBAR_BUTTON_COMMENTS;
    UIBarButtonItem *commentsBarButttonItem = [[UIBarButtonItem alloc] 
                                               initWithCustomView:commentsBarButttonView];
    
    NSArray *items = nil;
    if (store == nil) {
        items = [[NSArray alloc] initWithObjects:
                 web, space,
                 //self.ratingBarButttonItem, space, 
                 commentsBarButttonItem, space,
                 send,
                 nil];        
    }
    else {
        items = [[NSArray alloc] initWithObjects:
                 web, space,
                 //self.ratingBarButttonItem, space, 
                 commentsBarButttonItem, space,
                 send, space,
                 store,
                 nil];
    }
    
    [self setToolbarItems:items animated:animated];
    
    [commentsBarButttonView release];
    [commentsBarButttonItem release];
    //[self.ratingBarButttonItem release];
    [store release];
    [space release];
    [send release];
    [web release];
    [items release];
}

- (void) configureToolbarToCommentsItemsAnimated:(BOOL)animated {
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    UIBarButtonItem *commentsBarButttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DAMovieInfoToolbarIcon.png"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(flipToCommentsSide:)];
    commentsBarButttonItem.tag = TOOLBAR_BUTTON_COMMENTS;
    commentsBarButttonItem.imageInsets = UIEdgeInsetsMake(3.0, 0.0, -3.0, 0.0);
    
    UIBarButtonItem *leftBarButttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DAButtonBarPreviousSlide.png"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(previousPageOfComments:)];

    UIBarButtonItem *rightBarButttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DAButtonBarNextSlide.png"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(nextPageOfComments:)];
 
    leftBarButttonItem.imageInsets = UIEdgeInsetsMake(2.0, 0.0, -2.0, 0.0);    
    rightBarButttonItem.imageInsets = UIEdgeInsetsMake(2.0, 0.0, -2.0, 0.0);
    leftBarButttonItem.enabled = (self.movieView.commentsView.currentPage > 1);
    rightBarButttonItem.enabled = (self.movieView.commentsView.currentPage < self.movieView.commentsView.numberOfPages);

    NSArray *items = [[NSArray alloc] initWithObjects:
                      leftBarButttonItem, space, commentsBarButttonItem, space, rightBarButttonItem, nil];
        
    [self setToolbarItems:items animated:animated];
    
    [commentsBarButttonItem release];
    [rightBarButttonItem release];
    [leftBarButttonItem release];
    [space release];
    [items release];
}

- (void) configureToolbarToDownloadingMovieItemsAnimated:(BOOL)animated {
    
    DADownloadProgressView *view = [[DADownloadProgressView alloc] 
                                    initWithStyle:DADownloadProgressViewStyleIndeterminate];
    view.label.font = [UIFont boldSystemFontOfSize:13];
    
    // Configuramos el DADownloadProgressView.
    view.label.text = @"Descargando Película...";
    
    // Configuramos la toolbar.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:space, item, space, nil];
    [self setToolbarItems:items animated:YES];
    
    self.downloadProgressView = view;
    
    [view release];
    [items release];
    [item release];
    [space release];
}

- (void) configureToolbarItemsAnimated:(BOOL)animated {
    if (_movieViewControllerFlags.downloadingMovie) {
        [self configureToolbarToDownloadingMovieItemsAnimated:YES];
    }
    else if (_movieViewControllerFlags.showingComments) {
        [self configureToolbarToCommentsItemsAnimated:YES];
    }
    else
        [self configureToolbarToDefaultItemsAnimated:animated];
}

- (void) barButtonItemDidTouch:(id)sender {    
    NSString *title = @"";
    switch ([sender tag]) {
        case TOOLBAR_BUTTON_WEB:
            title = @"Ver ficha en Safari";
            break;

        case TOOLBAR_BUTTON_RATING:
            /*
            if ([sender isSelected]) {
                self.ratingBarButttonItem.imageInsets = UIEdgeInsetsMake(3.0, 0.0, -3.0, 0.0);
                [self.movieView flipToSide:DAMovieViewSideRating animated:YES];                
            }
            else {
                self.ratingBarButttonItem.imageInsets = UIEdgeInsetsMake(2.0, 0.0, -2.0, 0.0);
                [self.movieView flipToSide:DAMovieViewSideInfo animated:YES];
            }
            */
            NSLog(@"TODO");
            return;
            
        case TOOLBAR_BUTTON_COMMENTS:        
            return;
    }
    
    UIActionSheet *info = [[UIActionSheet alloc] initWithTitle: nil
                                                      delegate: self
                                             cancelButtonTitle: @"Cancelar"
                                        destructiveButtonTitle: title
                                             otherButtonTitles: nil];
    info.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    info.tag = [sender tag];
    [info showFromToolbar: self.navigationController.toolbar];
    [info release];
}

#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.trailersDataSource = nil;
    self.creditsDataSource = nil;
    self.castDataSource = nil;
    self.commentsDataSource = nil;
    
    if (_moviePlayerViewController.view.superview == nil)
        self.moviePlayerViewController = nil;
    
    if (_photoGalleryViewController.view.superview == nil)
        self.photoGalleryViewController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.movieView = nil;
    self.moviePlayerViewController = nil;
    self.downloadProgressView = nil;
    self.ratingBarButttonItem = nil;
    self.photoGalleryViewController = nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_movie release];                       _movie = nil;
    [_movieView release];                   _movieView = nil;
    [_moviePlayerViewController release];   _moviePlayerViewController = nil;
    [_downloadProgressView release];        _downloadProgressView = nil;
    [_queue release];                       _queue = nil;
    [_trailersDataSource release];          _trailersDataSource = nil;
    [_castDataSource release];              _castDataSource = nil;
    [_creditsDataSource release];           _creditsDataSource = nil;
    [_ratingBarButttonItem release];        _ratingBarButttonItem = nil;
    [_photoGalleryViewController release];  _photoGalleryViewController = nil;
    
    [super dealloc];
}

@end