//
//  DAParseSearchMoviesOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 29/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAXMLParser.h"

@class DAMovie;

@interface DAParseSearchMoviesOperation : DAXMLParser {

    @protected
    DAMovie             *_movie;
    NSUInteger          _numberOfResults;
    NSMutableArray      *_results;
}

- (NSArray*) searchResults;

@end
