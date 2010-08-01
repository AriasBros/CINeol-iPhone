//
//  CEMovie.m
//  Cineol
//
//  Created by David Arias Vazquez on 17/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import "DAMovie.h"
#import "DACredit.h"
#import "DAPhoto.h"
#import "DATrailer.h"
#import "DAComment.h"
#import "DAGenre.h"

#import "DACINeolFacade.h"


NSString *const kCINeolDatePremierFormat = @"dd-MMM-yyyy";
NSString *const kMovieDatePremierFormat = @"EEEE, dd MMMM yyyy";

#define URL_BASE @"http://www.cineol.net/pelicula/"

@interface DAMovie ()

@property (nonatomic, copy) NSString *genre;

@end


@implementation DAMovie

@synthesize genre = _genre;
@dynamic isPremier;

@dynamic datePremierOrigin;
@dynamic datePremierSpain;
@dynamic duration;
@dynamic takingsSpain;
@dynamic takingsUSA;
@dynamic numberOfVotes;
@dynamic synopsis;
@dynamic country;
@dynamic format;
@dynamic indexTitle;
@dynamic originalTitle;
@dynamic rating;
@dynamic title;
@dynamic year;

@dynamic poster;

@dynamic genres;
@dynamic credits;
@dynamic photos;
@dynamic trailers;
@dynamic comments;

@dynamic datePremierSpainText;
@dynamic datePremierOriginText;


+ (NSUInteger) movieIDFromURLXML:(NSString*)URLXML {
    NSScanner *scanner = [NSScanner scannerWithString:URLXML];
    NSInteger ID = 0;
    
    [scanner scanString:@"http://www.cineol.net/api/peliculaxml.php?id=" intoString:NULL];
    [scanner scanInteger:&ID];

    if (ID == 0) {
        [scanner scanString:@"http://www.cineol.net/peliculaxml.php?id=" intoString:NULL];
        [scanner scanInteger:&ID];
    }
    
    return ID;
}

+ (NSString*) movieURLFromTitle:(NSString*)title andID:(NSInteger)ID {
    NSMutableString *strurl = [[NSMutableString alloc] initWithString:URL_BASE];
    
    [strurl appendFormat:@"%i_%@", ID, title];
    
    NSInteger loc = [URL_BASE length];
    NSInteger len = [strurl length];
    
    [strurl replaceOccurrencesOfString:@" "
                            withString:@"-"
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(loc, len - loc)];
    
    return [strurl autorelease];
}

- (BOOL) needsDownloadContent {
    return (self.originalTitle == nil || self.title == nil);
}

- (BOOL) isPremier {    
    NSDate *nextWeek = [[DACalendar defaultCalendar] dateForNthWeeksFromToday:1];
    NSDate *thisWeek = [[DACalendar defaultCalendar] dateForActualWeek];
    
    return ([self.datePremierSpain earlierDate:nextWeek] == self.datePremierSpain &&
            [self.datePremierSpain laterDate:thisWeek]   == self.datePremierSpain);
}

- (NSString*) genre {
    if (_genre == nil && [self.genres count] > 0) {        
        NSArray *genres = [[self.genres allObjects] sortedArrayUsingDescriptors:
                           [DACINeolFacade sortDescriptorsForGenres]];
        
        NSMutableString *genresString = [[NSMutableString alloc] initWithCapacity:10];
        
        int i = 0;
        for (DAGenre *genre in genres) {
            
            if (i == 0)
                [genresString appendString:genre.name];                
            else
                [genresString appendFormat:@" / %@", genre.name];
            
            i++;
        }
        
        self.genre = [NSString stringWithString:genresString];
        [genresString release];        
    }
    
    return _genre;
}

- (NSString*) datePremierSpainText {
    return [[DACalendar defaultCalendar] stringFromDate:self.datePremierSpain 
                                         withDateFormat:kMovieDatePremierFormat];
}

- (NSString*) datePremierOriginText {
    return [[DACalendar defaultCalendar] stringFromDate:self.datePremierOrigin 
                                         withDateFormat:kMovieDatePremierFormat];
}

- (void) setPoster:(DAPhoto*)photo {
    self.photo = photo;
}

- (DAPhoto*) poster {
    return self.photo;
}

- (void) setDuration:(NSUInteger)duration {
    [super willChangeValueForKey: @"duration"];
    [super setPrimitiveValue: [NSNumber numberWithInt: duration] forKey: @"duration"];
    [super didChangeValueForKey: @"duration"];
}

- (NSUInteger) duration {
    [super willAccessValueForKey: @"duration"];
    NSUInteger duration =[(NSNumber*)[super primitiveValueForKey: @"duration"] intValue];
    [super didAccessValueForKey: @"duration"];
    
    return duration;
}

- (void) setYear:(NSUInteger)year {
    [super willChangeValueForKey: @"year"];
    [super setPrimitiveValue: [NSNumber numberWithInt: year] forKey: @"year"];
    [super didChangeValueForKey: @"year"];
}

- (NSUInteger) year {
    [super willAccessValueForKey: @"year"];
    NSUInteger year =[(NSNumber*)[super primitiveValueForKey: @"year"] intValue];
    [super didAccessValueForKey: @"year"];
    
    return year;
}

- (void) setRating:(CGFloat)rating {
    [super willChangeValueForKey: @"rating"];
    [super setPrimitiveValue: [NSNumber numberWithFloat: rating] forKey: @"rating"];
    [super didChangeValueForKey: @"rating"];
}

- (CGFloat) rating {
    [super willAccessValueForKey: @"rating"];
    CGFloat rating =[(NSNumber*)[super primitiveValueForKey: @"rating"] floatValue];
    [super didAccessValueForKey: @"rating"];
    
    return rating;
}

- (void) setNumberOfVotes:(NSUInteger)votes {
    [super willChangeValueForKey: @"numberOfVotes"];
    [super setPrimitiveValue: [NSNumber numberWithInt: votes] forKey: @"numberOfVotes"];
    [super didChangeValueForKey: @"numberOfVotes"];
}

- (NSUInteger) numberOfVotes {
    [super willAccessValueForKey: @"numberOfVotes"];
    NSUInteger votes =[(NSNumber*)[super primitiveValueForKey: @"numberOfVotes"] intValue];
    [super didAccessValueForKey: @"numberOfVotes"];
    
    return votes;
}

- (void) setTakingsSpain:(CGFloat)takingsSpain {
    [super willChangeValueForKey: @"takingsSpain"];
    [super setPrimitiveValue: [NSNumber numberWithFloat: takingsSpain] forKey: @"takingsSpain"];
    [super didChangeValueForKey: @"takingsSpain"];
}

- (CGFloat) takingsSpain {
    [super willAccessValueForKey: @"takingsSpain"];
    CGFloat takingsSpain =[(NSNumber*)[super primitiveValueForKey: @"takingsSpain"] floatValue];
    [super didAccessValueForKey: @"takingsSpain"];
    
    return takingsSpain;
}

- (void) setTakingsUSA:(CGFloat)takingsUSA {
    [super willChangeValueForKey: @"takingsUSA"];
    [super setPrimitiveValue: [NSNumber numberWithFloat: takingsUSA] forKey: @"takingsUSA"];
    [super didChangeValueForKey: @"takingsUSA"];
}

- (CGFloat) takingsUSA {
    [super willAccessValueForKey: @"takingsUSA"];
    CGFloat takingsUSA =[(NSNumber*)[super primitiveValueForKey: @"takingsUSA"] floatValue];
    [super didAccessValueForKey: @"takingsUSA"];
    
    return takingsUSA;
}

- (NSSet*) comments {
    [super willAccessValueForKey: @"comments"];
    NSSet *comments = (NSSet*)[super primitiveValueForKey: @"comments"];
    [super didAccessValueForKey: @"comments"];
    
    return comments;
}

@end
