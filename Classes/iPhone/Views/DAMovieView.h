//
//  DAMovieView.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAMovieRatingView;
@class DAMovieCommentsView;
@protocol DAMovieViewDelegate;

typedef enum {
    DAMovieViewSectionSynopsis = 0,
    DAMovieViewSectionDetails,
    DAMovieViewSectionMultimedia,
    DAMovieViewSectionCast,
    DAMovieViewSectionCredits,
} DAMovieViewSection;

typedef enum {
    DAMovieViewSideInfo = 5,
    DAMovieViewSideRating,
    DAMovieViewSideComments,
} DAMovieViewSide;

@interface DAMovieView : UIView <UIScrollViewDelegate, DAImageViewDelegate>
{
    @protected
    /** Main Views **/
    UIView              *_infoView;
    DAMovieRatingView   *_ratingView;
    DAMovieCommentsView *_commentsView;
    
    /** Info Views **/
    UIView *_headerView;
    DARatingView    *_rateView;
    UILabel         *_titleLabel;
    UILabel         *_genreLabel;
    UILabel         *_dateLabel;
    UILabel         *_durationLabel;
    DAImageView     *_posterView;
    
    UIScrollView    *_synopsisView;
    UITextView      *_synopsisTextView;
    UILabel         *_synopsisLabel;
    
    DATableView     *_detailsView;
    DATableView     *_multimediaView;
    DATableView     *_castView;
    DATableView     *_creditsView;
    
    UIPageControl   *_pageControl;
    UIScrollView    *_pagesView;
    
    DAOverlayView   *_overlayView;
    CGRect          _lastPosterFrame;
    
    id <DAMovieViewDelegate> _delegate;
    
    @private
    struct {
        unsigned int allowTouchPosterToEnterInFullScreen:1;
        unsigned int resizingSynopsisTextView:1;
        unsigned int usingPageControl:1;
        unsigned int hidesMultimediaSection:1;
        unsigned int changingOrientation: 1;
        unsigned int currentSide:3;
        unsigned int lastFlipTransitionAnimation:2;
    } _movieViewFlags;
}

@property (nonatomic, retain) NSString      *title;

@property (nonatomic, assign) id<DAMovieViewDelegate>   delegate;
@property (nonatomic, assign) id<UITableViewDataSource> dataSource;

@property (nonatomic, retain, readonly) DAMovieRatingView     *ratingView;
@property (nonatomic, retain, readonly) DAMovieCommentsView   *commentsView;

@property (nonatomic, retain, readonly) DARatingView    *rateView;
@property (nonatomic, retain, readonly) UILabel         *genreLabel;
@property (nonatomic, retain, readonly) UILabel         *dateLabel;
@property (nonatomic, retain, readonly) UILabel         *durationLabel;
@property (nonatomic, retain, readonly) DAImageView     *posterView;
@property (nonatomic, retain, readonly) UIButton        *posterButton;

@property (nonatomic, retain, readonly) UITextView      *synopsisTextView;
@property (nonatomic, retain, readonly) UILabel         *synopsisLabel;

@property (nonatomic, retain, readonly) DATableView     *detailsView;
@property (nonatomic, retain, readonly) DATableView     *multimediaView;
@property (nonatomic, retain, readonly) DATableView     *castView;
@property (nonatomic, retain, readonly) DATableView     *creditsView;

@property (nonatomic, retain, readonly) UIPageControl   *pageControl;

@property (nonatomic, assign) BOOL allowTouchPosterToEnterInFullScreen;
@property (nonatomic, assign) BOOL hidesMultimediaSection;
@property (nonatomic, assign) DAMovieViewSide currentSide;


- (void) flipToSide:(DAMovieViewSide)side animated:(BOOL)animated;
- (void) scrollToSection:(DAMovieViewSection)section animated:(BOOL)animated;

- (void) reloadSections;

- (void) flashScrollIndicatorsOfSynopsisView;

@end


@protocol DAMovieViewDelegate <UITableViewDelegate>

@optional
- (BOOL) movieView:(DAMovieView*)movieView posterViewShouldEnterInFullScreenMode:(DAImageView*)posterView;
- (BOOL) movieView:(DAMovieView*)movieView posterViewShouldExitOfFullScreenMode:(DAImageView*)posterView;

- (BOOL) movieViewIsPosterLoaded:(DAMovieView*)movieView;

- (void) movieView:(DAMovieView*)movieView posterViewWillEnterInFullScreenMode:(UIImageView*)posterView;
- (void) movieView:(DAMovieView*)movieView posterViewDidEnterInFullScreenMode:(UIImageView*)posterView;

- (void) movieView:(DAMovieView*)movieView posterViewWillExitOfFullScreenMode:(UIImageView*)posterView;
- (void) movieView:(DAMovieView*)movieView posterViewDidExitOfFullScreenMode:(UIImageView*)posterView;

@end

