//
//  DACINeolFacade.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAMovie.h"

@class DANews;
@class DAPhoto;
@class DATrailer;
@class DAPerson;
@class DACredit;
@class DAComment;
@class DAGenre;

#define kNewsViewControllerTag              0
#define kMovieShowtimesViewControllerTag    1
#define kMoviesViewControllerTag            2
#define kReviewsViewControllerTag           3
#define kPeopleViewControllerTag            4

@interface DACINeolFacade : NSObject {
}

#pragma mark -
#pragma mark Utils.
+ (void) openURLOnSafari:(NSString*)url;

+ (NSURL*) URLForDailymotionVideoWithVideoID:(NSString*)dailymotionID;

+ (void) presentMailComposeViewControllerInController:(UIViewController*)parentController
                                                movie:(DAMovie*)movie;

+ (void) presentMailComposeViewControllerInController:(UIViewController*)parentController
                                                 news:(DANews*)news;

+ (void) addPosterWithThumbnailURL:(NSString*)thumbnailURL 
                           toMovie:(DAMovie*)movie 
         usingManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                       insertMovie:(BOOL)insertMovie;

+ (NSString*) nameForMovieSortCategory:(DAMovieSortCategory)category;


#pragma mark Creating.
+ (DAMovie*) movie;
+ (DANews*) news;
+ (DAPhoto*) photo;
+ (DATrailer*) trailer;
+ (DAPerson*) person;
+ (DACredit*) credit;
+ (DAComment*) comment;


#pragma mark Inserting.
+ (void) insertObject:(id)object;
+ (void) insertMovie:(DAMovie*)movie;
+ (void) insertNews:(DANews*)news;
+ (void) insertPhoto:(DAPhoto*)photo;
+ (void) insertTrailer:(DATrailer*)trailer;
+ (void) insertPerson:(DAPerson*)person;
+ (void) insertCredit:(DACredit*)credit;


#pragma mark -
#pragma mark Deleting.
+ (void) deleteObject:(id)object;


#pragma mark -
#pragma mark Fetch Request.
+ (NSFetchRequest*) fetchRequestForMoviesToDelete:(NSUInteger)numberOfWeeks;
+ (NSFetchRequest*) fetchRequestForNewsInBuffer;


#pragma mark Fetching.
+ (DANews*) newsWithCINeolID:(NSUInteger)ID;
+ (DAMovie*) movieWithCINeolID:(NSUInteger)ID;
+ (DAPerson*) personWithCINeolID:(NSUInteger)ID;
+ (DAPhoto*) photoWithCINeolID:(NSUInteger)ID;
+ (DATrailer*) trailerWithDailymotionID:(NSString*)ID;
+ (DAGenre*) genreWithName:(NSString*)genre;            // Siempre retorna un objeto válido.
                                                        // Si el género no existe, lo crea.

+ (NSArray*) arrayForNewsWithCINeolID:(NSUInteger)ID;
+ (NSArray*) arrayForMoviesWithCINeolID:(NSUInteger)ID;
+ (NSArray*) arrayForPersonsWithCINeolID:(NSUInteger)ID;
+ (NSArray*) arrayForPhotosWithCINeolID:(NSUInteger)ID;
+ (NSArray*) arrayForTrailersWithDailymotionID:(NSString*)ID;

+ (NSFetchedResultsController*) fetchedResultsForStoredMoviesSortedBy:(DAMovieSortCategory)category;
+ (NSFetchedResultsController*) fetchedResultsForMoviesShowtimes:(NSUInteger)numberOfWeeks
                                                        sortedBy:(DAMovieSortCategory)sortBy;

+ (NSFetchedResultsController*) fetchedResultsForNewsInBuffer;
+ (NSFetchedResultsController*) fetchedResultsForMoviesInBuffer;
+ (NSFetchedResultsController*) fetchedResultsForMoviesUsingSearchQuery:(NSString*)query;

#pragma mark Sort Descriptors.
+ (NSArray*) sortDescriptorsForPersons;
+ (NSArray*) sortDescriptorsForCasting;
+ (NSArray*) sortDescriptorsForCredits;
+ (NSArray*) sortDescriptorsForPhotos;
+ (NSArray*) sortDescriptorsForTrailers;
+ (NSArray*) sortDescriptorsForComments;
+ (NSArray*) sortDescriptorsForNews;
+ (NSArray*) sortDescriptorsForGenres;

+ (NSArray*) sortDescriptorsForSearchMovies;
+ (NSArray*) sortDescriptorsForMoviesBySortCategory:(DAMovieSortCategory)category;

@end