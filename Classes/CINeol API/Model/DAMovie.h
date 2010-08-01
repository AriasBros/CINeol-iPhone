//
//  CEMovie.h
//  Cineol
//
//  Created by David Arias Vazquez on 17/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACINeolObject.h"

@class DAGenre;
@class DACredit;
@class DAPhoto;
@class DATrailer;
@class DAComment;


NSString* const kCINeolDatePremierFormat;

typedef enum {
    DAMovieSortByPremierDate = 0,
    DAMovieSortByTitle,
    DAMovieSortByDuration,
    DAMovieSortByRating,
    DAMovieSortByGenre,
} DAMovieSortCategory;

@interface DAMovie : DACINeolObject {
    
    @protected
    NSString *_genre;
}

@property (nonatomic, assign) NSUInteger duration;
@property (nonatomic, assign) NSUInteger numberOfVotes;
@property (nonatomic, assign) NSUInteger year;

@property (nonatomic, assign) CGFloat takingsSpain;
@property (nonatomic, assign) CGFloat takingsUSA;
@property (nonatomic, assign) CGFloat rating;

@property (nonatomic, retain) NSDate *datePremierOrigin;
@property (nonatomic, retain) NSDate *datePremierSpain;

@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) NSString *indexTitle;
@property (nonatomic, copy) NSString *originalTitle;

@property (nonatomic, retain) DAPhoto *poster;

@property (nonatomic, retain) NSSet* genres;
@property (nonatomic, retain) NSSet* credits;
@property (nonatomic, retain) NSSet* photos;
@property (nonatomic, retain) NSSet* trailers;
@property (nonatomic, retain) NSSet* comments;


@property (nonatomic, assign, readonly) BOOL isPremier;
@property (nonatomic, copy, readonly) NSString *genre;

@property (nonatomic, retain, readonly) NSString *datePremierSpainText;
@property (nonatomic, retain, readonly) NSString *datePremierOriginText;


+ (NSUInteger) movieIDFromURLXML:(NSString*)URLXML;
+ (NSString*) movieURLFromTitle:(NSString*)title andID:(NSInteger)ID;

- (BOOL) needsDownloadContent;

@end


@interface DAMovie (CoreDataGeneratedAccessors)

- (void)addGenresObject:(DAGenre *)value;
- (void)removeGenresObject:(DAGenre *)value;
- (void)addGenres:(NSSet *)value;
- (void)removeGenres:(NSSet *)value;

- (void)addCreditsObject:(DACredit *)value;
- (void)removeCreditsObject:(DACredit *)value;
- (void)addCredits:(NSSet *)value;
- (void)removeCredits:(NSSet *)value;

- (void)addPhotosObject:(DAPhoto *)value;
- (void)removePhotosObject:(DAPhoto *)value;
- (void)addPhotos:(NSSet *)value;
- (void)removePhotos:(NSSet *)value;

- (void)addTrailersObject:(DATrailer *)value;
- (void)removeTrailersObject:(DATrailer *)value;
- (void)addTrailers:(NSSet *)value;
- (void)removeTrailers:(NSSet *)value;

- (void)addCommentsObject:(DAComment*)value;
- (void)removeCommentsObject:(DAComment*)value;
- (void)addComments:(NSSet *)value;
- (void)removeComments:(NSSet *)value;

@end