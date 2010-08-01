//
//  DANewsViewController.h
//  Cineol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "DAXMLParser.h"

@class DANews;

@interface DANewsViewController : DAPageViewController <DAXMLParserDelegate, 
                                                        UIWebViewDelegate,
                                                        UIActionSheetDelegate,
                                                        UIAlertViewDelegate,
                                                        MFMailComposeViewControllerDelegate,
                                                        DAImageViewDelegate> 
{
    @protected
    DANews *_news;
    
    DAScrollView    *_scrollView;
    UIView          *_headerView;
    
    UILabel         *_titleLabel;
    DALabel         *_dateLabel;
    DALabel         *_authorLabel;
    
    UIButton        *_imageButton;
    DAImageView     *_imageView;
    UIWebView       *_webView;
    UIActivityIndicatorView *_spinnerView;
        
    NSOperationQueue *_queue;
        
    @private
    struct {
        unsigned int downloadingNews:1;
        unsigned int cleaningWebView:1;
        unsigned int mailComposerDidDismiss:1;
        unsigned int currentIndex:8;
        unsigned int totalIndexes:8;
    } _newsViewControllerFlags;    
}

@property (nonatomic, retain) DANews *news;

- (id) initWithNews:(DANews*)news;

@end