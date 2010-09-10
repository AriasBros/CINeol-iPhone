//
//  DACINeolFacade.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "DACINeolFacade.h"
#import "DACoreDataManager.h"

#import "DAMovie.h"
#import "DANews.h"
#import "DAPerson.h"
#import "DACredit.h"
#import "DAPhoto.h"
#import "DAComment.h"
#import "DAGenre.h"

#define kURLDailymotion @"http://iphone.dailymotion.com/video/"

#define NUMBER_OF_COMMENTS_FOR_PAGE 15

@interface DACINeolFacade (Private)

/** UTILS **/
+ (NSString*) HTMLTemplateWithName:(NSString*)name;
+ (void) presentMailComposeViewControllerInController:(UIViewController *)parentController
                                              subject:(NSString*)subject
                                              message:(NSString*)message;

/** DATABASE **/
+ (id) objectForEntityWithName:(NSString*)name;

+ (void) insertObject:(id)object;
+ (void) deleteObject:(id)object;

+ (NSFetchRequest*) fetchRequestWithName:(NSString*)name 
                               variables:(NSDictionary*)variables
                         sortDescriptors:(NSArray*)descriptors;

+ (NSArray*) arrayForRequestWithName:(NSString*)name sortDescriptors:(NSArray*)descriptors;

+ (NSArray*) arrayForRequestWithName:(NSString*)name 
                           variables:(NSDictionary*)variables
                     sortDescriptors:(NSArray*)descriptors;

+ (NSFetchedResultsController*) fetchedResultsForRequestWithName:(NSString*) name 
                                                       variables:(NSDictionary*)variables
                                                 sortDescriptors:(NSArray*) descriptors
                                              sectionNameKeyPath:(NSString*)sectionNameKeyPath;

+ (NSArray*) sortDescriptorsForMoviesByTitle;
+ (NSArray*) sortDescriptorsForMoviesByDatePremier;
+ (NSArray*) sortDescriptorsForMoviesByDuration;
+ (NSArray*) sortDescriptorsForMoviesByGenre;
+ (NSArray*) sortDescriptorsForMoviesByRating;

@end

@implementation DACINeolFacade


#pragma mark -
#pragma mark Utils.
+ (void) openURLOnSafari:(NSString*)url {
    NSURL *URL = [NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding: 
                                        NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL: URL];
}

+ (NSURL*) URLForDailymotionVideoWithVideoID:(NSString*)dailymotionID {
    NSURL *url = [NSURL URLWithString: [kURLDailymotion stringByAppendingString:dailymotionID]];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    NSData *data = [NSURLConnection sendSynchronousRequest: request 
                                         returningResponse: nil
                                                     error: nil];
    
    NSString *info = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    NSScanner *scanner = [NSScanner scannerWithString: info];
    [scanner scanUpToString: @"http://iphone" intoString: NULL];
    [scanner scanUpToString: @"\""            intoString: &info];
    
    url = [NSURL URLWithString: info];
    
    return url;
}

+ (void) presentMailComposeViewControllerInController:(UIViewController*)parentController
                                                 news:(DANews*)news
{    
    NSString *template = [DACINeolFacade HTMLTemplateWithName:@"news-mail-template"]; 
    
    NSString *subtitle = @"";
    if (news.author != nil)
        subtitle = [news.dateString stringByAppendingFormat:@" - Por %@", news.author];
    
    NSString *photo = @"http://www.cineol.net/galeria/carteles/nada.jpg";
    if (news.photo.photoURL != nil)
        photo = news.photo.photoURL;
    
    NSString *HTML = [[NSString alloc] initWithFormat:template,
                      photo,
                      news.title,
                      subtitle,
                      news.introduction,
                      news.CINeolURL];
    
    [DACINeolFacade presentMailComposeViewControllerInController:parentController
                                                         subject:news.title
                                                         message:HTML];

    [HTML release];
}

+ (void) presentMailComposeViewControllerInController:(UIViewController*)parentController
                                                movie:(DAMovie*)movie
{
    NSString *template = [DACINeolFacade HTMLTemplateWithName:@"movie-mail-template"];
    NSString *votes = [NSString stringWithFormat:@"%i votos", movie.numberOfVotes];
    if (movie.numberOfVotes == 1)
        votes = [NSString stringWithFormat:@"%i voto", movie.numberOfVotes];
    
    NSString *duration_rating_votes = [NSString stringWithFormat:
                                       @"%i min. | %0.2f/%i | %@",
                                       movie.duration, movie.rating, 10, votes];
    
    NSString *photo = @"http://www.cineol.net/galeria/carteles/nada.jpg";
    if (movie.poster.thumbnailURL != nil)
        photo = movie.poster.thumbnailURL;
    
    NSString *date = movie.datePremierSpainText;
    if (date == nil)
        date = [NSString stringWithFormat:@"%i", movie.year];
    
    NSString *HTML = [[NSString alloc] initWithFormat:template,
                      photo,
                      movie.title,
                      movie.genre,
                      duration_rating_votes,
                      date,
                      movie.synopsis,
                      movie.CINeolURL];    
    
    [DACINeolFacade presentMailComposeViewControllerInController:parentController
                                                         subject:movie.title
                                                         message:HTML];
    
    [HTML release];
}

+ (void) addPosterWithThumbnailURL:(NSString*)thumbnailURL 
                           toMovie:(DAMovie*)movie 
         usingManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
                       insertMovie:(BOOL)insertMovie
{
    DAPhoto *poster = [DACINeolFacade photo];
    
    UIImage *image = nil;
    if (thumbnailURL != nil) {
        NSURL *url = [[NSURL alloc] initWithString:thumbnailURL];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                             returningResponse:NULL
                                                         error:NULL];
        [url release];
        [request release];
        
        image = [UIImage imageWithData:data];
    }
    
    if (image == nil) {
        poster.thumbnailURL = nil;
        poster.thumbnail = nil;
    }
    else {
        poster.thumbnailURL = thumbnailURL;
        poster.thumbnail = image;
    }

    poster.photoID = movie.CINeolID; 
    
    if (insertMovie)
        [managedObjectContext insertObject:movie];        
    
    [managedObjectContext insertObject:poster];
    
    movie.poster = poster;
}

+ (NSString*) nameForMovieSortCategory:(DAMovieSortCategory)category {
    switch (category) {
        case DAMovieSortByPremierDate:
            return @"Fecha de estreno";

        case DAMovieSortByTitle:
            return @"Título";
            
        case DAMovieSortByDuration:
            return @"Duración";
            
        case DAMovieSortByRating:
            return @"Puntuación";
            
        case DAMovieSortByGenre:
            return @"Género";
    }
    
    return nil;
}


#pragma mark -
#pragma mark Creating.
+ (DAMovie*) movie {
    return [DACINeolFacade objectForEntityWithName:@"DAMovie"];
}

+ (DANews*) news {
    return [DACINeolFacade objectForEntityWithName:@"DANews"];
}

+ (DAGenre*) genreWithName:(NSString*)name {    
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               name, @"NAME", nil];
    
    NSArray *array = [DACINeolFacade arrayForRequestWithName:@"GenreWithName"
                                                   variables:variables
                                             sortDescriptors:[DACINeolFacade sortDescriptorsForGenres]]; 
    
    if ([array count] > 0)
        return [array objectAtIndex:0];
    else {
        DAGenre *genre = [DACINeolFacade objectForEntityWithName:@"DAGenre"];
        genre.name = name;
        
        [DACINeolFacade insertObject:genre];
        
        return genre;
    }    
}

+ (DAPhoto*) photo {
    return [DACINeolFacade objectForEntityWithName:@"DAPhoto"];
}

+ (DATrailer*) trailer {
    return [DACINeolFacade objectForEntityWithName:@"DATrailer"];
}

+ (DAPerson*) person {
    return [DACINeolFacade objectForEntityWithName:@"DAPerson"];
}

+ (DACredit*) credit {
    return [DACINeolFacade objectForEntityWithName:@"DACredit"];
}

+ (DAComment*) comment {
    return [DACINeolFacade objectForEntityWithName:@"DAComment"];    
}


#pragma mark -
#pragma mark Inserting.
+ (void) insertMovie:(DAMovie*)movie {
    [DACINeolFacade insertObject:movie];
}

+ (void) insertNews:(DANews*)news {
    [DACINeolFacade insertObject:news];
}

+ (void) insertTrailer:(DATrailer*)trailer {
    [DACINeolFacade insertObject:trailer];
}

+ (void) insertPhoto:(DAPhoto*)photo {
    [DACINeolFacade insertObject:photo];
}

+ (void) insertPerson:(DAPerson*)person {
    [DACINeolFacade insertObject:person];
}

+ (void) insertCredit:(DACredit*)credit {
    [DACINeolFacade insertObject:credit];
}


#pragma mark -
#pragma mark Deleting.
+ (void) deleteNews:(DANews*)news {
    [DACINeolFacade deleteObject:news];
}


#pragma mark -
#pragma mark Fetch Requests.
+ (NSFetchRequest*) fetchRequestForMoviesToDelete:(NSUInteger)numberOfWeeks {
    NSDate *weeks = [[DACalendar defaultCalendar] dateForNthWeeksAgo:numberOfWeeks];
    NSDictionary *variables = [[NSDictionary alloc] initWithObjectsAndKeys:weeks,@"WEEKS",nil];
    
    NSFetchRequest *request = [self fetchRequestWithName:@"MoviesForDelete" 
                                               variables:variables
                                         sortDescriptors:[self sortDescriptorsForMoviesByTitle]];
    
    [variables release];
    
    return request;
}

+ (NSFetchRequest*) fetchRequestForNewsInBuffer {    
    return [self fetchRequestWithName:@"NewsInBuffer" 
                            variables:nil
                      sortDescriptors:[self sortDescriptorsForNews]];    
}

+ (NSFetchRequest*) fetchRequestWithName:(NSString*)name 
                               variables:(NSDictionary*)variables
                         sortDescriptors:(NSArray*)descriptors
{
    NSFetchRequest *request = nil;
    if (variables == nil) {
        request = [[[DACoreDataManager sharedManager] managedObjectModel]
                   fetchRequestTemplateForName: name];
    }
    else {
        request = [[[DACoreDataManager sharedManager] managedObjectModel]
                   fetchRequestFromTemplateWithName:name substitutionVariables:variables];  
    }
    
    [request setSortDescriptors: descriptors];
    
    return request;
}

#pragma mark -
#pragma mark Fetching.
+ (DANews*) newsWithCINeolID:(NSUInteger)ID {
    NSArray *array = [DACINeolFacade arrayForNewsWithCINeolID: ID];

    if ([array count] > 0)
        return [array objectAtIndex:0];

    return nil;
}

+ (DAMovie*) movieWithCINeolID:(NSUInteger)ID {
    NSArray *array = [DACINeolFacade arrayForMoviesWithCINeolID:ID];
    
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;
}

+ (DAPerson*) personWithCINeolID:(NSUInteger)ID {
    NSArray *array = [DACINeolFacade arrayForPersonsWithCINeolID:ID];
    
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;    
}

+ (DAPhoto*) photoWithCINeolID:(NSUInteger)ID {
    NSArray *array = [DACINeolFacade arrayForPhotosWithCINeolID:ID];
    
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;      
}

+ (DATrailer*) trailerWithDailymotionID:(NSString*)ID {
    NSArray *array = [DACINeolFacade arrayForTrailersWithDailymotionID:ID];
    
    if ([array count] > 0)
        return [array objectAtIndex:0];
    
    return nil;    
}


+ (NSArray*) arrayForNewsWithCINeolID:(NSUInteger)ID {
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:ID], @"ID", nil];
    
    return [DACINeolFacade arrayForRequestWithName: @"NewsWithCINeolID"
                                         variables: variables
                                   sortDescriptors: [DACINeolFacade sortDescriptorsForNews]]; 
}

+ (NSArray*) arrayForMoviesWithCINeolID:(NSUInteger)ID {
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:ID], @"ID", nil];
    
    return [DACINeolFacade arrayForRequestWithName: @"MoviesWithCINeolID"
                                         variables: variables
                                   sortDescriptors: [DACINeolFacade sortDescriptorsForMoviesByTitle]];    
}

+ (NSArray*) arrayForPersonsWithCINeolID:(NSUInteger)ID {
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:ID], @"ID", nil];
    
    return [DACINeolFacade arrayForRequestWithName: @"PersonsWithCINeolID"
                                         variables: variables
                                   sortDescriptors: [DACINeolFacade sortDescriptorsForPersons]];      
}

+ (NSArray*) arrayForPhotosWithCINeolID:(NSUInteger)ID {
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:ID], @"ID", nil];
    
    return [DACINeolFacade arrayForRequestWithName: @"PhotosWithPhotoID"
                                         variables: variables
                                   sortDescriptors: [DACINeolFacade sortDescriptorsForPhotos]];      
}

+ (NSArray*) arrayForTrailersWithDailymotionID:(NSString*)ID {
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:ID, @"ID", nil];
    
    return [DACINeolFacade arrayForRequestWithName: @"TrailersWithDailymotionID"
                                         variables: variables
                                   sortDescriptors: [DACINeolFacade sortDescriptorsForTrailers]];        
}

+ (NSFetchedResultsController*) fetchedResultsForNewsInBuffer {
    return [DACINeolFacade fetchedResultsForRequestWithName:@"NewsInBuffer"
                                                  variables:nil
                                            sortDescriptors:[DACINeolFacade sortDescriptorsForNews]
                                         sectionNameKeyPath:nil];
}

+ (NSFetchedResultsController*) fetchedResultsForMoviesInBuffer {
    return [DACINeolFacade fetchedResultsForRequestWithName:@"MoviesInBuffer"
                                                  variables:nil
                                            sortDescriptors:[DACINeolFacade sortDescriptorsForMoviesByTitle]
                                         sectionNameKeyPath:nil];     
}

+ (NSFetchedResultsController*) fetchedResultsForStoredMoviesSortedBy:(DAMovieSortCategory)category {
    NSArray  *sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesBySortCategory:category];

    return [DACINeolFacade fetchedResultsForRequestWithName:@"StoredMovies"
                                                  variables:nil
                                            sortDescriptors:sortDescriptors
                                         sectionNameKeyPath:nil];     
}

+ (NSFetchedResultsController*) fetchedResultsForMoviesShowtimes:(NSUInteger)numberOfWeeks
                                                        sortedBy:(DAMovieSortCategory)category
{    
    NSDate *nextWeek = [[DACalendar defaultCalendar] dateForNthWeeksFromToday:1];
    NSDate *pastWeeks = [[DACalendar defaultCalendar] dateForNthWeeksAgo:numberOfWeeks];
    
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               nextWeek, @"NEXTWEEK", pastWeeks, @"PASTWEEKS",  nil];
    
    NSArray  *sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesBySortCategory:category];
    NSString *sectionNameKeyPath = nil;
    if (category == DAMovieSortByPremierDate)
        sectionNameKeyPath = @"isPremier";
    
    return [DACINeolFacade fetchedResultsForRequestWithName:@"MovieShowtimes"
                                                  variables:variables
                                            sortDescriptors:sortDescriptors
                                         sectionNameKeyPath:sectionNameKeyPath];
}

+ (NSFetchedResultsController*) fetchedResultsForMoviesUsingSearchQuery:(NSString*)query {
    NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:query, @"QUERY", nil];
    
    return [DACINeolFacade fetchedResultsForRequestWithName:@"SearchMoviesByTitle"
                                                  variables:variables
                                            sortDescriptors:[DACINeolFacade sortDescriptorsForMoviesByTitle]
                                         sectionNameKeyPath:nil]; 
}


#pragma mark -
#pragma mark Private Methods.
+ (NSString*) HTMLTemplateWithName:(NSString*)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


+ (void) presentMailComposeViewControllerInController:(UIViewController<MFMailComposeViewControllerDelegate>*)parentController
                                              subject:(NSString*)subject
                                              message:(NSString*)message
{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = parentController;
    mail.navigationBar.tintColor = parentController.navigationController.navigationBar.tintColor;
    
    [mail setSubject:subject];
    [mail setMessageBody:message isHTML:YES];
    
    [parentController presentModalViewController:mail animated:YES];
    
    [mail release];
}

+ (id) objectForEntityWithName:(NSString*)name {
    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:[[DACoreDataManager sharedManager] 
                                                                      managedObjectContext]];
    return [[[NSManagedObject alloc] initWithEntity: entity
                     insertIntoManagedObjectContext: nil] autorelease]; 
}

+ (void) insertObject:(id)object {
    [[[DACoreDataManager sharedManager] managedObjectContext] insertObject:object];
    [[[DACoreDataManager sharedManager] managedObjectContext] save:NULL];
}

+ (void) deleteObject:(id)object {
    [[[DACoreDataManager sharedManager] managedObjectContext] deleteObject:object];
    [[[DACoreDataManager sharedManager] managedObjectContext] save:NULL];
}

+ (NSArray*) arrayForRequestWithName:(NSString*)name sortDescriptors:(NSArray*) descriptors {
    
    NSFetchRequest *request = [[[DACoreDataManager sharedManager] managedObjectModel]
                               fetchRequestTemplateForName: name];
    
    [request setSortDescriptors:descriptors];

    return [[[DACoreDataManager sharedManager] managedObjectContext]
            executeFetchRequest: request error: NULL]; 
}

+ (NSArray*) arrayForRequestWithName:(NSString*)name 
                           variables: (NSDictionary*)variables
                     sortDescriptors: (NSArray*) descriptors
{
    NSFetchRequest *request = [[[DACoreDataManager sharedManager] managedObjectModel]
                               fetchRequestFromTemplateWithName: name 
                               substitutionVariables: variables];  
    [request setSortDescriptors: descriptors];

    return [[[DACoreDataManager sharedManager] managedObjectContext]
            executeFetchRequest: request error: NULL];
}


+ (NSFetchedResultsController*) fetchedResultsForRequestWithName:(NSString*)name 
                                                       variables:(NSDictionary*)variables
                                                 sortDescriptors:(NSArray*)descriptors
                                              sectionNameKeyPath:(NSString*)sectionNameKeyPath
{
    NSFetchRequest *request = [self fetchRequestWithName:name
                                               variables:variables
                                         sortDescriptors:descriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc]
                                                              initWithFetchRequest: request
                                                              managedObjectContext: [[DACoreDataManager sharedManager] managedObjectContext]
                                                              sectionNameKeyPath:sectionNameKeyPath 
                                                              cacheName: name] autorelease];    
    @try {
        [aFetchedResultsController performFetch: NULL];
    }
    @catch (NSException *e) {
        [NSFetchedResultsController deleteCacheWithName:name];
        [aFetchedResultsController performFetch: NULL];
        
        [FlurryAPI logError:DAFlurryErrorPerformFetch 
                    message:@"Error performing fetch" 
                  exception:e];
    }
    @finally {
        
    }
    
    return aFetchedResultsController;
}

+ (NSArray*) sortDescriptorsForNews {
    /*
     
    No añado la fecha a los descriptores debido a que no la sabemos hasta que una noticia
    es abierta por primera vez, haciendo que cuando abrimos una noticia por primera vez
    esta pase a ser la primera en la lista (ya que las demas tienen nil en la fecha).
     
    NSSortDescriptor *sortByDate = [[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                ascending:NO] autorelease]; 
    */
    
    NSSortDescriptor *sortByCINeolID = [[[NSSortDescriptor alloc] initWithKey:@"CINeolID"
                                                                ascending:NO] autorelease];    
    
	return [NSArray arrayWithObjects:sortByCINeolID, nil];
}

+ (NSArray*) sortDescriptorsForTrailers {
    NSSortDescriptor *sortByDate = [[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                ascending:YES] autorelease];  
    
    NSSortDescriptor *sortByDesc = [[[NSSortDescriptor alloc] initWithKey:@"desc"
                                                                ascending:YES] autorelease];    
    
	return [NSArray arrayWithObjects:sortByDate, sortByDesc, nil];    
}

+ (NSArray*) sortDescriptorsForPersons {
    NSSortDescriptor *sortByName = [[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                ascending:NO] autorelease];    
    
	return [NSArray arrayWithObjects: sortByName, nil];    
}

+ (NSArray*) sortDescriptorsForCasting {
    NSSortDescriptor *sortByJob = [[NSSortDescriptor alloc] initWithKey:@"job"
                                                              ascending:YES];    
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"person.name"
                                                               ascending:YES];
    
    NSArray *array = [NSArray arrayWithObjects:sortByName, sortByJob, nil];
    
    [sortByName release];
    [sortByJob release];
    
	return array;
}

+ (NSArray*) sortDescriptorsForCredits {
    NSSortDescriptor *sortByType = [[[NSSortDescriptor alloc] initWithKey:@"type"
                                                                ascending:YES] autorelease];    
    
    NSSortDescriptor *sortByName = [[[NSSortDescriptor alloc] initWithKey:@"person.name"
                                                                ascending:YES] autorelease];
    
	return [NSArray arrayWithObjects: sortByType, sortByName, nil];    
}

+ (NSArray*) sortDescriptorsForPhotos {
    NSSortDescriptor *sortByCINeolPhotoID = [[[NSSortDescriptor alloc] initWithKey:@"photoID"
                                                                         ascending:NO] autorelease];    
    
	return [NSArray arrayWithObjects: sortByCINeolPhotoID, nil];     
}

+ (NSArray*) sortDescriptorsForComments {
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                               ascending:YES];   
    
    NSArray *array = [NSArray arrayWithObjects: sortByDate, nil];
    
    [sortByDate release];
    
	return array;     
}

+ (NSArray*) sortDescriptorsForGenres {
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                               ascending:YES];   
    
    NSArray *array = [NSArray arrayWithObjects: sortByName, nil];
    
    [sortByName release];
    
	return array;     
}


#pragma mark -
#pragma mark Movies Sort Descriptors.
+ (NSArray*) sortDescriptorsForMoviesBySortCategory:(DAMovieSortCategory)category {
    NSArray  *sortDescriptors = nil;
    if (category == DAMovieSortByPremierDate) {
        sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesByDatePremier];
    }
    else if (category == DAMovieSortByTitle) {
        sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesByTitle];
    }
    else if (category == DAMovieSortByDuration) {
        sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesByDuration];
    }
    else if (category == DAMovieSortByGenre) {
        sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesByGenre];
    }
    else if (category == DAMovieSortByRating) {
        sortDescriptors = [DACINeolFacade sortDescriptorsForMoviesByRating];
    }
    
    return sortDescriptors;
}

+ (NSArray*) sortDescriptorsForMoviesByTitle {    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                               ascending:YES]; 
    NSArray *array = [NSArray arrayWithObjects:sortByName, nil];
    [sortByName release];
    
	return array;
}

+ (NSArray*) sortDescriptorsForMoviesByDatePremier {
    NSSortDescriptor *sortByDatePremier = [[NSSortDescriptor alloc] initWithKey:@"datePremierSpain"
                                                                    ascending:NO]; 
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                            ascending:YES]; 
    
    NSArray *array = [NSArray arrayWithObjects: sortByDatePremier, sortByName, nil];
    
    [sortByDatePremier release];
    [sortByName release];
    
	return array;
}

+ (NSArray*) sortDescriptorsForSearchMovies {
    NSSortDescriptor *sortByYear = [[NSSortDescriptor alloc] initWithKey:@"year"
                                                               ascending:YES]; 
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"indexTitle"
                                                               ascending:YES]; 
    
    NSArray *array = [NSArray arrayWithObjects: sortByName, sortByYear, nil];
    
    [sortByYear release];
    [sortByName release];
    
	return array;    
}

+ (NSArray*) sortDescriptorsForMoviesByDuration {
    NSSortDescriptor *sortByDuration = [[NSSortDescriptor alloc] initWithKey:@"duration"
                                                                   ascending:NO]; 
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                               ascending:YES]; 
    
    NSArray *array = [NSArray arrayWithObjects: sortByDuration, sortByName, nil];
    
    [sortByDuration release];
    [sortByName release];
    
	return array;
}

+ (NSArray*) sortDescriptorsForMoviesByGenre {
    NSSortDescriptor *sortByGenre = [[NSSortDescriptor alloc] initWithKey:@"genre"
                                                                   ascending:NO]; 
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                               ascending:YES]; 
    
    NSArray *array = [NSArray arrayWithObjects: sortByGenre, sortByName, nil];
    
    [sortByGenre release];
    [sortByName release];
    
	return array;
}

+ (NSArray*) sortDescriptorsForMoviesByRating {
    NSSortDescriptor *sortByRating = [[NSSortDescriptor alloc] initWithKey:@"rating"
                                                                ascending:NO]; 
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                               ascending:YES]; 
    
    NSArray *array = [NSArray arrayWithObjects: sortByRating, sortByName, nil];
    
    [sortByRating release];
    [sortByName release];
    
	return array;    
}





@end