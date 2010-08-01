//
//  DAXMLParserMovieCINeol.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAXMLParser.h"

@class DAMovie;
@class DAPhoto;
@class DATrailer;
@class DAPerson;
@class DACredit;


@interface DAXMLParserMovieCINeol : DAXMLParser {

    @public
    DAMovie     *_movie;

    @protected
    DAPhoto     *_photo;
    DATrailer   *_trailer;
    DAPerson    *_person;
    DACredit    *_credit;
    
    NSString    *_genres;
    
    NSUInteger          _CINeolID;
    NSManagedObjectID   *_managedObjectID;
    
    @private
    struct {
        unsigned int processingTrailers:1;
        unsigned int processingGallery:1;
        unsigned int processingPeople:1;
    } _xmlParserMovieCINeol;
}

@property (retain, nonatomic, readonly) NSManagedObjectID *managedObjectID;


- (id)initWithData:(NSData*)data delegate:(id<DAXMLParserDelegate>)delegate movie:(DAMovie*)movie;

- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate
 movieWithCINeolID:(NSUInteger)movieID;

@end
