//
//  DACINeolManager.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolManager.h"

NSString *const DACINeolWillDownloadMovieNotification = @"DACINeolWillDownloadMovie";
NSString *const DACINeolWillDownloadSingleNewsNotification = @"DACINeolWillDownloadSingleNews";
NSString *const DACINeolWillDownloadNewsNotification = @"DACINeolWillDownloadNews";
NSString *const DACINeolWillDownloadMovieShowtimesNotification = @"DACINeolWillDownloadMovieShowtimes";
NSString *const DACINeolWillDownloadCommentsForMovieNotification = @"DACINeolWillDownloadCommentsForMovie";
NSString *const DACINeolWillDownloadImageNotification = @"DACINeolWillDownloadImage";

NSString *const DACINeolDidDownloadMovieNotification = @"DACINeolDidDownloadMovie";
NSString *const DACINeolDidDownloadSingleNewsNotification = @"DACINeolDidDownloadSingleNews";
NSString *const DACINeolDidDownloadNewsNotification = @"DACINeolDidDownloadNews";
NSString *const DACINeolDidDownloadMovieShowtimesNotification = @"DACINeolDidDownloadMovieShowtimes";
NSString *const DACINeolDidDownloadCommentsForMovieNotification = @"DACINeolDidDownloadCommentsForMovie";
NSString *const DACINeolDidDownloadImageNotification = @"DACINeolDidDownloadImage";

NSString *const DACINeolDidFailToDownloadMovieNotification = @"DACINeolDidFailToDownloadMovie";
NSString *const DACINeolDidFailToDownloadSingleNewsNotification = @"DACINeolDidFailToDownloadSingleNews";
NSString *const DACINeolDidFailToDownloadNewsNotification = @"DACINeolDidFailToDownloadNews";
NSString *const DACINeolDidFailToDownloadMovieShowtimesNotification = @"DACINeolDidFailToDownloadMovieShowtimes";
NSString *const DACINeolDidFailToDownloadDownloadCommentsForMovieNotification = @"DACINeolDidFailToDownloadCommentsForMovie";
NSString *const DACINeolDidFailToDownloadImageNotification = @"DACINeolDidFailToDownloadImage";

NSString *const DACINeolWillSearchMoviesNotification = @"DACINeolWillSearchMovies";
NSString *const DACINeolDidSearchMoviesNotification = @"DACINeolDidSearchMovies";
NSString *const DACINeolDidFailToSearchMoviesNotification = @"DACINeolDidFailToSearchMovies";


#pragma mark -
#pragma mark User Info Keys.
NSString *const DACINeolDownloadedDataUserInfoKey   = @"DACINeolDownloadedData";
NSString *const DACINeolErrorUserInfoKey            = @"DACINeolError"; 
NSString *const DACINeolDownloadTicketUserInfoKey   = @"DACINeolDownloadTicket"; 

NSString *const DACINeolMovieIDUserInfoKey          = @"DACINeolMovieID"; 
NSString *const DACINeolNewsIDUserInfoKey           = @"DACINeolMovieID"; 
NSString *const DACINeolImageIDUserInfoKey          = @"DACINeolImageID";  

NSString *const DACINeolNumberOfWeeksUserInfoKey    = @"DACINeolNumberOfWeeks"; 
NSString *const DACINeolNumberOfNewsUserInfoKey     = @"DACINeolNumberOfNews"; 
NSString *const DACINeolNumberOfCommentsUserInfoKey = @"DACINeolNumberOfComments"; 

NSString *const DACINeolImageURLUserInfoKey         = @"DACINeolImageURL"; 
NSString *const DACINeolImageSizeUserInfoKey        = @"DACINeolImageSize"; 
NSString *const DACINeolStartInCommentUserInfoKey   = @"DACINeolStartInComment";

NSString *const DACINeolSearchQueryUserInfoKey      = @"DACINeolSearchQuery"; 


#pragma mark -
#pragma mark API Web CINeol
NSString *const DACINeolURLBase = @"http://www.cineol.net/";

NSString *const DACINeolURLMovieWithID = @"http://www.cineol.net/api/peliculaxml.php?apiKey=%@&id=%d";
NSString *const DACINeolURLMovieShowtimes = @"http://www.cineol.net/api/estrenos.php?apiKey=%@&numWeeks=%i";
NSString *const DACINeolSearchMovies = @"http://www.cineol.net/xmltest.php?search=%@";

NSString *const DACINeolURLCommentsForMovie = @"http://www.cineol.net/api/getcomentarios.php?apiKey=%@&idpelicula=%d&start=%i&numero=%i";
NSString *const DACINeolURLNumberOfComments = @"http://www.cineol.net/api/getcomentarios.php?apiKey=%@&idpelicula=%d";

NSString *const DACINeolURLNews = @"http://www.cineol.net/api/getNoticiasPortada.php?apiKey=%@&numNoticias=%d";
NSString *const DACINeolURLNewsWithID = @"http://www.cineol.net/api/getNoticia.php?apiKey=%@&idNoticia=%d";

typedef enum {
    DACINeolSearchTypeSearchMovie = 0,
} DACINeolSearchType;

typedef enum {
    DACINeolDownloadTypeNews = 0,
    DACINeolDownloadTypeMovie,
} DACINeolDownloadType;

static DACINeolManager  *_singleton = nil;

@interface DACINeolManager ()

@property (nonatomic, retain) NSOperationQueue      *queue;
@property (nonatomic, retain) NSMutableDictionary   *currentDownloads;
@property (nonatomic, copy)   NSString              *APIKey;


- (NSString*) downloadTicketWithCINeolID:(NSUInteger)CINeolID
                          typeOfDownload:(DACINeolDownloadType)type;

- (NSString*) downloadTicketWithSearch:(NSString*)searchString
                          typeOfSearch:(DACINeolSearchType)type;

- (NSString*) searhWithQuery:(NSString*)searchStrinf
                    withType:(DACINeolSearchType)type
                withUserInfo:(NSMutableDictionary*)userInfo
     postingNotificationName:(NSString*)notificationName
       andPerformingSelector:(SEL)selector;

- (NSString*) downloadCINeolObjectWithID:(NSUInteger)CINeolID
                                withType:(DACINeolDownloadType)type
                            withUserInfo:(NSMutableDictionary*)userInfo
                 postingNotificationName:(NSString*)notificationName
                   andPerformingSelector:(SEL)selector;

- (void) willDownloadMovie:(NSDictionary*)userInfo;
- (void) didDownloadMovie:(NSDictionary*)userInfo;

- (void) willDownloadSingleNews:(NSDictionary*)userInfo;
- (void) didDownloadSingleNews:(NSDictionary*)userInfo;

- (void) willDownloadNews:(NSNumber*)numberOfNews;
- (void) didDownloadNews:(NSDictionary*)userInfo;

- (void) willDownloadMovieShowtimes:(NSNumber*)numberOfWeeks;
- (void) didDownloadMovieShowtimes:(NSDictionary*)userInfo;

- (void) willDownloadCommentsForMovie:(NSDictionary*)userInfo;
- (void) didDownloadCommentsForMovie:(NSDictionary*)userInfo;

- (void) willDownloadImage:(NSDictionary*)userInfo;
- (void) didDownloadImage:(NSDictionary*)userInfo;

- (void) willSearchMovies:(NSDictionary*)userInfo;
- (void) didSearchMovies:(NSDictionary*)userInfo;

- (void) runScript:(NSString*)script onFinishPerform:(SEL)selector withUserInfo:(NSDictionary*)userInfo;

- (void) postNotificationWithNameIfSuccess:(NSString*)success 
                                    ifFail:(NSString*)fail
                              withUserInfo:(NSDictionary*)userInfo;

@end


@implementation DACINeolManager

@synthesize queue               = _queue;
@synthesize APIKey              = _apiKey;
@synthesize currentDownloads    = _currentDownloads;

- (id) initWithAPIKey:(NSString*)apiKey {
    if (self = [super init]) {
        //self.queue = [[NSOperationQueue alloc] init];
        
        self.APIKey = apiKey;
        self.currentDownloads = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    return self;
}

#pragma mark -
#pragma mark Shared Manager.
+ (void) initializeSharedManagerWithAPIKey:(NSString*)key {    
    if (_singleton == nil) {
        _singleton = [[DACINeolManager alloc] initWithAPIKey:key];
        [_singleton retain];
    }
}

+ (DACINeolManager*) sharedManager {
    if (_singleton == nil) {
        NSException *exception = [NSException exceptionWithName:@"CINeol Shared Manager Exception"
                                                         reason:@"Shared Manager is nil. You must initialize"
                                                                " the manager with 'initializeSharedManagerWithAPIKey:'"
                                                       userInfo:nil];
        @throw exception;
    }
    
    return _singleton;
}


#pragma mark -
#pragma mark Public Methods.
- (NSString*) movieWithID:(NSUInteger) ID {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:ID], DACINeolMovieIDUserInfoKey, nil];
    
    NSString *downloadTicket = [self downloadCINeolObjectWithID:ID 
                                                       withType:DACINeolDownloadTypeMovie
                                                   withUserInfo:userInfo
                                        postingNotificationName:DACINeolWillDownloadMovieNotification
                                          andPerformingSelector:@selector(willDownloadMovie:)];
    [userInfo release];
        
    return downloadTicket;
}

- (NSString*) newsWithID:(NSUInteger)ID {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:ID], DACINeolNewsIDUserInfoKey, nil];
    
    NSString *downloadTicket = [self downloadCINeolObjectWithID:ID 
                                                       withType:DACINeolDownloadTypeNews
                                                   withUserInfo:userInfo
                                        postingNotificationName:DACINeolWillDownloadSingleNewsNotification
                                          andPerformingSelector:@selector(willDownloadSingleNews:)];
    [userInfo release];
    
    return downloadTicket;
}

- (NSString*) searchMovies:(NSString*)searchString {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     searchString, DACINeolSearchQueryUserInfoKey, nil];
    
    NSString *downloadTicket = [self searhWithQuery:searchString 
                                           withType:DACINeolSearchTypeSearchMovie
                                       withUserInfo:userInfo
                            postingNotificationName:DACINeolWillSearchMoviesNotification
                              andPerformingSelector:@selector(willSearchMovies:)];
    [userInfo release];
    
    return downloadTicket;    
}


- (void) news:(NSUInteger)numberOfNews {
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolWillDownloadNewsNotification
                                                        object:self];
    
    [self performSelectorInBackground:@selector(willDownloadNews:)
                           withObject:[NSNumber numberWithInteger:numberOfNews]];    
}

- (void) movieShowtimesForNumberOfWeeks:(NSUInteger)numberOfWeeks {
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolWillDownloadMovieShowtimesNotification
                                                        object:self];
    
    [self performSelectorInBackground:@selector(willDownloadMovieShowtimes:)
                           withObject:[NSNumber numberWithInteger:numberOfWeeks]];    
}

- (void) imageWithID:(NSUInteger)ID url:(NSString*)url size:(DACINeolImageSize)size {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInteger:ID], DACINeolImageIDUserInfoKey,
                                [NSNumber numberWithInteger:size], DACINeolImageSizeUserInfoKey,
                                url, DACINeolImageURLUserInfoKey, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolWillDownloadImageNotification
                                                        object:self
                                                      userInfo:dictionary];
    
    [self performSelectorInBackground:@selector(willDownloadImage:)
                           withObject:dictionary];    
    
    [dictionary release];
}

- (void) downloadComments:(NSUInteger)numberOfComments 
        startingInComment:(NSUInteger)initialComment 
                 forMovie:(NSUInteger)CINeolID
{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInteger:initialComment], DACINeolStartInCommentUserInfoKey,
                                [NSNumber numberWithInteger:numberOfComments], DACINeolNumberOfCommentsUserInfoKey,
                                [NSNumber numberWithInteger:CINeolID], DACINeolMovieIDUserInfoKey, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolWillDownloadCommentsForMovieNotification
                                                        object:self
                                                      userInfo:dictionary];
    
    [self performSelectorInBackground:@selector(willDownloadCommentsForMovie:)
                           withObject:dictionary]; 
    
    [dictionary release];
}

- (NSInteger) numberOfCommentsForMovieWithID:(NSUInteger)movieCINeolID {
    NSURL *URL = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:DACINeolURLNumberOfComments, _apiKey, movieCINeolID]];
    
    NSString *data = [[NSString alloc] initWithContentsOfURL:URL];
    NSScanner *scanner = [[NSScanner alloc] initWithString:data];
    NSString *result = nil;
    
    [scanner scanUpToString:@"TotalPosts=\"" intoString:NULL];
    [scanner scanUpToString: @"\"/" intoString: &result];
    
    result = [result stringByTrimmingCharactersInSet:
              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    
    [scanner release];
    [data release];
    [URL release];

    return [result integerValue];
}


#pragma mark -
#pragma mark Private Methods
- (NSString*) downloadTicketWithCINeolID:(NSUInteger)CINeolID
                          typeOfDownload:(DACINeolDownloadType)type
{
    return [NSString stringWithFormat:@"%i-%i", type, CINeolID];
}

- (NSString*) downloadTicketWithSearch:(NSString*)searchString
                          typeOfSearch:(DACINeolSearchType)type
{
    return [NSString stringWithFormat:@"%i-%@", type, searchString];
}

- (NSString*) downloadCINeolObjectWithID:(NSUInteger)CINeolID
                                withType:(DACINeolDownloadType)type
                            withUserInfo:(NSMutableDictionary*)userInfo
                 postingNotificationName:(NSString*)notificationName
                   andPerformingSelector:(SEL)selector
{
    NSString *key = [self downloadTicketWithCINeolID:CINeolID typeOfDownload:type];
    
    if ([_currentDownloads objectForKey:key] != nil)
        return key;
    
    [userInfo setObject:key forKey:DACINeolDownloadTicketUserInfoKey];
    
    // Añadimos la peticion a la lista de descargas.
    [_currentDownloads setObject:userInfo forKey:key];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:userInfo];
    [self performSelectorInBackground:selector
                           withObject:userInfo];
    return key;
}

- (NSString*) searhWithQuery:(NSString*)searchString
                    withType:(DACINeolSearchType)type
                withUserInfo:(NSMutableDictionary*)userInfo
     postingNotificationName:(NSString*)notificationName
       andPerformingSelector:(SEL)selector
{
    NSString *key = [self downloadTicketWithSearch:searchString typeOfSearch:type];
    
    if ([_currentDownloads objectForKey:key] != nil)
        return key;
    
    [userInfo setObject:key forKey:DACINeolDownloadTicketUserInfoKey];
    
    // Añadimos la peticion a la lista de descargas.
    [_currentDownloads setObject:userInfo forKey:key];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:userInfo];
    [self performSelectorInBackground:selector
                           withObject:userInfo];
    return key;
}


#pragma mark -
#pragma mark "Will Download..." Methods.
- (void) willDownloadMovie:(NSDictionary*)userInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *script = [NSString stringWithFormat:DACINeolURLMovieWithID, _apiKey,
                        [[userInfo objectForKey:DACINeolMovieIDUserInfoKey] integerValue]]; 

    [self runScript:script
    onFinishPerform:@selector(didDownloadMovie:)
       withUserInfo:userInfo];
    
    [pool drain];
}

- (void) willDownloadSingleNews:(NSDictionary*)userInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *script = [NSString stringWithFormat:DACINeolURLNewsWithID, _apiKey, 
                        [[userInfo objectForKey:DACINeolNewsIDUserInfoKey] integerValue]];  
            
    [self runScript:script
    onFinishPerform:@selector(didDownloadSingleNews:)
       withUserInfo:userInfo];
    
    [pool drain];
}

- (void) willDownloadNews:(NSNumber*)numberOfNews {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *script = [NSString stringWithFormat:DACINeolURLNews, _apiKey, [numberOfNews integerValue]];   
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              numberOfNews, DACINeolNumberOfNewsUserInfoKey, nil];
    
    [self runScript:script
    onFinishPerform:@selector(didDownloadNews:)
       withUserInfo:userInfo];
    
    [userInfo release];
    [pool drain];    
}

- (void) willDownloadMovieShowtimes:(NSNumber*)numberOfWeeks {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *script = [NSString stringWithFormat:DACINeolURLMovieShowtimes, _apiKey, [numberOfWeeks integerValue]];   

    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              numberOfWeeks, DACINeolNumberOfWeeksUserInfoKey, nil];
    
    [self runScript:script
    onFinishPerform:@selector(didDownloadMovieShowtimes:)
       withUserInfo:userInfo];
    
    [userInfo release];
    [pool drain];    
}


- (void) willDownloadCommentsForMovie:(NSDictionary*)userInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *script = [NSString stringWithFormat:DACINeolURLCommentsForMovie, _apiKey,
                        [[userInfo objectForKey:DACINeolMovieIDUserInfoKey] integerValue],
                        [[userInfo objectForKey:DACINeolStartInCommentUserInfoKey] integerValue],
                        [[userInfo objectForKey:DACINeolNumberOfCommentsUserInfoKey] integerValue]];
    
    [self runScript:script
    onFinishPerform:@selector(didDownloadCommentsForMovie:)
       withUserInfo:userInfo];
    
    [pool drain];
}

- (void) willDownloadImage:(NSDictionary*)userInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self runScript:[userInfo objectForKey:DACINeolImageURLUserInfoKey]
    onFinishPerform:@selector(didDownloadImage:)
       withUserInfo:userInfo];
    
    [pool drain];
}

- (void) willSearchMovies:(NSDictionary*)userInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *script = [NSString stringWithFormat:DACINeolSearchMovies,
                        [userInfo objectForKey:DACINeolSearchQueryUserInfoKey]];
        
    [self runScript:script
    onFinishPerform:@selector(didSearchMovies:)
       withUserInfo:userInfo];
    
    [pool drain];    
}


#pragma mark -
#pragma mark "Did Download..." Mehods.
- (void) didDownloadMovie:(NSDictionary*)userInfo {    
    [self postNotificationWithNameIfSuccess:DACINeolDidDownloadMovieNotification
                                     ifFail:DACINeolDidFailToDownloadMovieNotification
                               withUserInfo:userInfo];
}

- (void) didDownloadSingleNews:(NSDictionary*)userInfo {
    
    
    [self postNotificationWithNameIfSuccess:DACINeolDidDownloadSingleNewsNotification
                                     ifFail:DACINeolDidFailToDownloadSingleNewsNotification
                               withUserInfo:userInfo];
}

- (void) didDownloadNews:(NSDictionary*)userInfo {
    [self postNotificationWithNameIfSuccess:DACINeolDidDownloadNewsNotification
                                     ifFail:DACINeolDidFailToDownloadNewsNotification
                               withUserInfo:userInfo];
}

- (void) didDownloadMovieShowtimes:(NSDictionary*)userInfo {    
    [self postNotificationWithNameIfSuccess:DACINeolDidDownloadMovieShowtimesNotification
                                     ifFail:DACINeolDidFailToDownloadMovieShowtimesNotification
                               withUserInfo:userInfo];
}

- (void) didDownloadCommentsForMovie:(NSDictionary*)userInfo {
    [self postNotificationWithNameIfSuccess:DACINeolDidDownloadCommentsForMovieNotification
                                     ifFail:DACINeolDidFailToDownloadDownloadCommentsForMovieNotification
                               withUserInfo:userInfo];
}

- (void) didDownloadImage:(NSDictionary*)userInfo {
    [self postNotificationWithNameIfSuccess:DACINeolDidDownloadImageNotification
                                     ifFail:DACINeolDidFailToDownloadImageNotification
                               withUserInfo:userInfo];
}

- (void) didSearchMovies:(NSDictionary*)userInfo {
    [self postNotificationWithNameIfSuccess:DACINeolDidSearchMoviesNotification
                                     ifFail:DACINeolDidFailToSearchMoviesNotification
                               withUserInfo:userInfo];    
}


#pragma mark -
#pragma mark Run Script.
- (void) runScript:(NSString*)script onFinishPerform:(SEL)selector withUserInfo:(NSDictionary*)userInfo
{        
    NSData *data = nil;
    NSError *error = nil;
    
    script = [script stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (script != nil) {
        NSURL *url = [[NSURL alloc] initWithString:script];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        data = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:NULL 
                                                 error:&error];
        [url release];
        [request release];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:userInfo];

    if (data == nil) {
        [dictionary setObject:error forKey:DACINeolErrorUserInfoKey];
        [FlurryAPI logError:DAFlurryErrorCINeolManager message:script error:error];
    }
    else
        [dictionary setObject:data forKey:DACINeolDownloadedDataUserInfoKey];
    
    [self performSelectorOnMainThread:selector
                           withObject:dictionary
                        waitUntilDone:NO];

    [dictionary release];    
}

#pragma mark -
#pragma mark Posting Notifications.
- (void) postNotificationWithNameIfSuccess:(NSString*)success 
                                    ifFail:(NSString*)fail
                              withUserInfo:(NSDictionary*)userInfo
{
    NSString *key = [userInfo objectForKey:DACINeolDownloadTicketUserInfoKey];
    
    if (key)
        [self.currentDownloads removeObjectForKey:key];

    if ([userInfo objectForKey:DACINeolDownloadedDataUserInfoKey])
        [[NSNotificationCenter defaultCenter] postNotificationName:success
                                                            object:self
                                                          userInfo:userInfo];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:fail
                                                            object:self
                                                          userInfo:userInfo];
}


#pragma mark -
#pragma mark Memory Management.
- (void) dealloc {
    [_queue release];               _queue = nil;
    [_currentDownloads release];    _currentDownloads = nil;
    [_apiKey release];              _apiKey = nil;
    [super dealloc];
}

@end