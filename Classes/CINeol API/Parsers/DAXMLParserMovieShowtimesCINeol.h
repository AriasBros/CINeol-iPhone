//
//  DAXMLParserMovieShowtimesCINeol.h
//  CINeol
//
//  Created by David Arias Vazquez on 05/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAXMLParser.h"

@class DAMovie;
@class DAPhoto;

@interface DAXMLParserMovieShowtimesCINeol : DAXMLParser {
    
    @protected
    DAMovie     *_movie;    
    NSString    *_genres;
}

@end
