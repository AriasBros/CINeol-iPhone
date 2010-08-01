//
//  DAMovieView.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAMovieView.h"
#import "DAMovieRatingView.h"
#import "DAMovieCommentsView.h"

#define RADIUS 8.0
#define SPINNER_OVERLAY_TAG 100

@interface DAMovieView ()

@property (nonatomic, retain) UIView                *infoView;
@property (nonatomic, retain) DAMovieRatingView     *ratingView;
@property (nonatomic, retain) DAMovieCommentsView   *commentsView;

@property (nonatomic, retain) UIView        *headerView;
@property (nonatomic, retain) DARatingView  *rateView;
@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UILabel       *genreLabel;
@property (nonatomic, retain) UILabel       *dateLabel;
@property (nonatomic, retain) UILabel       *durationLabel;
@property (nonatomic, retain) DAImageView   *posterView;
@property (nonatomic, retain) UIButton      *posterButton;

@property (nonatomic, retain) UITextView    *synopsisTextView;
@property (nonatomic, retain) UILabel       *synopsisLabel;
@property (nonatomic, retain) UIScrollView  *synopsisView;

@property (nonatomic, retain) DATableView   *detailsView;
@property (nonatomic, retain) DATableView   *multimediaView;
@property (nonatomic, retain) DATableView   *castView;
@property (nonatomic, retain) DATableView   *creditsView;

@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIScrollView  *pagesView;

- (void) addObservers;
- (void) removeObservers;

- (void) initHeaderView;
- (void) initPagesView;
- (void) initSynopsisView;
- (void) initSectionViews;

- (void) resizePagesView;
- (void) repositionateView:(UIView*)view;
- (void) pageControlDidChangeSection:(id)sender;
- (void) flipAnimationDidStop:(NSString*)animationID;
- (void) flipAnimationWillStart:(NSString*)animationID;
- (void) applicationWillChangeOrientation:(NSNotification*)notification;
- (void) applicationDidChangeOrientation:(NSNotification*)notification;

@end


@implementation DAMovieView

@dynamic title;

@dynamic delegate;
@dynamic dataSource;

@dynamic allowTouchPosterToEnterInFullScreen;
@dynamic hidesMultimediaSection;
@dynamic currentSide;

@synthesize infoView        = _infoView;
@synthesize ratingView      = _ratingView;
@synthesize commentsView    = _commentsView;
@synthesize headerView      = _headerView;

@synthesize rateView        = _rateView;
@synthesize titleLabel      = _titleLabel;
@synthesize genreLabel      = _genreLabel;
@synthesize dateLabel       = _dateLabel;
@synthesize durationLabel   = _durationLabel;
@synthesize posterView      = _posterView;
@synthesize posterButton    = _posterButton;

@synthesize synopsisTextView = _synopsisTextView;
@synthesize synopsisLabel    = _synopsisLabel;
@synthesize synopsisView     = _synopsisView;

@synthesize detailsView     = _detailsView;
@synthesize multimediaView  = _multimediaView;
@synthesize castView        = _castView;
@synthesize creditsView     = _creditsView;

@synthesize pageControl = _pageControl;
@synthesize pagesView   = _pagesView;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
    
        _movieViewFlags.allowTouchPosterToEnterInFullScreen = true;
        _movieViewFlags.currentSide = DAMovieViewSideInfo;
        _movieViewFlags.usingPageControl = 0;
        _movieViewFlags.resizingSynopsisTextView = 0;
        _movieViewFlags.hidesMultimediaSection = 0;
        
        self.infoView       = [[UIView alloc] initWithFrame:self.bounds];
        self.ratingView     = [[DAMovieRatingView alloc] initWithFrame:self.bounds];
        self.commentsView   = [[DAMovieCommentsView alloc] initWithFrame:self.bounds];
        
        self.commentsView.tableView.tag = DAMovieViewSideComments;
    
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                UIViewAutoresizingFlexibleHeight;
        
        self.infoView.autoresizingMask = self.autoresizingMask;
        self.ratingView.autoresizingMask = self.autoresizingMask;
        self.commentsView.autoresizingMask = self.autoresizingMask;        
        
        self.infoView.clipsToBounds = YES;
        self.ratingView.clipsToBounds  = YES;
        self.commentsView.clipsToBounds  = YES;
        
        self.infoView.backgroundColor = [UIColor whiteColor];
        self.ratingView.backgroundColor = [UIColor colorWithWhite:236.0/255 alpha:1.0];
        self.commentsView.backgroundColor = [UIColor whiteColor];
        
        /*
        #if __IPHONE_OS_VERSION_MIN_REQUIRED > 30000
        if ([UIDevice currentDevice].multitaskingSupported) {
            self.layer.cornerRadius = RADIUS;
            self.infoView.layer.cornerRadius = RADIUS;
            self.ratingView.layer.cornerRadius = RADIUS;
            self.commentsView.layer.cornerRadius = RADIUS;
            
            self.layer.shadowOffset   = CGSizeMake(0.0, 2.0);
            self.layer.shadowColor    = [[UIColor blackColor] CGColor];
            self.layer.shadowOpacity  = 0.8;
            self.layer.shadowRadius   = 2.0;
        }
        #endif
        */

        [self addSubview:self.commentsView];
        [self addSubview:self.ratingView];
        [self addSubview:self.infoView];
        
        [self initHeaderView];
        [self initPagesView];
        [self initSynopsisView];
        [self initSectionViews];
        
        [self addObservers];
    }

    return self;
}

- (void) setAutoresizingMask:(UIViewAutoresizing)autoresizingMask {
    [super setAutoresizingMask:autoresizingMask];
    self.infoView.autoresizingMask = autoresizingMask;
    self.ratingView.autoresizingMask = autoresizingMask;
}

- (void) flashScrollIndicatorsOfSynopsisView {
    [self.synopsisView flashScrollIndicators];
}

- (void) flipToSide:(DAMovieViewSide)side animated:(BOOL)animated { 
    if (_movieViewFlags.currentSide == side)
        animated = NO;
        
    if (animated) {
        
        if (_movieViewFlags.currentSide == DAMovieViewSideInfo &&
            (side == DAMovieViewSideRating || side == DAMovieViewSideComments))
            _movieViewFlags.lastFlipTransitionAnimation = UIViewAnimationTransitionFlipFromRight;
        
        else if (_movieViewFlags.currentSide != DAMovieViewSideInfo && 
                 side == DAMovieViewSideInfo)
            _movieViewFlags.lastFlipTransitionAnimation = UIViewAnimationTransitionFlipFromLeft;
        
        else if (_movieViewFlags.lastFlipTransitionAnimation == UIViewAnimationTransitionFlipFromRight)
            _movieViewFlags.lastFlipTransitionAnimation = UIViewAnimationTransitionFlipFromLeft;
        else
            _movieViewFlags.lastFlipTransitionAnimation = UIViewAnimationTransitionFlipFromRight;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationWillStartSelector:@selector(flipAnimationWillStart:)];
        [UIView setAnimationDidStopSelector:@selector(flipAnimationDidStop:)];
        [UIView setAnimationTransition:_movieViewFlags.lastFlipTransitionAnimation
                               forView:self
                                 cache:YES];
    }
    
    switch (side) {
        case DAMovieViewSideInfo:
            self.ratingView.hidden = YES;
            self.commentsView.hidden = YES;
            self.infoView.hidden = NO;
            break;
            
        case DAMovieViewSideRating:
            self.ratingView.hidden = NO;
            self.commentsView.hidden = YES;
            self.infoView.hidden = YES;
            break;
            
        case DAMovieViewSideComments:
            self.ratingView.hidden = YES;
            self.commentsView.hidden = NO;
            self.infoView.hidden = YES;
            break;
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    _movieViewFlags.currentSide = side;
}

- (void) setCurrentSide:(DAMovieViewSide)side {
    [self flipToSide:side animated:NO];
}

- (DAMovieViewSide) currentSide {
    return _movieViewFlags.currentSide;
}

- (void) scrollToSection:(DAMovieViewSection)section animated:(BOOL)animated {
    CGRect visibleRect = self.pagesView.frame;
    visibleRect.origin.y = 0.0;
    visibleRect.origin.x = visibleRect.size.width * section;
    [self.pagesView scrollRectToVisible:visibleRect animated:animated];
        
    self.pageControl.currentPage = section;
}

- (void) reloadSections {
    [self.detailsView reloadData];
    [self.multimediaView reloadData];
    [self.castView reloadData];
    [self.creditsView reloadData];
}

- (id<DAMovieViewDelegate>) delegate {
    return _delegate;
}

- (id<UITableViewDataSource>) dataSource {
    return self.detailsView.dataSource;
}

- (void) setDelegate:(id <DAMovieViewDelegate>)delegate {
    _delegate = delegate;
    
    self.detailsView.delegate = delegate;
    self.multimediaView.delegate = delegate;
    self.castView.delegate = delegate;
    self.creditsView.delegate = delegate;
    self.commentsView.tableView.delegate = delegate;
    
    if ([delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        ((UITableView*)self.commentsView.tableView.tableFooterView).rowHeight =
        [delegate tableView:self.commentsView.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 
                                                                                                   inSection:0]];
}

- (void) setDataSource:(id <UITableViewDataSource>)dataSource {
    self.detailsView.dataSource = dataSource;
    self.multimediaView.dataSource = dataSource;
    self.castView.dataSource = dataSource;
    self.creditsView.dataSource = dataSource;
    self.commentsView.tableView.dataSource = dataSource;
}

- (BOOL) hidesMultimediaSection {
    return _movieViewFlags.hidesMultimediaSection;
}

- (void) setHidesMultimediaSection:(BOOL)hides {
    
    _movieViewFlags.hidesMultimediaSection = hides;
    
    if (hides) {
        [self.multimediaView removeFromSuperview];
        self.pageControl.numberOfPages = 4;
    }
    else {
        [self.pagesView addSubview:self.multimediaView];
        self.pageControl.numberOfPages = 5;
    }
    
    [self resizePagesView];
}


#pragma mark -
#pragma mark Properties.
- (BOOL) allowTouchPosterToEnterInFullScreen {
    return _movieViewFlags.allowTouchPosterToEnterInFullScreen;
}

- (void) setAllowTouchPosterToEnterInFullScreen:(BOOL)allow {
    _movieViewFlags.allowTouchPosterToEnterInFullScreen = allow;
    self.posterButton.enabled = allow;
}

- (void) setTitle:(NSString *)title {
    if (title == self.title)
        return;
    
    self.titleLabel.text = title;
    self.commentsView.title = title;
}

- (NSString*) title {
    return self.titleLabel.text;
}

- (void) setNumberOfComments:(NSUInteger)numberOfComments {
    self.commentsView.numberOfComments = numberOfComments;
}

- (NSUInteger) numberOfComments {
    return self.commentsView.numberOfComments;
}

#pragma mark -
#pragma mark KVO Methods.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change 
                       context:(void *)context
{    
    if (object == self.synopsisTextView && 
        [keyPath isEqualToString:@"contentSize"] &&  
        _movieViewFlags.resizingSynopsisTextView == 0)
    {        
        _movieViewFlags.resizingSynopsisTextView = 1;
        
        CGRect frame = self.synopsisTextView.frame;
        frame.origin.y = self.synopsisLabel.frame.size.height + self.synopsisLabel.frame.origin.y - 8.0;    
        frame.size.height = self.synopsisTextView.contentSize.height;
        
        self.synopsisTextView.frame = frame;
        self.synopsisView.contentSize = CGSizeMake(self.synopsisView.frame.size.width,
                                                   self.synopsisTextView.contentSize.height +
                                                   self.synopsisLabel.frame.size.height);
        _movieViewFlags.resizingSynopsisTextView = 0;
    }
    else if (object == self.synopsisTextView && 
             [keyPath isEqualToString:@"text"])
    { 
        [self.synopsisView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:NO];
    }
    else if (object == self.pageControl &&
             [keyPath isEqualToString:@"numberOfPages"])
    {
        [self resizePagesView];
    }
    else if (object == self.posterView &&
             [self.posterView isInFullScreenMode] &&
             [keyPath isEqualToString:@"image"] &&
             [self.delegate respondsToSelector:@selector(movieViewIsPosterLoaded:)])
    {
        if ([self.delegate movieViewIsPosterLoaded:self])
            self.posterView.activityIndicatorViewHidden = YES;
    }
}

#pragma mark -
#pragma mark UIScrollView Delegate Methods.
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (_movieViewFlags.usingPageControl == 1 || _movieViewFlags.changingOrientation == 1)
        return;
    
    // Movemos el pageControl si mas del 50% de la pagina anterior o siguiente es visible.
    CGFloat w = self.pagesView.frame.size.width;
    self.pageControl.currentPage = floor((self.pagesView.contentOffset.x - w / 2) / w) + 1;    
}

- (void) scrollViewDidEndScrollingAnimation: (UIScrollView*) scrollView {
    _movieViewFlags.usingPageControl = 0;
}


#pragma mark -
#pragma mark DAImageView Delegate Methods.
- (BOOL) imageViewShouldEnterInFullScreenMode:(DAImageView*)imageView {
    
    if ([self.delegate respondsToSelector:@selector(movieView:posterViewShouldEnterInFullScreenMode:)])
    {
        return [self.delegate movieView:self posterViewShouldEnterInFullScreenMode:self.posterView];
    }
    
    return YES;
}

/*
- (BOOL) imageViewShouldExitOfFullScreenMode:(DAImageView*)imageView {
    if ([self.delegate respondsToSelector:@selector(movieView:posterViewShouldExitOfFullScreenMode:)])
    {
        return [self.delegate movieView:self posterViewShouldExitOfFullScreenMode:self.posterView];
    }
    
    return YES;
}
*/

- (void) imageViewWillEnterInFullScreenMode:(DAImageView*)imageView {
    self.posterView.activityIndicatorViewHidden = NO;

    if ([self.delegate respondsToSelector:
         @selector(movieView:posterViewWillEnterInFullScreenMode:)])
    {
        [self.delegate movieView:self posterViewWillEnterInFullScreenMode:self.posterView];
    }
    
    if ([self.delegate respondsToSelector:@selector(movieViewIsPosterLoaded:)] &&
        [self.delegate movieViewIsPosterLoaded:self])
    {
        self.posterView.activityIndicatorViewHidden = YES;
    }
}

- (void) imageViewDidEnterInFullScreenMode:(DAImageView*)imageView {   
    if ([self.delegate respondsToSelector:
         @selector(movieView:posterViewDidEnterInFullScreenMode:)])
    {
        [self.delegate movieView:self posterViewDidEnterInFullScreenMode:self.posterView];
    }
}

- (void) imageViewWillExitOfFullScreenMode:(DAImageView*)imageView {
    if ([self.delegate respondsToSelector:
         @selector(movieView:posterViewWillExitOfFullScreenMode:)])
    {
        [self.delegate movieView:self posterViewWillExitOfFullScreenMode:self.posterView];
    }
}

- (void) imageViewDidExitOfFullScreenMode:(DAImageView*)imageView {
    [self.headerView bringSubviewToFront:self.posterButton];
    
    if ([self.delegate respondsToSelector:
         @selector(movieView:posterViewDidExitOfFullScreenMode:)])
    {
        [self.delegate movieView:self posterViewDidExitOfFullScreenMode:self.posterView];
    }
}


#pragma mark -
#pragma mark Private Methods.
- (void) showPosterInFullScreenMode:(id)sender {
    [self.posterView setInFullScreenModeAnimated:YES];
}

- (void) flipAnimationWillStart:(NSString*)animationID {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void) flipAnimationDidStop:(NSString*)animationID {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if (_movieViewFlags.currentSide == DAMovieViewSideComments)
        [self.commentsView.tableView flashScrollIndicators];
}

- (void) pageControlDidChangeSection:(id)sender {
    _movieViewFlags.usingPageControl = 1;
    [self scrollToSection:self.pageControl.currentPage animated:YES];
}

- (void) repositionateView:(UIView*)view {
    int offset = view.tag;
    if (_movieViewFlags.hidesMultimediaSection == 1 && offset > DAMovieViewSectionMultimedia)
        offset--;
    
    CGRect frame = self.synopsisView.frame;
    frame.origin.x = frame.size.width * offset;
    view.frame = frame;
}

- (void) resizePagesView {
    CGRect frame = self.infoView.bounds;
    frame.size.width *= self.pageControl.numberOfPages;
    frame.size.height = 50;
    
    self.pagesView.contentSize = frame.size;
    
    [self repositionateView:self.detailsView];
    [self repositionateView:self.multimediaView];
    [self repositionateView:self.castView];
    [self repositionateView:self.creditsView];
    
    [self.pagesView bringSubviewToFront:self.detailsView];
    [self.pagesView bringSubviewToFront:self.multimediaView];
    [self.pagesView bringSubviewToFront:self.castView];
    [self.pagesView bringSubviewToFront:self.creditsView];
}

- (void) applicationWillChangeOrientation:(NSNotification*)notification {
    _movieViewFlags.changingOrientation = 1;
}

- (void) applicationDidChangeOrientation:(NSNotification*)notification {
    [self resizePagesView];    
    [self scrollToSection:self.pageControl.currentPage animated:NO];
    _movieViewFlags.changingOrientation = 0;
}


- (void) initHeaderView {
    CGRect frame = self.bounds;
    
    frame.size.height = 115;
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.headerView.backgroundColor = [UIColor colorWithWhite:236.0/255 alpha:1.0];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 1, 
                                                                  frame.size.width, 1)];
    borderView.backgroundColor = [UIColor colorWithWhite:150.0/255 alpha:1.0];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.headerView addSubview:borderView];
    [borderView release];
    
    borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 2, 
                                                                  frame.size.width, 1)];
    borderView.backgroundColor = [UIColor colorWithWhite:210.0/255 alpha:1.0];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.headerView addSubview:borderView];
    [borderView release];
    
    borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 1.0)];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    borderView.backgroundColor = [UIColor colorWithRed:245.0/255 green:250.0/255 blue:246.0/255 alpha:1.0];
    [self.headerView addSubview:borderView];
    [borderView release];
    
    
    frame = CGRectMake(8.0, 8.0, 60, 90);
    self.posterView = [[DAImageView alloc] initWithFrame:frame];
    self.posterView.contentMode = UIViewContentModeScaleAspectFill;
    self.posterView.clipsToBounds = YES;
    self.posterView.autoresizingMask = UIViewAutoresizingNone;
    self.posterView.delegate = self;
    
    frame.origin.x += 2;
    frame.origin.y += 2;
    UIView *shadowView = [[UIView alloc] initWithFrame:frame];
    shadowView.backgroundColor = [UIColor grayColor];
    [self.headerView addSubview:shadowView];
    [shadowView release];
    
    self.posterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.posterButton.frame = self.posterView.frame;
    self.posterButton.showsTouchWhenHighlighted = YES;
    [self.posterButton addTarget:self 
                          action:@selector(showPosterInFullScreenMode:) 
                forControlEvents:UIControlEventTouchUpInside];
    
    
    frame = self.posterView.frame;
    frame.origin.x += frame.size.width + 8.0;
    frame.size.width = self.headerView.frame.size.width - frame.origin.x - 8.0;
    frame.size.height = [UIFont boldSystemFontOfSize:16].leading * 2;
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.minimumFontSize = 12;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.backgroundColor = self.headerView.backgroundColor;
    self.titleLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
    self.titleLabel.shadowColor = [UIColor whiteColor];
    self.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);    
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    

    frame.origin.y = self.posterView.frame.size.height + self.posterView.frame.origin.y - 15;
    frame.size.height = 18;
    self.dateLabel = [[UILabel alloc] initWithFrame:frame];
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    self.dateLabel.minimumFontSize = 10;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.dateLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.dateLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.dateLabel.shadowColor = [UIColor whiteColor];
    self.dateLabel.backgroundColor = self.headerView.backgroundColor;
    self.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    frame.origin.y -= frame.size.height;
    frame.size.width = 50;
    self.durationLabel = [[UILabel alloc] initWithFrame:frame];
    self.durationLabel.font = [UIFont systemFontOfSize:13];
    self.durationLabel.minimumFontSize = 10;
    self.durationLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.durationLabel.adjustsFontSizeToFitWidth = YES;
    self.durationLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.durationLabel.shadowColor = [UIColor whiteColor];
    self.durationLabel.backgroundColor = self.headerView.backgroundColor;
    
    
    frame.origin.x = self.durationLabel.frame.size.width + self.durationLabel.frame.origin.x + 4.0;
    frame.size.width = self.titleLabel.frame.size.width - self.durationLabel.frame.size.width;
    self.genreLabel = [[UILabel alloc] initWithFrame:frame];
    self.genreLabel.font = [UIFont systemFontOfSize:13];
    self.genreLabel.minimumFontSize = 10;
    self.genreLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.genreLabel.adjustsFontSizeToFitWidth = YES;
    self.genreLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.genreLabel.shadowColor = [UIColor whiteColor];
    self.genreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.genreLabel.backgroundColor = self.headerView.backgroundColor;
    
    
    self.rateView = [[DARatingView alloc] initWithStyle:DARatingViewStyleColorSmall];
    frame = self.rateView.frame;
    frame.origin.y = self.durationLabel.frame.origin.y - frame.size.height - 1.0;
    frame.origin.x = self.titleLabel.frame.origin.x;
    self.rateView.frame = frame;
    self.rateView.allowRating = NO;
    self.rateView.label.font = [UIFont systemFontOfSize:13];
    self.rateView.label.minimumFontSize = 10;
    self.rateView.label.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.rateView.label.adjustsFontSizeToFitWidth = YES;
    self.rateView.label.shadowOffset = CGSizeMake(1.0, 1.0);
    self.rateView.label.shadowColor = [UIColor whiteColor];
    self.rateView.label.backgroundColor = self.headerView.backgroundColor;
    self.rateView.backgroundColor = self.headerView.backgroundColor;

    
    frame = CGRectZero;
    frame.size.height = 10;
    frame.origin.y = self.posterView.frame.size.height + self.posterView.frame.origin.y + 3.0;
    frame.size.width = self.headerView.frame.size.width;
    self.pageControl = [[UIPageControl alloc] initWithFrame:frame];
    self.pageControl.numberOfPages = 1;
    self.pageControl.hidesForSinglePage = NO;
    [self.pageControl addTarget:self 
                         action:@selector(pageControlDidChangeSection:) 
               forControlEvents:UIControlEventValueChanged];

    
    [self.headerView addSubview:self.pageControl];
    [self.headerView addSubview:self.rateView];
    [self.headerView addSubview:self.genreLabel];
    [self.headerView addSubview:self.durationLabel];
    [self.headerView addSubview:self.dateLabel];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.posterView];
    [self.headerView addSubview:self.posterButton];
    [self.infoView addSubview:self.headerView];
    
    
    frame = CGRectMake(0.0, self.headerView.bounds.size.height - 2 - 20, self.headerView.bounds.size.width, 20);
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:frame];
    shadow.image = [[UIImage imageNamed:@"cell-shadow-pattern.png"]
                    stretchableImageWithLeftCapWidth:2
                    topCapHeight:0];
    shadow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.headerView addSubview:shadow];
    [shadow release];
}

- (void) initPagesView {
    CGRect frame = self.infoView.bounds;
    
    frame.origin.x = 0.0;
    frame.origin.y = self.headerView.frame.size.height;
    frame.size.height = self.infoView.frame.size.height - frame.origin.y;
    
    self.pagesView = [[UIScrollView alloc] initWithFrame:frame];
    self.pagesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.pagesView.delegate = self;
    self.pagesView.pagingEnabled = YES;
    self.pagesView.showsVerticalScrollIndicator = NO;
    self.pagesView.showsHorizontalScrollIndicator = NO;
    self.pagesView.alwaysBounceVertical = NO;
    self.pagesView.backgroundColor = [UIColor whiteColor];
            
    [self.infoView addSubview:self.pagesView];
}

- (void) initSynopsisView {
    CGRect frame = self.pagesView.bounds;
    
    self.synopsisView = [[UIScrollView alloc] initWithFrame:frame];
    self.synopsisView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.synopsisView.backgroundColor = [UIColor whiteColor];
    self.synopsisView.tag = DAMovieViewSectionSynopsis;
    
    frame.origin.x = 12.0;
    frame.origin.y = 6.0;
    frame.size.height = 20;
    frame.size.width -= 24.0;
    
    self.synopsisLabel = [[UILabel alloc] initWithFrame:frame];
    self.synopsisLabel.font = [UIFont boldSystemFontOfSize:14];
    self.synopsisLabel.textColor = [UIColor colorWithWhite:21.0/255 alpha:1.0]; 
    self.synopsisLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.synopsisLabel.backgroundColor = self.synopsisView.backgroundColor;

    frame.origin.x = 5.0;
    frame.origin.y = self.synopsisLabel.frame.size.height + self.synopsisLabel.frame.origin.y - 8.0;    
    frame.size.height = self.synopsisView.frame.size.height - frame.origin.y;
    frame.size.width += 14.0;

    self.synopsisTextView = [[UITextView alloc] initWithFrame:frame];
    self.synopsisTextView.editable = NO;
    self.synopsisTextView.font = [UIFont systemFontOfSize:13];
    self.synopsisTextView.textColor = [UIColor colorWithWhite:90.0/255 alpha:1.0]; 
    self.synopsisTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.synopsisTextView.userInteractionEnabled = NO;
    self.synopsisTextView.backgroundColor = self.synopsisView.backgroundColor;
    
    [self.synopsisView addSubview:self.synopsisTextView];
    [self.synopsisView addSubview:self.synopsisLabel];
    [self.pagesView    addSubview:self.synopsisView];   
}


- (void) initSectionViews {
    CGRect frame = self.pagesView.bounds;

    frame.origin.x += frame.size.width;
    self.detailsView = [[DATableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.detailsView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                        UIViewAutoresizingFlexibleHeight;
    self.detailsView.tag = DAMovieViewSectionDetails;
    self.detailsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailsView.showSeparatorsInTableFooterView = NO;
    self.detailsView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    self.detailsView.tableFooterView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    frame.origin.x += frame.size.width;
    self.multimediaView = [[DATableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.multimediaView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.multimediaView.tag = DAMovieViewSectionMultimedia;
    self.multimediaView.showSeparatorsInTableFooterView = NO;
    self.multimediaView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    self.multimediaView.tableFooterView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    frame.origin.x += frame.size.width;
    self.castView = [[DATableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.castView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.castView.tag = DAMovieViewSectionCast;
    //self.castView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.castView.showSeparatorsInTableFooterView = NO;
    self.castView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    self.castView.tableFooterView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    frame.origin.x += frame.size.width;
    self.creditsView = [[DATableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.creditsView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.creditsView.tag = DAMovieViewSectionCredits;
    self.creditsView.showSeparatorsInTableFooterView = NO;
    self.creditsView.tableHeaderView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    self.creditsView.tableFooterView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    [self.pagesView addSubview:self.detailsView];
    [self.pagesView addSubview:self.multimediaView];
    [self.pagesView addSubview:self.castView];
    [self.pagesView addSubview:self.creditsView];
}

- (void) addObservers {
    [self.synopsisTextView addObserver:self forKeyPath:@"text" options:0 context:NULL];
    [self.synopsisTextView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [self.pageControl addObserver:self forKeyPath:@"numberOfPages" options:0 context:NULL];
    [self.posterView addObserver:self forKeyPath:@"image" options:0 context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(applicationWillChangeOrientation:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(applicationDidChangeOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];    
}

- (void) removeObservers {
    [self.synopsisTextView removeObserver:self forKeyPath:@"text"];
    [self.synopsisTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.pageControl      removeObserver:self forKeyPath:@"numberOfPages"];
    [self.posterView       removeObserver:self forKeyPath:@"image"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Memory Management.
- (void)dealloc { 
    [self removeObservers];
    
    [_infoView release];            _infoView = nil;
    [_ratingView release];          _ratingView = nil;
    [_headerView release];          _headerView = nil;
    
    [_rateView release];            _rateView = nil;
    [_titleLabel release];          _titleLabel = nil;
    [_genreLabel release];          _genreLabel = nil;
    [_dateLabel release];           _dateLabel = nil;
    [_durationLabel release];       _durationLabel = nil;
    [_posterView release];          _posterView = nil;
    
    [_synopsisTextView release];    _synopsisTextView = nil;
    [_synopsisLabel release];       _synopsisLabel = nil;
    [_synopsisView release];        _synopsisView = nil;
    
    [_detailsView release];         _detailsView = nil;
    [_multimediaView release];      _multimediaView = nil;
    [_castView release];            _castView = nil;
    [_creditsView release];         _creditsView = nil;
    
    [_pagesView release];           _pagesView = nil;
    [_pageControl release];         _pageControl = nil;
    
    [super dealloc];
}

@end