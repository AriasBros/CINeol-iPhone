//
//  DAMovieCommentsView.h
//  CINeol
//
//  Created by David Arias Vazquez on 15/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    DAMovieCommentsViewStateShowingComments = 0,
    DAMovieCommentsViewStateLoadingComments,
    DAMovieCommentsViewStateErrorLoadingComments,
} DAMovieCommentsViewState;


@interface DAMovieCommentsView : UIView {

    @protected
    DAActivityIndicatorView *_spinnerView;
    
    UIView          *_bodyView;
    UIView          *_headerView;
    DAPanel         *_panelView;
    UIScrollView    *_scrollView;
    UILabel         *_titleLabel;
    UILabel         *_subtitleLabel;
    DATableView     *_tableView;
    
    NSString        *_subtitleFormat; 
    
    NSUInteger      _numberOfComments;
    NSUInteger      _numberOfPages;
    NSUInteger      _currentPage;    
    NSUInteger      _numberOfCommentsPerPage;

    struct {
        unsigned int currentState:1;
    } _movieCommentsViewFlags;
}

@property (nonatomic, retain) NSString      *title;
@property (nonatomic, assign) NSUInteger    numberOfComments;
@property (nonatomic, assign) NSUInteger    numberOfPages;
@property (nonatomic, assign) NSUInteger    currentPage;
@property (nonatomic, assign) BOOL          hidesActivityIndicatorView;

@property (nonatomic, assign, readonly) NSUInteger    numberOfCommentsInCurrentPage;
@property (nonatomic, assign, readonly) NSUInteger    numberOfCommentsPerPage;
@property (nonatomic, assign, readonly) NSUInteger    currentOffset;
@property (nonatomic, retain, readonly) DATableView   *tableView;


- (void) setState:(DAMovieCommentsViewState)state animated:(BOOL)animated;

- (void) goToNextPage:(id)sender;
- (void) goToPreviousPage:(id)sender;
- (void) goToPage:(NSUInteger)page;

@end
