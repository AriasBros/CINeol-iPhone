//
//  DASearchMoviesViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 29/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAMoviesViewController.h"
#import "DAXMLParser.h"

@interface DASearchMoviesViewController : DAMoviesViewController <UISearchBarDelegate,
                                                                  DAXMLParserDelegate>
{
    @protected
    NSString         *_currentQuery;
    NSOperationQueue *_operationQueue;
    NSArray          *_dataSource;
        
    @private
    struct {
        unsigned int searching:1;
    } _searchMoviesViewControllerFlags;
}

@end