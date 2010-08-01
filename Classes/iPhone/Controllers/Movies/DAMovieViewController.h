//
//  DAMovieViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import "DAXMLParser.h"
#import "DAMovieView.h"

@class DAMovie;
@class DATrailer;
@class DABarButtonItemComments;
@class DAPhotoGalleryViewController;

@interface DAMovieViewController : DAPageViewController <UIActionSheetDelegate,
                                                         DAXMLParserDelegate,
                                                         UITableViewDelegate,
                                                         UITableViewDataSource,
                                                         MFMailComposeViewControllerDelegate,
                                                         DAMovieViewDelegate,
                                                         DAPageViewControllerDelegate>
{
    @protected
    DAMovie     *_movie;
    DAMovieView *_movieView;
    
    DADownloadProgressView          *_downloadProgressView;
    DAMoviePlayerViewController     *_moviePlayerViewController;
    DAPhotoGalleryViewController    *_photoGalleryViewController;
    
    NSArray *_trailersDataSource;
    NSArray *_castDataSource;
    NSArray *_creditsDataSource;
    NSArray *_commentsDataSource;

    DABarButtonItem         *_ratingBarButttonItem;
    
    NSOperationQueue *_queue;
    
    NSUInteger  _currentComment;
    NSUInteger  _downloadingPageOfComments;
        
    @private    
    struct {
        unsigned int movieFailToDownload:1;
        unsigned int commentsFailToDownload:1;

        unsigned int downloadingMovie:1;
        unsigned int downloadingComments:1;
        unsigned int showingComments:1;
        unsigned int showingTrailer:1;
        unsigned int showingPosterInFullScreenMode:1;
        unsigned int mailComposeViewControllerIsPresent:1;
        unsigned int moviePlayerViewControllerIsPresent:1;
        unsigned int photoGalleryViewControllerIsPresent:1;
    } _movieViewControllerFlags;
}

@property (nonatomic, retain) DAMovie *movie;

- (void) showTrailer:(DATrailer*)trailer;
- (void) showPhotoGallery:(id)sender; // TODO

- (void) previousPageOfComments:(id)sender;
- (void) nextPageOfComments:(id)sender;

@end
