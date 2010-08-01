//
//  DADownloableItemsViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DATouchKit/DATouchKit.h>
#import "DAXMLParser.h"

@protocol DACINeolObjectsViewController <NSObject>

@required
- (NSFetchedResultsController*) fetchedResultsController;
- (void) configureTabBarItem;
- (void) configureRightBarButtonItem;
- (void) configureLeftBarButtonItem;

@end

@class DADownloadProgressView;

@interface DACINeolObjectsViewController : DATableViewController <NSFetchedResultsControllerDelegate,
                                                                  DAXMLParserDelegate,
                                                                  DATableViewDelegate>
{
    @protected
    NSFetchedResultsController *_fetchedResultsController;    
    DADownloadProgressView *_downloadProgressView;
    NSOperationQueue *_queue;
    
    NSUInteger _limitOfObjectsInList;
    
    struct {
        unsigned int shouldReloadData:1;
    } _CINeolObjectsViewControllerFlags;
}

@property (nonatomic, assign, readonly) UIImage *image;
@property (nonatomic, assign, readonly) NSInteger tag;
@property (nonatomic, retain, readonly) DADownloadProgressView *downloadProgressView;
@property (nonatomic, retain, readonly) NSOperationQueue       *queue;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void) showNoInternetConectionPanel:(id)sender;

- (void) showDownloadProgressView:(id)sender;
- (void) hideDownloadProgressView:(id)sender;

@end




