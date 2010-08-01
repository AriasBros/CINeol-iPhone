//
//  DANewsViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DANewsListViewController.h"
#import "DANewsViewController.h"
#import "DACINeolManager.h"
#import "DACINeolFacade.h"
#import "DACINeolUserDefaults.h"
#import "DAXMLParserNewsCINeol.h"
#import "DACINeolKeys.h"
#import "DANews.h"
#import "DAPhoto.h"
#import "DATableViewCellNews.h"

#import "DADeleteNewsOperation.h"

#define NUMBER_OF_NEWS 10

#define TOOLBAR_BUTTON_WEB  0
#define TOOLBAR_BUTTON_SEND 1

#define BUTTON_OK           0
#define BUTTON_CANCEL       1

@interface DANewsListViewController ()

@property (nonatomic, retain) DANewsViewController *newsViewController;
@property (nonatomic, retain) NSArray *cellItems;
@property (nonatomic, retain) id temp;

- (void) cineolDidChangeNumberOfNews:(NSNotification*)notification;
- (void) cineolWillDownloadNews:(NSNotification*)notification;
- (void) cineolDidDownloadNews:(NSNotification*)notification;
- (void) cineolDidFailToDownloadNews:(NSNotification*)notification;
- (void) parserDidEndDocument:(id)parser;
- (void) parser:(DAXMLParser*)parser didEndElement:(NSString*)key;

- (void) deleteNewsWithoutUse;
- (void) showMailComposeViewControllerWithNews:(DANews*)news;

@end


@implementation DANewsListViewController

@synthesize newsViewController = _newsViewController;
@synthesize cellItems = _cellItems;
@synthesize temp = _temp;

- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Noticias";
        _CINeolObjectsViewControllerFlags.shouldReloadData = true;
    }
    
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
            
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidChangeNumberOfNews:)
                                                 name:DACINeolUserDefaultsDidChangeNumberOfNewsNotification
                                               object:nil];    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolWillDownloadNews:)
                                                 name:DACINeolWillDownloadNewsNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidDownloadNews:)
                                                 name:DACINeolDidDownloadNewsNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidFailToDownloadNews:)
                                                 name:DACINeolDidFailToDownloadNewsNotification
                                               object:[DACINeolManager sharedManager]];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _limitOfObjectsInList = [DACINeolUserDefaults numberOfNewsInNewsSection];

    [self.navigationController setToolbarHidden:YES animated:animated];

    if (_CINeolObjectsViewControllerFlags.shouldReloadData) {
        [[DACINeolManager sharedManager] news:NUMBER_OF_NEWS];
        _CINeolObjectsViewControllerFlags.shouldReloadData = false;
    }
}


- (DANewsViewController*) newsViewController {
    if (_newsViewController == nil) {
        self.newsViewController = [[DANewsViewController alloc] initWithNews:nil];
        self.newsViewController.delegate = self;
    }
    
    return _newsViewController;
}


#pragma mark -
#pragma mark CINeol XML Methods
- (void) cineolWillDownloadNews:(NSNotification*)notification {
    [super showDownloadProgressView:nil];
    self.panel.titleLabel.text = @"Cargando Noticias...";
    self.downloadProgressView.label.text = @"Comprobando si hay noticias nuevas";
}

- (void) cineolDidDownloadNews:(NSNotification*)notification {
    self.downloadProgressView.label.text = [NSString stringWithFormat:
                                            @"Descargando Noticias: 1/%i", NUMBER_OF_NEWS];    
    [self.downloadProgressView setStyle:DADownloadProgressViewStyleDeterminate animated:YES];

    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];
    
    DAXMLParserNewsCINeol *parser = [[DAXMLParserNewsCINeol alloc] 
                                     initWithData:data delegate:self];
    [self.queue addOperation:parser];
    [parser release];
}

- (void) cineolDidFailToDownloadNews:(NSNotification*)notification {
    [super showNoInternetConectionPanel:nil];
    [super hideDownloadProgressView:nil];
}

- (void) parserDidEndDocument:(id)parser {
    self.panel.titleLabel.text = @"Noticias Cargadas";
    [super hideDownloadProgressView:nil];
    
    [self deleteNewsWithoutUse];    
}

- (void) parser:(DAXMLParser*)parser didEndElement:(NSString*)key {
    static float count = 1;

    if ([key isEqualToString:kNewsKey]) {
        self.downloadProgressView.progressView.progress = count / NUMBER_OF_NEWS;
        
        self.downloadProgressView.label.text = [NSString stringWithFormat:
                                                @"Descargando Noticias: %i/%i",
                                                (int)count, NUMBER_OF_NEWS]; 
        if (count == NUMBER_OF_NEWS) {
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
        self.fetchedResultsController = [DACINeolFacade fetchedResultsForNewsInBuffer];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void) configureTabBarItem {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Noticias"
                                                       image:[UIImage imageNamed:@"DANewsTabBarIcon.png"]
                                                         tag:kNewsViewControllerTag];
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
#pragma mark Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DATableViewCellNews";
    
    DATableViewCellNews *cell = (DATableViewCellNews*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DATableViewCellNews alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.allowLongTouch = YES;
    }
    
    DANews *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = news.title;
    cell.detailTextLabel.text = news.introduction;
    
    if (!news.photo.photoURL) {
        cell.imageView.image = [UIImage imageNamed:@"DANewsEmptyThumb-small.png"];
    }
    else {
        cell.imageView.image = news.photo.photo;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.fetchedResultsController.fetchedObjects count] <= 0)
        return 44;
        
    DANews *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGFloat height = 0;
    
    CGSize constrain = [DATableViewCellNews constrainSizeForLabels];
    CGSize size = CGSizeZero;
    
    size = [news.title sizeWithFont:[DATableViewCellNews fontForTextLabel] 
                  constrainedToSize:constrain];
    height += size.height;
    
    size = [news.introduction sizeWithFont:[DATableViewCellNews fontForDetailTextLabel]
                         constrainedToSize:constrain];
    height += size.height;

    height += 20;
    
    return MAX(height, [DATableViewCellNews heightForImageView]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    _newsListViewController.currentSelectedNews = indexPath.row + 1;
    
    DANews *news = [self.fetchedResultsController objectAtIndexPath:indexPath];        
    self.newsViewController.news = news;
    [self.navigationController pushViewController:self.newsViewController animated:YES];
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
    DANews *news = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *title = @"";
    switch (item.tag) {
        case TOOLBAR_BUTTON_WEB:
            self.temp = news.CINeolURL;
            title = @"Ver noticia en Safari";
            UIActionSheet *info = [[UIActionSheet alloc] initWithTitle: news.title
                                                              delegate: self
                                                     cancelButtonTitle: @"Cancelar"
                                                destructiveButtonTitle: title
                                                     otherButtonTitles: nil];
            info.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            info.tag = item.tag;
            [info showFromTabBar: self.tabBarController.tabBar];
            [info release];
            
            return YES;
            
        case TOOLBAR_BUTTON_SEND:
            [self showMailComposeViewControllerWithNews:news];
            
            return YES;
    }
    
    return YES;
}


#pragma mark -
#pragma mark DAPAgeViewController Delegate Methods.
- (NSInteger) numberOfPagesInPageViewController:(DAPageViewController*)controller {
    return [self.fetchedResultsController.fetchedObjects count];
}

- (NSInteger) currentPageInPageViewController:(DAPageViewController*)controller {
    return _newsListViewController.currentSelectedNews;
}

- (id) pageViewController:(DAPageViewController*)controller itemOnPage:(NSInteger)index {
    _newsListViewController.currentSelectedNews = index;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate Methods.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error 
{	
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
    
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == BUTTON_CANCEL)
        return;
    
    switch (actionSheet.tag) {
        case TOOLBAR_BUTTON_WEB:
            [DACINeolFacade openURLOnSafari:self.temp];
            self.temp = nil;
            break;
            
        case TOOLBAR_BUTTON_SEND:
            break;
    }
}


#pragma mark -
#pragma mark Private Methods.
- (void) cineolDidChangeNumberOfNews:(NSNotification*)notification {
    _CINeolObjectsViewControllerFlags.shouldReloadData = true;
    
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void) deleteNewsWithoutUse {
    NSUInteger maxNumberOfNews = [DACINeolUserDefaults numberOfNewsInNewsSection];
    NSUInteger currentNumberOfNews = [[self.fetchedResultsController fetchedObjects] count];
    
    if (currentNumberOfNews > maxNumberOfNews) {
        NSUInteger numberOfNewsToDelete = currentNumberOfNews - maxNumberOfNews;
                
        DADeleteNewsOperation *operation = [[DADeleteNewsOperation alloc]
                                            initWithNumberOfNewsToDelete:numberOfNewsToDelete];
        [self.queue addOperation:operation];
        [operation release];
    }
}

- (void) showMailComposeViewControllerWithNews:(DANews*)news {
    [DACINeolFacade presentMailComposeViewControllerInController:self news:news];
}


/*
#pragma mark -
#pragma mark NSFetchedResultsController Delegate Methods.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [super controllerDidChangeContent:controller];    
    
    if ([[self.fetchedResultsController fetchedObjects] count] > _limitOfObjectsInList)
    {
        while ([[self.fetchedResultsController fetchedObjects] count] > _limitOfObjectsInList)
        {
            DANews *news = [[self.fetchedResultsController fetchedObjects] lastObject];
            
            if (news.buffering)
                [DACINeolFacade deleteObject:news];
        }
    }
}
*/


#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
    
    if (_newsViewController.view.superview == nil)
        self.newsViewController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [_newsViewController release];  _newsViewController = nil;
    [_cellItems release];           _cellItems = nil;
    [_temp release];                _temp = nil;
    
    [super dealloc];
}

@end