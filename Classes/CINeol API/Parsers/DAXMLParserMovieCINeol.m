//
//  DAXMLParserMovieCINeol.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <DATouchKit/DATouchKit.h>

#import "DACINeolKeys.h"
#import "DAXMLParserMovieCINeol.h"
#import "DACoreDataManager.h"
#import "DACINeolFacade.h"

#import "DAMovie.h"
#import "DAPhoto.h"
#import "DATrailer.h"
#import "DAPerson.h"
#import "DACredit.h"


#define CINEOL_URL_BASE @"http://www.cineol.net/"


@interface DAXMLParserMovieCINeol ()

@property (retain, nonatomic) DAMovie   *movie;
@property (retain, nonatomic) DATrailer *trailer;
@property (retain, nonatomic) DAPhoto   *photo;
@property (retain, nonatomic) DAPerson  *person;
@property (retain, nonatomic) DACredit  *credit;

@property (nonatomic, copy) NSString    *genres;


@property (retain, nonatomic) NSManagedObjectID *managedObjectID;


@end


@implementation DAXMLParserMovieCINeol

@synthesize movie   = _movie;
@synthesize photo   = _photo;
@synthesize trailer = _trailer;
@synthesize person  = _person;
@synthesize credit  = _credit;

@synthesize genres  = _genres;

@synthesize managedObjectID = _managedObjectID;


- (id)initWithData:(NSData*)data delegate:(id<DAXMLParserDelegate>)delegate movie:(DAMovie*)movie
{
    if (self = [super initWithData:data delegate:delegate]) {
        self.managedObjectID = [movie objectID];
                
        _xmlParserMovieCINeol.processingPeople = 0;
        _xmlParserMovieCINeol.processingGallery = 0;
        _xmlParserMovieCINeol.processingTrailers = 0;
    }
    
    return self;
}

- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate
 movieWithCINeolID:(NSUInteger)movieID
{
    if (self = [super initWithData:data delegate:delegate]) {

        self.managedObjectID = nil;
        _CINeolID = movieID;
        
        _xmlParserMovieCINeol.processingPeople = 0;
        _xmlParserMovieCINeol.processingGallery = 0;
        _xmlParserMovieCINeol.processingTrailers = 0;
    }
    
    return self;    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {  
    
    if (self.managedObjectID == nil)
        self.managedObjectID = [[DACINeolFacade movieWithCINeolID:_CINeolID] objectID];

    self.movie = (DAMovie*)[self.managedObjectContext objectWithID:self.managedObjectID];
    
    [super parserDidStartDocument:parser];
}

- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName 
     attributes:(NSDictionary *)attributeDict
{

    /*
    if ([elementName isEqualToString:kMovieKey]) {
        self.movie = (DAMovie*)[self.managedObjectContext objectWithID:self.managedObjectID];
    }
    */
    if ([elementName isEqualToString:kDirectorsKey]    ||
             [elementName isEqualToString:kProducersKey]    ||
             [elementName isEqualToString:kScriptwritersKey]||
             [elementName isEqualToString:kPhotographersKey]||
             [elementName isEqualToString:kMusiciansKey]    ||
             [elementName isEqualToString:kPerformersKey])
    {
        _xmlParserMovieCINeol.processingPeople = 1;
        _xmlParserMovieCINeol.processingGallery = 0;
        _xmlParserMovieCINeol.processingTrailers = 0;        
    }
    else if ([elementName isEqualToString:kGalleryKey]) {
        _xmlParserMovieCINeol.processingPeople = 0;
        _xmlParserMovieCINeol.processingGallery = 1;
        _xmlParserMovieCINeol.processingTrailers = 0;
    }
    else if ([elementName isEqualToString:kTrailersKey]) {
        _xmlParserMovieCINeol.processingPeople = 0;
        _xmlParserMovieCINeol.processingGallery = 0;
        _xmlParserMovieCINeol.processingTrailers = 1;    
    }
    else if ([elementName isEqualToString:kTrailerKey]) {
        self.trailer = [DACINeolFacade trailer];
    }
    else if ([elementName isEqualToString:kPhotoKey]) {
        self.photo = [DACINeolFacade photo];
    }

    else if ([elementName isEqualToString:kDirectorKey]) {
        self.person = [DACINeolFacade person];
        self.credit = [DACINeolFacade credit];
        
        self.credit.type = DACreditTypeDirector;
    }
    else if ([elementName isEqualToString:kProducerKey]) {
        self.person = [DACINeolFacade person];
        self.credit = [DACINeolFacade credit];
        
        self.credit.type = DACreditTypeProducer;
    }
    else if ([elementName isEqualToString:kScriptwriterKey]) {
        self.person = [DACINeolFacade person];
        self.credit = [DACINeolFacade credit];
        
        self.credit.type = DACreditTypeScriptwriter;
    }
    else if ([elementName isEqualToString:kPhotographerKey]) {
        self.person = [DACINeolFacade person];
        self.credit = [DACINeolFacade credit];
        
        self.credit.type = DACreditTypePhotographer;
    }
    else if ([elementName isEqualToString:kMusicianKey]) {
        self.person = [DACINeolFacade person];
        self.credit = [DACINeolFacade credit];
        
        self.credit.type = DACreditTypeMusician;
    }
    else if ([elementName isEqualToString:kPerformerKey]) {
        self.person = [DACINeolFacade person];
        self.credit = [DACINeolFacade credit];
        
        self.credit.type = DACreditTypePerformer;
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
    else if ([elementName isEqualToString:kOriginalTitleKey]) {
        self.movie.originalTitle = self.temp;
    }
    else if ([elementName isEqualToString:kYearKey]) {
        self.movie.year = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kGenreKey]) {
        if ([self.movie.genres count] == 0 && [self.temp length] > 0) {
            NSArray *genres = [self.temp componentsSeparatedByString:@" / "];

            for (NSString *name in genres) {
                DAGenre *genre = [DACINeolFacade genreWithName:name];
                genre = (DAGenre*)[self.managedObjectContext objectWithID:[genre objectID]];
                
                [self.movie addGenresObject:genre];
            }
        }
    }
    else if ([elementName isEqualToString:kCountryKey]) {
        self.movie.country = self.temp;
    }
    else if ([elementName isEqualToString:kDurationKey]) {
        self.movie.duration = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kFormatKey]) {
        self.movie.format = self.temp;
    }
    /*
    else if ([elementName isEqualToString:kCineolURLXMLKey]) {
    }
    */
    else if ([elementName isEqualToString:kDatePremierSpainKey]) {
        self.movie.datePremierSpain =  [[DACalendar defaultCalendar] dateFromString:self.temp
                                                                     withDateFormat:kCINeolDatePremierFormat];
    }
    else if ([elementName isEqualToString:kDatePremierOriginKey]) {
        self.movie.datePremierOrigin =  [[DACalendar defaultCalendar] dateFromString:self.temp
                                                                      withDateFormat:kCINeolDatePremierFormat];
    }
    else if ([elementName isEqualToString:kTakingsSpainKey]) {
        self.movie.takingsSpain = [[[DAFormatter defaultFormatter] numberFromString:self.temp
                                                                    withNumberStyle:NSNumberFormatterDecimalStyle
                                                                  groupingSeperator:@"."
                                                                   decimalSeparator:@","
                                                                   localeIdentifier:@"es_ES"
                                                                     currencySymbol:@"€"
                                                                       currencyCode:@"EUR"] floatValue];
    }
    else if ([elementName isEqualToString:kTakingsUSAKey]) {        
        self.movie.takingsUSA = [[[DAFormatter defaultFormatter] numberFromString:self.temp
                                                                  withNumberStyle:NSNumberFormatterDecimalStyle
                                                                groupingSeperator:@","
                                                                 decimalSeparator:@"."
                                                                 localeIdentifier:@"en_US"
                                                                   currencySymbol:@"$"
                                                                     currencyCode:@"USD"] floatValue]; 
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
    else if ([elementName isEqualToString:kNumberOfCommentsKey]) {
        self.movie.numberOfComments = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kCINeolURLKey] &&
             _xmlParserMovieCINeol.processingPeople == 0)
    {
        self.movie.CINeolURL = self.temp;
    }
    else if ([elementName isEqualToString:kPosterThumbnailSizeKey]) {
        if (self.movie.poster == nil) {
            [DACINeolFacade addPosterWithThumbnailURL:self.temp
                                              toMovie:self.movie
                            usingManagedObjectContext:self.managedObjectContext
                                          insertMovie:NO];
        }        
    }
    else if ([elementName isEqualToString:kPosterFullSizeKey]) {        
        self.movie.poster.photoURL = self.temp;
    }
    else if ([elementName isEqualToString:kTrailerDescKey]) {
        self.trailer.desc = self.temp;
    }
    else if ([elementName isEqualToString:kTrailerDailymotionIDKey]) {
        self.trailer.dailymotionID = self.temp;
    }
    else if ([elementName isEqualToString:kTrailerDateKey]) {        
        self.trailer.date = [[DACalendar defaultCalendar] dateFromString:self.temp
                                                          withDateFormat:kCINeolDateTrailerFormat];
    }    
    else if ([elementName isEqualToString:kTrailerKey]) {
        if ([DACINeolFacade trailerWithDailymotionID:self.trailer.dailymotionID] == nil) {
            [self.managedObjectContext insertObject:self.trailer];
            [self.movie addTrailersObject:self.trailer];            
        }
    }
    else if ([elementName isEqualToString:kPhotoThumbSizeKey]) {
        self.photo.thumbnailURL = [CINEOL_URL_BASE stringByAppendingString:self.temp];
    }
    else if ([elementName isEqualToString:kPhotoFullSizeKey]) {
        self.photo.photoURL = [CINEOL_URL_BASE stringByAppendingString:self.temp];
        
         NSString *value = [self.temp lastPathComponent];
         value = [value stringByDeletingPathExtension];
         NSArray *IDs = [value componentsSeparatedByString: @"_"];
         
         self.photo.galleryID = [[IDs objectAtIndex:0] integerValue];
         self.photo.photoID   = [[IDs objectAtIndex:1] integerValue];
    }
    else if ([elementName isEqualToString:kPhotoKey]) {
        if ([DACINeolFacade photoWithCINeolID:self.photo.photoID] == nil) {
            [self.managedObjectContext insertObject:self.photo];
            [self.movie addPhotosObject:self.photo];                      
        }        
    }
    else if ([elementName isEqualToString:kPersonNameKey]) {
        self.person.name = self.temp;
    }
    else if ([elementName isEqualToString:kPersonURLKey]) {
        self.person.cineolURL = self.temp;
        self.person.cineolID  = [DAPerson personIDFromURL:self.temp];
    }
    else if ([elementName isEqualToString:kPersonInfoKey]) {
        self.credit.job = self.temp;
    }
    else if ([elementName isEqualToString:kDirectorKey]     ||
             [elementName isEqualToString:kProducerKey]     ||
             [elementName isEqualToString:kScriptwriterKey] ||
             [elementName isEqualToString:kPhotographerKey] ||
             [elementName isEqualToString:kMusicianKey]     ||
             [elementName isEqualToString:kPerformerKey])
    {    
        DAPerson *person = [DACINeolFacade personWithCINeolID:self.person.cineolID];
        
        if (person == nil && self.person != nil) {
            person = self.person;
            [self.managedObjectContext insertObject:person];
        }
        else {
            person = (DAPerson*)[self.managedObjectContext objectWithID:[person objectID]];
        }

        
        if (person != nil) {
            [self.managedObjectContext insertObject:self.credit];
            self.credit.person = person;
            self.credit.movie = self.movie;
            
            [self.movie addCreditsObject:self.credit];    
        }
    }
    else if ([elementName isEqualToString:kDirectorsKey]     ||
             [elementName isEqualToString:kProducersKey]     ||
             [elementName isEqualToString:kScriptwritersKey] ||
             [elementName isEqualToString:kPhotographersKey] ||
             [elementName isEqualToString:kMusiciansKey]     ||
             [elementName isEqualToString:kPerformersKey])
    {
        _xmlParserMovieCINeol.processingPeople = 0;
    }
    else if ([elementName isEqualToString:kGalleryKey]) {
        _xmlParserMovieCINeol.processingGallery = 0;
    }
    else if ([elementName isEqualToString:kTrailersKey]) {
        _xmlParserMovieCINeol.processingTrailers = 0;    
    }
    else if ([elementName isEqualToString:kMovieKey]) {
        [self.managedObjectContext save:NULL];          //TODO - Manejar error...
    }
    
    [super parser:parser
  didEndElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName];
}

#pragma mark -
#pragma mark Memory Management
- (void) dealloc {
    [_credit release];          _credit = nil;
    [_person release];          _person = nil;
    [_movie release];           _movie = nil;
    [_photo release];           _photo = nil;
    [_trailer release];         _trailer = nil;
    [_managedObjectID release]; _managedObjectID = nil;
    
    [super dealloc];
}

@end