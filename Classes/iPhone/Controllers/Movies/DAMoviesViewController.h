//
//  DAMoviesViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 29/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DACINeolObjectsViewController.h"
#import "DAMovie.h"

@class DAMovieViewController;
@class DAMovie;

enum DAMoviesViewControllerActionSheetsButtons {
    DAMoviesViewControllerActionSheetButtonOk = 0,
    DAMoviesViewControllerActionSheetButtonCancel,
};

enum DAMoviesViewControllerActionSheets {
    DAMoviesViewControllerActionSheetWeb = 0,
    DAMoviesViewControllerActionSheetSend,
    DAMoviesViewControllerActionSheetSortMovies,
};

@interface DAMoviesViewController : DACINeolObjectsViewController <DACINeolObjectsViewController,
                                                                   DAPageViewControllerDelegate,
                                                                   UIActionSheetDelegate,
                                                                   MFMailComposeViewControllerDelegate>
{
    @protected
    NSUInteger              _currentSelectedMovie;
    DAMovieViewController   *_movieViewController;
    
    NSArray                 *_cellItems;
    DAMovie                 *_selectedMovieWithLongTap;
    
    DAMovieSortCategory     _currentSortCategory;
    
    NSFetchedResultsController *_localSearchResults;
    
    struct {
        unsigned int searchDisplayControllerIsPresent:1;
    } _moviesViewControllerFlags;
}

@property (nonatomic, retain, readonly) DAMovieViewController *movieViewController;

- (DAMovieSortCategory) sortMovieCategoryForButtonAtIndex:(NSInteger)index;
- (NSInteger) buttonIndexForSortMovieCategory:(DAMovieSortCategory)category;

- (void) configureBackBarButtonItem;

@end