//
//  DANewsViewController.m
//  Cineol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DANewsViewController.h"
#import "DANews.h"
#import "DAPhoto.h"
#import "DACINeolFacade.h"
#import "DACoreDataManager.h"

#import "DACINeolManager.h"
#import "DAXMLParserSingleNewsCINeol.h"

#define CINEOL_URL_BASE @"http://www.cineol.net/"

#define TOOLBAR_BUTTON_WEB  0
#define TOOLBAR_BUTTON_SEND 1

#define BUTTON_OK           0
#define BUTTON_CANCEL       1

@interface DANewsViewController ()

@property (retain, nonatomic) UIScrollView  *scrollView;
@property (retain, nonatomic) UIView        *headerView;
@property (retain, nonatomic) UILabel       *titleLabel;
@property (retain, nonatomic) DALabel       *dateLabel;
@property (retain, nonatomic) DALabel       *authorLabel;
@property (retain, nonatomic) DAImageView   *imageView;
@property (retain, nonatomic) UIButton      *imageButton;
@property (retain, nonatomic) UIWebView     *webView;
@property (retain, nonatomic) UIActivityIndicatorView *spinnerView;

@property (nonatomic, retain) NSOperationQueue *queue;

- (void) loadBody;
- (void) calculateWebViewSize;
- (void) cleanWebView;
- (void) configureToolbarItems;
- (void) updateNews;
- (void) applicationDidChangeOrientation:(NSNotification*)notification;
- (void) barButtonItemDidTouch:(id)sender;
- (void) showMailComposeViewController:(id)sender;
- (void) showImageInFullScreenMode:(id)sender;

- (void) cineolWillDownloadNews:(NSNotification*)notification;
- (void) cineolDidDownloadNews:(NSNotification*)notification;
- (void) cineolDidFailToDownloadNews:(NSNotification*)notification;

- (void) parserDidEndDocument:(id)parser;

@end


@implementation DANewsViewController

@synthesize news        = _news;
@synthesize scrollView  = _scrollView;
@synthesize headerView  = _headerView;
@synthesize titleLabel  = _titleLabel;
@synthesize dateLabel   = _dateLabel;
@synthesize authorLabel = _authorLabel;
@synthesize imageView   = _imageView;
@synthesize imageButton = _imageButton;
@synthesize webView     = _webView;
@synthesize spinnerView = _spinnerView;
@synthesize queue       = _queue;


- (id) initWithNews:(DANews*)news {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.news = news;
        self.hidesBottomBarWhenPushed = YES;
        self.queue = [[NSOperationQueue alloc] init];
        
        _newsViewControllerFlags.downloadingNews = false;

    }
    
    return self;
}

- (void) loadView {
    CGRect frame = [UIScreen mainScreen].bounds;

    self.scrollView = [[DAScrollView alloc] initWithFrame:frame];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:88.0/100.0 alpha:1.0];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    frame = CGRectMake(0.0, 0.0, 320, 100);
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.headerView.backgroundColor = [UIColor colorWithWhite:236.0/255 alpha:1.0];
    
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 4, 
                                                                  320, 4)];
    borderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DABorderPattern.png"]];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.headerView addSubview:borderView];
    [borderView release];
    
    
    self.imageView = [[DAImageView alloc] initWithFrame:CGRectMake(8.0, 10.0, 80, 80)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.activityIndicatorViewHidden = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.delegate = self;

    
    frame = self.imageView.frame;
    frame.origin.x += 2;
    frame.origin.y += 2;
    UIView *shadowView = [[UIView alloc] initWithFrame:frame];
    shadowView.backgroundColor = [UIColor grayColor];
    [self.headerView addSubview:shadowView];
    [self.headerView addSubview:self.imageView];
    [shadowView release];
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageButton.frame = self.imageView.frame;
    self.imageButton.showsTouchWhenHighlighted = YES;
    [self.imageButton addTarget:self
                         action:@selector(showImageInFullScreenMode:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.imageButton];

    /*
    frame = self.imageView.frame;
    UIImageView *pageCurlView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DAPageCurlNews.png"]];
    pageCurlView.frame = frame;
    pageCurlView.contentMode = UIViewContentModeBottomRight;
    [self.headerView addSubview:pageCurlView];
    [pageCurlView release];
    */
    
    frame = CGRectZero;
    frame.origin.x = self.imageView.frame.size.width + self.imageView.frame.origin.x + 8.0;
    frame.origin.y = self.imageView.frame.origin.y;
    frame.size.width = self.headerView.frame.size.width - frame.origin.x - 8.0;
    frame.size.height = self.imageView.frame.size.height - 20;
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.backgroundColor = self.headerView.backgroundColor;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.minimumFontSize = 12;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.titleLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
    self.titleLabel.shadowColor = [UIColor whiteColor];
    self.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    [self.headerView addSubview:self.titleLabel];

    
    frame = CGRectZero;
    frame.origin.x = self.titleLabel.frame.origin.x;
    frame.origin.y = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 2;
    frame.size.width = 70;
    frame.size.height = 20;
    self.dateLabel = [[DALabel alloc] initWithFrame:frame];
    self.dateLabel.textVerticalAlignment = DATextVerticalAlignmentBottom;
    self.dateLabel.font = [UIFont boldSystemFontOfSize:13];
    self.dateLabel.backgroundColor = self.headerView.backgroundColor;
    self.dateLabel.minimumFontSize = 10;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    
    self.dateLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.dateLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.dateLabel.shadowColor = [UIColor whiteColor];
    
    [self.headerView addSubview:self.dateLabel];
    
    
    frame = CGRectZero;
    frame.origin.x = self.dateLabel.frame.size.width + self.dateLabel.frame.origin.x;
    frame.origin.y = self.dateLabel.frame.origin.y;
    frame.size.width = self.headerView.frame.size.width - frame.origin.x - 8.0;
    frame.size.height = self.dateLabel.frame.size.height;
    self.authorLabel = [[DALabel alloc] initWithFrame:frame];
    self.authorLabel.textVerticalAlignment = DATextVerticalAlignmentBottom;
    self.authorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.authorLabel.textAlignment = UITextAlignmentRight;
    self.authorLabel.font = [UIFont boldSystemFontOfSize:13];
    self.authorLabel.backgroundColor = self.headerView.backgroundColor;
    self.authorLabel.minimumFontSize = 10;
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    
    self.authorLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.authorLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.authorLabel.shadowColor = [UIColor whiteColor];
    
    [self.headerView addSubview:self.authorLabel];
    
    
    frame = CGRectZero;
    frame.size = self.scrollView.bounds.size;
    frame.origin.y = self.headerView.frame.size.height;
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    /**
     *  HACK (Puede dejar de funcionar en futuras versiones del iOS)
     *
     *  Desactivamos el scroll del UIWebView para que al tocar la status bar
     *  se active nuestro scrollView.
     **/
    id view = [self.webView.subviews objectAtIndex:0];
    if ([view respondsToSelector:@selector(setScrollEnabled:)])
        [view setScrollEnabled:NO];
    
    
    self.spinnerView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.spinnerView sizeToFit];
    frame = self.spinnerView.frame;
    frame.size.width += 10;
    frame.size.height += 10;
    frame.origin.x = (self.scrollView.frame.size.width - frame.size.width) / 2;
    frame.origin.y = (self.scrollView.frame.size.height - frame.size.height) / 2 + 64;
    self.spinnerView.frame = frame;
    self.spinnerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|
                                        UIViewAutoresizingFlexibleTopMargin|
                                        UIViewAutoresizingFlexibleRightMargin|
                                        UIViewAutoresizingFlexibleLeftMargin;
    
    [self.scrollView addSubview:self.webView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.spinnerView];
    self.view = self.scrollView;
}

- (void) viewDidLoad {
    [super viewDidLoad];  
    
    [self configureToolbarItems];
    
    self.navigationController.toolbarHidden = NO;
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolWillDownloadNews:)
                                                 name:DACINeolWillDownloadSingleNewsNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidDownloadNews:)
                                                 name:DACINeolDidDownloadSingleNewsNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cineolDidFailToDownloadNews:)
                                                 name:DACINeolDidFailToDownloadSingleNewsNotification
                                               object:[DACINeolManager sharedManager]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidChangeOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:[UIApplication sharedApplication]];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self updateNews];
    
    if (_newsViewControllerFlags.mailComposerDidDismiss == 0)
        [self cleanWebView];
   
    _newsViewControllerFlags.mailComposerDidDismiss = 0;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([self.news needsDownloadContent]) {
        [[DACINeolManager sharedManager] newsWithID:self.news.CINeolID];
    }
    else {
        [self loadBody];
    }
    
    [FlurryAPI logEvent:DAFlurryEventShowNews withNews:self.news];
}

- (void) updateItem:(id)item {
    self.news = item;
}


#pragma mark -
#pragma mark CINeol XML Methods
- (void) cineolWillDownloadNews:(NSNotification*)notification {
    _newsViewControllerFlags.downloadingNews = true;
}

- (void) cineolDidDownloadNews:(NSNotification*)notification {
    NSUInteger ID = [[[notification userInfo] objectForKey:DACINeolNewsIDUserInfoKey] integerValue];
    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];

    DAXMLParserSingleNewsCINeol *operation = nil;
    if (ID == self.news.CINeolID) {
        operation = [[DAXMLParserSingleNewsCINeol alloc] initWithData:data
                                                             delegate:self
                                                                 news:self.news];
    }
    else {
        operation = [[DAXMLParserSingleNewsCINeol alloc] initWithData:data
                                                             delegate:self
                                                     newsWithCINeolID:ID];
    }

    [self.queue addOperation:operation];
    [operation release];    
}

- (void) cineolDidFailToDownloadNews:(NSNotification*)notification {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error durante la descarga de la noticia"
                                                        message:@"Lo sentimos, pero ha sido imposible obtener el contenido de esta noticia.\nCompruebe que se encuentre conectado a internet."
                                                       delegate:self
                                              cancelButtonTitle:@"Cerrar"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void) parserDidEndDocument:(id)parser {
    self.authorLabel.alpha = 0.0;
    self.dateLabel.alpha = 0.0;
    self.dateLabel.text = self.news.dateString;
    
    if (self.news.author != nil) {
        self.authorLabel.text = [@"Por " stringByAppendingString:self.news.author];
    }
    else {
        self.authorLabel.text = @"";
    }

    [UIView beginAnimations:nil context:NULL];
    self.authorLabel.alpha = 1.0;
    self.dateLabel.alpha = 1.0;
    [UIView commitAnimations];
    
    [self loadBody];
}


#pragma mark -
#pragma mark UIWebView Delegate Methods.
- (BOOL) webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest*)request 
  navigationType:(UIWebViewNavigationType)navigationType
{   
    return navigationType != UIWebViewNavigationTypeLinkClicked;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_newsViewControllerFlags.cleaningWebView == 1)
        return;

    [self performSelector:@selector(calculateWebViewSize) withObject:nil afterDelay:0.1];
}


#pragma mark -
#pragma mark UIAlertView Delegate Methods.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIActionSheet Delegate Methods.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == BUTTON_CANCEL)
        return;
    
    switch (actionSheet.tag) {
        case TOOLBAR_BUTTON_WEB:
            [FlurryAPI logEvent:DAFlurryEventShowNewsOnCINeol withNews:self.news];
            [DACINeolFacade openURLOnSafari:self.news.CINeolURL];
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
            [FlurryAPI logEvent:DAFlurryEventSendNewsForMail withNews:self.news];
			break;
		case MFMailComposeResultFailed:
            NSLog(@"Error.");    
			break;
		default:
            NSLog(@"No enviado.");    
			break;
	}
    
    _newsViewControllerFlags.mailComposerDidDismiss = 1;
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark DAImageView Delegate Methods.
/*
- (void) imageViewWillEnterInFullScreenMode:(DAImageView*)imageView {
}
*/

- (void) imageViewDidEnterInFullScreenMode:(DAImageView*)imageView {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;    
}

- (void) imageViewWillExitOfFullScreenMode:(DAImageView*)imageView {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO; 
}

- (void) imageViewDidExitOfFullScreenMode:(DAImageView*)imageView {
    [self.headerView bringSubviewToFront:self.imageButton];
}

#pragma mark -
#pragma mark Private Methods
- (void) updateNews {
    _newsViewControllerFlags.downloadingNews = false;

    self.titleLabel.text = self.news.title;
    self.dateLabel.text = self.news.dateString;
    
    if (self.news.photo.photoURL != nil) {
        self.imageView.image = self.news.photo.photo;
        self.imageButton.hidden = NO;
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"DANewsEmptyThumb-big.png"];
        self.imageButton.hidden = YES;
    }
    
    if (self.news.author != nil)
        self.authorLabel.text = [@"Por " stringByAppendingString:self.news.author];
    else
        self.authorLabel.text = @"";    
}


- (void) cleanWebView {
    self.scrollView.scrollEnabled = NO;
    self.webView.alpha = 0.0;
    [self.spinnerView startAnimating];
    self.webView.frame = self.scrollView.frame;
    [self.scrollView scrollRectToVisible:CGRectMake(0.0, 0.0, 1, 1) animated:NO];
    _newsViewControllerFlags.cleaningWebView = 1;
    [self.webView loadHTMLString:@"" baseURL:nil];
}

- (void) loadBody {    
    NSString *content = self.news.body;
    if (content == nil || [content length] < [self.news.introduction length])
        content = self.news.introduction;
        
    NSString *path = [[NSBundle mainBundle] pathForResource:@"news-template" ofType:@"html"];    
    NSString *HTML = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    HTML = [NSString stringWithFormat:HTML, content];
    _newsViewControllerFlags.cleaningWebView = 0;
    [self.webView loadHTMLString:HTML baseURL:[NSURL URLWithString:CINEOL_URL_BASE]];
}

- (void) calculateWebViewSize {
    [self.webView sizeToFit];
    
    CGRect frame = CGRectZero;
    frame.origin.y = self.headerView.frame.size.height;
    frame.size.height = self.webView.frame.size.height;
    frame.size.width  = self.scrollView.frame.size.width;

    self.webView.frame = frame;
    
    frame.size.height += self.headerView.frame.size.height;
    self.scrollView.contentSize = frame.size; 
        
    [self.spinnerView stopAnimating];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    self.webView.alpha = 1.0;
    [UIView commitAnimations];
    [self.scrollView flashScrollIndicators];
    
    self.scrollView.scrollEnabled = YES;
}

- (void) applicationDidChangeOrientation:(NSNotification*)notification {    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        self.webView.frame = CGRectMake(0.0, 0.0, 480, 300);
    else
        self.webView.frame = CGRectMake(0.0, 0.0, 320, 460);
     
    [self loadBody];
}

- (void) barButtonItemDidTouch:(id)sender {
    
    NSString *title = @"";
    switch ([sender tag]) {
        case TOOLBAR_BUTTON_WEB:
            title = @"Ver noticia en Safari";
            break;
        case TOOLBAR_BUTTON_SEND:
            title = @"Enviar noticia por email";
            break;
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

- (void) showMailComposeViewController:(id)sender {
    [DACINeolFacade presentMailComposeViewControllerInController:self news:self.news];
}


- (void) configureToolbarItems {
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

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    NSArray *items = [[NSArray alloc] initWithObjects:web, space, send, nil];
    self.toolbarItems = items;
    
    [space release];
    [send release];
    [web release];
    [items release];    
}

- (void) showImageInFullScreenMode:(id)sender {
    [self.imageView setInFullScreenModeAnimated:YES];
}

#pragma mark -
#pragma mark Memory Management
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void) viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.headerView = nil;
    self.scrollView = nil;
    self.titleLabel = nil;
    self.dateLabel = nil;
    self.authorLabel = nil;
    self.imageView  = nil;
    self.webView = nil;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_news release];                _news = nil;
    [_scrollView release];          _scrollView = nil;
    [_titleLabel release];          _titleLabel = nil;
    [_imageView release];           _imageView = nil;
    [_headerView release];          _headerView = nil;
    [_webView release];             _webView = nil;
    [_dateLabel release];           _dateLabel = nil;
    [_authorLabel release];         _authorLabel = nil;
    [_queue release];               _queue = nil;
    
    [super dealloc];
}

@end