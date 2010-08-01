//
//  DAParseSearchMoviesOperation.m
//  CINeol
//
//  Created by David Arias Vazquez on 29/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAParseSearchMoviesOperation.h"
#import "DAMovie.h"
#import "DACINeolKeys.h"
#import "DACINeolFacade.h"

@interface DAParseSearchMoviesOperation ()

@property (retain, nonatomic) DAMovie           *movie;
@property (retain, nonatomic) NSMutableArray    *results;


@end


@implementation DAParseSearchMoviesOperation

@synthesize movie = _movie;
@synthesize results = _results;

- (id) initWithData:(NSData *)data delegate:(id <DAXMLParserDelegate>)delegate {
    if (self = [super initWithData:data delegate:delegate]) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
        self.results = array;
        [array release];
    }
    
    return self;
}

- (NSArray*) searchResults {
    return [NSArray arrayWithArray:_results];
}

- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName 
     attributes:(NSDictionary *)attributeDict
{
    if ([elementName caseInsensitiveCompare:kMovieKey] == NSOrderedSame) {
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
    if ([elementName isEqualToString:kOriginalTitleKey]) {
        self.movie.originalTitle = self.temp;
    }
    else if ([elementName isEqualToString:kIndexTitleKey]) {        
        self.movie.indexTitle = self.temp;        
    }
    else if ([elementName isEqualToString:kYearKey]) {        
        self.movie.year = [self.temp integerValue];        
    }    
    else if ([elementName isEqualToString:kCINeolURLKey]) {
        self.movie.CINeolURL = self.temp;
    }
    else if ([elementName isEqualToString:kCINeolURLXMLKey]) {
        self.movie.CINeolID     = [DAMovie movieIDFromURLXML:self.temp];        
    }
    else if ([elementName caseInsensitiveCompare:kMovieKey] == NSOrderedSame) {
        DAMovie *movie = [DACINeolFacade movieWithCINeolID:self.movie.CINeolID];
        if (movie == nil) {
            movie = self.movie;
            [self.managedObjectContext insertObject:movie];
            [self.managedObjectContext save:NULL];
        }
        else {
            movie = (DAMovie*)[self.managedObjectContext objectWithID:[movie objectID]];
            movie.year = self.movie.year;
        }
        
        [_results addObject:movie];
    }
    
    [super parser:parser
    didEndElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName];
}


- (void) dealloc {
    [_movie release];   _movie = nil;
    [_results release]; _results = nil;
    [super dealloc];
}

@end
