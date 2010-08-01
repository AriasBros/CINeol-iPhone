//
//  DAXMLParserMovieShowtimesCINeol.m
//  CINeol
//
//  Created by David Arias Vazquez on 05/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolKeys.h"
#import "DACINeolManager.h";
#import "DACINeolFacade.h"
#import "DAXMLParserMovieShowtimesCINeol.h"
#import "DAMovie.h"
#import "DAPhoto.h"
#import "DAGenre.h"

@interface DAXMLParserMovieShowtimesCINeol ()

@property (nonatomic, retain) DAMovie *movie;
@property (nonatomic, copy)   NSString *genres;

@end


@implementation DAXMLParserMovieShowtimesCINeol

@synthesize movie  = _movie;
@synthesize genres = _genres;

/*
- (id) initWithData:(NSData *)data delegate:(id <DAXMLParserDelegate>)delegate {
    if (self = [super initWithData:data delegate:delegate]) {
    }
    
    return self;
}
*/

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict
{    
    if ([elementName isEqualToString:kMovieShowtimesKey]) {
        [super parser:parser 
       foundAttribute:kTotalMovieShowtimesAttributeKey 
            withValue:[attributeDict objectForKey:kTotalMovieShowtimesAttributeKey]
           forElement:elementName];
    }
    else if ([elementName isEqualToString:kMovieKey]) {
        self.movie = [DACINeolFacade movie];
    }
    
    [super parser:parser 
  didStartElement:elementName 
     namespaceURI:namespaceURI 
    qualifiedName:qualifiedName 
       attributes:attributeDict];
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
{    
    if ([elementName isEqualToString:kIndexTitleKey]) {
        self.movie.indexTitle = self.temp;
    }
    else if ([elementName isEqualToString:kTitleKey]) {        
        self.movie.title = self.temp;        
    }
    else if ([elementName isEqualToString:kGenreKey]) {  
        self.genres = self.temp;
    }
    else if ([elementName isEqualToString:kDurationKey]) {
        self.movie.duration = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kFormatKey]) {
        self.movie.format = self.temp;
    }
    else if ([elementName isEqualToString:kCINeolURLXMLKey]) {
        self.movie.CINeolID     = [DAMovie movieIDFromURLXML:self.temp];
        self.movie.CINeolURL    = [DAMovie movieURLFromTitle:self.movie.title
                                                       andID:self.movie.CINeolID];
        
        self.movie.numberOfComments = [[DACINeolManager sharedManager]
                                       numberOfCommentsForMovieWithID:self.movie.CINeolID];   
    }
    else if ([elementName isEqualToString:kDatePremierSpainKey]) {
        self.movie.datePremierSpain =  [[DACalendar defaultCalendar] dateFromString:self.temp
                                                                     withDateFormat:kCINeolDatePremierFormat];
    }
    else if ([elementName isEqualToString:kDatePremierOriginKey]) {
        self.movie.datePremierOrigin =  [[DACalendar defaultCalendar] dateFromString:self.temp
                                                                      withDateFormat:kCINeolDatePremierFormat];        
    }
    else if ([elementName isEqualToString:kSynopsisKey]) {
        self.movie.synopsis = self.temp;
    }    
    else if ([elementName isEqualToString:kRatingKey]) {
        self.movie.rating = [self.temp floatValue];
    }
    else if ([elementName isEqualToString:kVotesKey]) {
        self.movie.numberOfVotes = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kPosterThumbnailSizeKey]) {
        DAMovie *movie = [DACINeolFacade movieWithCINeolID:self.movie.CINeolID];
        if (movie == nil) {
            [DACINeolFacade addPosterWithThumbnailURL:self.temp
                                              toMovie:self.movie
                            usingManagedObjectContext:self.managedObjectContext
                                          insertMovie:YES];
            
            NSArray *genres = [self.genres componentsSeparatedByString:@" / "];
            for (NSString *name in genres) {
                DAGenre *genre = [DACINeolFacade genreWithName:name];
                genre = (DAGenre*)[self.managedObjectContext objectWithID:[genre objectID]];
                
                [self.movie addGenresObject:genre];
            }
                        
            [self.managedObjectContext save:NULL];
        }
        else {
            movie = (DAMovie*)[self.managedObjectContext objectWithID:[movie objectID]];
            
            movie.rating = self.movie.rating;
            movie.numberOfVotes = self.movie.numberOfVotes; 
            movie.numberOfComments = self.movie.numberOfComments;
        }
    }
    
    [super parser:parser
    didEndElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName];
}

- (void) dealloc {
    [_movie release];   _movie = nil;
    [super dealloc];
}

@end
