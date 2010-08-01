//
//  DAMovieCommentsView.m
//  CINeol
//
//  Created by David Arias Vazquez on 15/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAMovieCommentsView.h"
#import "DACINeolFacade.h"
#import "DACINeolUserDefaults.h"

@interface DAMovieCommentsView ()

@property (nonatomic, retain) UIView        *bodyView;
@property (nonatomic, retain) UIView        *headerView;
@property (nonatomic, retain) DAPanel       *panelView;

@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UILabel       *subtitleLabel;
@property (nonatomic, retain) DATableView   *tableView;

@property (nonatomic, retain) DAActivityIndicatorView *spinnerView;

@property (nonatomic, retain) NSString  *subtitleFormat;

- (void) initHeaderView;
- (void) initBodyView;
- (void) updateTextOfSubtitleLabel;
- (NSUInteger) numberOfPagesForNumberOfComments:(NSUInteger)numberOfComments;

@end



@implementation DAMovieCommentsView

@dynamic title;
@dynamic currentOffset;
@dynamic hidesActivityIndicatorView;
@dynamic numberOfCommentsInCurrentPage;

@synthesize numberOfComments    = _numberOfComments;
@synthesize numberOfPages       = _numberOfPages;
@synthesize currentPage         = _currentPage;

@synthesize bodyView            = _bodyView;
@synthesize headerView          = _headerView;
@synthesize panelView           = _panelView;

@synthesize titleLabel          = _titleLabel;
@synthesize subtitleLabel       = _subtitleLabel;
@synthesize tableView           = _tableView;
@synthesize spinnerView         = _spinnerView;

@synthesize subtitleFormat      = _subtitleFormat;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.subtitleFormat = @"%i comentarios ∙ Página %i de %i";
        
        _numberOfPages = 1;
        _numberOfComments = 0;
        _currentPage = 1;
        _numberOfCommentsPerPage = 0;
        _movieCommentsViewFlags.currentState = DAMovieCommentsViewStateLoadingComments;
                
        self.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];

        [self initHeaderView];
        [self initBodyView];
    }
    
    return self;
}

- (void) initHeaderView {
    CGRect frame = self.bounds;
    frame.size.height = 52;
    
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.headerView.backgroundColor = [UIColor colorWithWhite:236.0/255 alpha:1.0];
    
    /** BORDERS **/
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
    
    
    /** TITLE **/
    frame = self.headerView.bounds;
    frame.origin.x = 8;
    frame.origin.y = 8;
    frame.size.height = [UIFont boldSystemFontOfSize:17].leading;
    frame.size.width  -= 16;
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.minimumFontSize = 12;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.backgroundColor = self.headerView.backgroundColor;
    self.titleLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.shadowColor = [UIColor whiteColor];
    self.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);    
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel release];

    
    /** SUBTITLE **/
    frame = self.headerView.bounds;
    frame.size.height = [UIFont systemFontOfSize:13].leading;
    frame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    self.subtitleLabel = [[UILabel alloc] initWithFrame:frame];
    self.subtitleLabel.font = [UIFont systemFontOfSize:13];
    self.subtitleLabel.textAlignment = UITextAlignmentCenter;
    self.subtitleLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    self.subtitleLabel.minimumFontSize = 10;
    self.subtitleLabel.adjustsFontSizeToFitWidth = YES;
    self.subtitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    self.subtitleLabel.shadowColor = [UIColor whiteColor];
    self.subtitleLabel.backgroundColor = self.headerView.backgroundColor;
    self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self updateTextOfSubtitleLabel];
    [self.headerView addSubview:self.subtitleLabel];
    [self.subtitleLabel release];
    
    
    [self addSubview:self.headerView];
    [self.headerView release];    
}

- (void) initBodyView {
    CGRect frame = self.bounds;

    /** BODY VIEW **/
    frame.origin.y = self.headerView.frame.size.height;
    frame.size.height -= frame.origin.y;
    UIView *body = [[UIView alloc] initWithFrame:frame];
    body.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    body.backgroundColor = self.backgroundColor;
    self.bodyView = body;
    
    /** TABLE **/
    frame = body.bounds;
    self.tableView = [[DATableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.alpha = 0.0;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [body addSubview:self.tableView];
    [self.tableView release];
    
    
    /** EMPTY VIEW **/
    DAPanel *panel = [[DAPanel alloc] initWithFrame:CGRectZero];
    panel.backgroundColor = [UIColor clearColor];
    panel.layer.cornerRadius = 0.0;
    panel.layer.borderWidth = 0.0;
    panel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    panel.titleLabel.minimumFontSize = 13;
    panel.titleLabel.adjustsFontSizeToFitWidth = YES;
    panel.titleLabel.textColor = self.titleLabel.textColor;
    panel.titleLabel.shadowColor = self.titleLabel.shadowColor;
    panel.titleLabel.shadowOffset = self.titleLabel.shadowOffset;
    panel.titleLabel.text = @"No hay ningún comentario";
    [self.tableView.tableEmptyView addSubview:panel];
    [panel release];
    
    self.panelView = panel;
    
    
    /** Activity View **/
    frame = CGRectMake(0.0, 0.0, 40, 40);
    self.spinnerView = [[DAActivityIndicatorView alloc]initWithFrame:frame];  
    self.spinnerView.userInteractionEnabled = NO;
    frame.origin.x = (body.frame.size.width - frame.size.width) / 2;
    frame.origin.y = (body.frame.size.height - frame.size.height) / 2;
    self.spinnerView.frame = frame;
    [self.spinnerView startAnimating];
    
    [body addSubview:self.spinnerView];
    [self.spinnerView release];
    
    [self addSubview:body];
    [body release];
}


#pragma mark -
#pragma mark Public Methods.
- (void) setState:(DAMovieCommentsViewState)state animated:(BOOL)animated {
    if (_movieCommentsViewFlags.currentState == state)
        return;
    
    _movieCommentsViewFlags.currentState = state;
    
    if (animated)
        [UIView beginAnimations:nil context:NULL];
    
    switch (state) {
        case DAMovieCommentsViewStateShowingComments:
            [self.tableView reloadData];
            self.tableView.alpha = 1.0;
            self.spinnerView.alpha = 0.0;
            [self.spinnerView stopAnimating];
            break;
        
        case DAMovieCommentsViewStateLoadingComments:
            self.tableView.alpha = 0.0;
            self.spinnerView.alpha = 1.0;
            [self.spinnerView startAnimating];
            break;
            
        case DAMovieCommentsViewStateErrorLoadingComments:
            self.panelView.titleLabel.text = @"No se ha podido conectar con CINeol.net";
            [self.tableView reloadData];
            self.tableView.alpha = 1.0;
            self.spinnerView.alpha = 0.0;
            [self.spinnerView stopAnimating];
            break;
    }
    
    if (animated)
        [UIView commitAnimations];
}

- (void) goToNextPage:(id)sender {
    [self goToPage:_currentPage + 1];
}

- (void) goToPreviousPage:(id)sender {
    [self goToPage:_currentPage - 1];    
}

- (void) goToPage:(NSUInteger)page {
    if (page < 1 || page > _numberOfPages || _currentPage == page)
        return;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:NO];
    
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    
    if (_currentPage < page)
        transition.subtype = kCATransitionFromRight;
    else
        transition.subtype = kCATransitionFromLeft;
    
    [self.bodyView.layer addAnimation:transition forKey:nil];

    self.currentPage = page;
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark CAAnimation Delegate Methods.
- (void)animationDidStart:(CAAnimation *)theAnimation {
    
}

- (void)animationDidStop:(CAAnimation*)theAnimation finished:(BOOL)flag {
    [self.tableView flashScrollIndicators];
}

#pragma mark -
#pragma mark Properties.
- (NSUInteger) numberOfCommentsInCurrentPage {
    return [self.tableView numberOfRowsInSection:0];
}

- (void) setHidesActivityIndicatorView:(BOOL)hides {
    self.spinnerView.hidden = hides;
}

- (BOOL) hidesActivityIndicatorView {
    return self.spinnerView.hidden;
}

- (NSUInteger) numberOfCommentsPerPage {
    if (_numberOfCommentsPerPage == 0) {
        _numberOfCommentsPerPage = [DACINeolUserDefaults numberOfCommentsPerPage];
    }
    
    return _numberOfCommentsPerPage;
}

- (NSUInteger) currentOffset {
    return (_currentPage - 1) * _numberOfCommentsPerPage;
}

- (void) setTitle:(NSString *)title {
    if (title == self.title)
        return;
    
    self.titleLabel.text = title;
}

- (NSString*) title {
    return self.titleLabel.text;
}

- (void) setNumberOfComments:(NSUInteger)comments {
    _numberOfComments = comments;
    _numberOfPages = [self numberOfPagesForNumberOfComments:_numberOfComments];
        
    self.hidesActivityIndicatorView = (comments == 0);
    
    [self updateTextOfSubtitleLabel];
}

- (void) setNumberOfPages:(NSUInteger)pages {
    _numberOfPages = pages;
    [self updateTextOfSubtitleLabel];
}

- (void) setCurrentPage:(NSUInteger)currentPage {
    _currentPage = currentPage;
    [self updateTextOfSubtitleLabel];
}


#pragma mark -
#pragma mark Private Methods.
- (NSUInteger) numberOfPagesForNumberOfComments:(NSUInteger)numberOfComments {    
    NSUInteger pages = numberOfComments / self.numberOfCommentsPerPage;
    
    if (self.numberOfCommentsPerPage - pages != 0)
        pages++;
    
    return  pages;
}

- (void) updateTextOfSubtitleLabel {
    NSString *text = [[NSString alloc] initWithFormat:self.subtitleFormat,
                      _numberOfComments, _currentPage, _numberOfPages];

    self.subtitleLabel.text = text;    
    [text release];
}

- (void) updateTableView {
    if (_numberOfComments == 0) {
        
    }
}

#pragma mark -
#pragma mark Memory Management.
- (void)dealloc {
    [_bodyView release];        _bodyView = nil;
    [_headerView release];      _headerView = nil;
    [_titleLabel release];      _titleLabel = nil;
    [_subtitleLabel release];   _subtitleLabel = nil;
    [_subtitleFormat release];  _subtitleFormat = nil;
    [_tableView release];       _tableView = nil;

    [super dealloc];
}

@end