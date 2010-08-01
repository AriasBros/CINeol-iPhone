//
//  DACINeolManager.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** CINeol URL Base **/
NSString *const DACINeolURLBase;


/** Notifications **/
NSString *const DACINeolWillDownloadMovieNotification;
NSString *const DACINeolWillDownloadSingleNewsNotification;
NSString *const DACINeolWillDownloadNewsNotification;
NSString *const DACINeolWillDownloadMovieShowtimesNotification;
NSString *const DACINeolWillDownloadImageNotification;
NSString *const DACINeolWillDownloadCommentsForMovieNotification;

NSString *const DACINeolDidDownloadMovieNotification;
NSString *const DACINeolDidDownloadSingleNewsNotification;
NSString *const DACINeolDidDownloadNewsNotification;
NSString *const DACINeolDidDownloadMovieShowtimesNotification;
NSString *const DACINeolDidDownloadImageNotification;
NSString *const DACINeolDidDownloadCommentsForMovieNotification;

NSString *const DACINeolDidFailToDownloadMovieNotification;
NSString *const DACINeolDidFailToDownloadSingleNewsNotification;
NSString *const DACINeolDidFailToDownloadNewsNotification;
NSString *const DACINeolDidFailToDownloadMovieShowtimesNotification;
NSString *const DACINeolDidFailToDownloadImageNotification;
NSString *const DACINeolDidFailToDownloadDownloadCommentsForMovieNotification;

NSString *const DACINeolWillSearchMoviesNotification;
NSString *const DACINeolDidSearchMoviesNotification;
NSString *const DACINeolDidFailToSearchMoviesNotification;


/** User Info Keys **/
NSString *const DACINeolDownloadedDataUserInfoKey;
NSString *const DACINeolErrorUserInfoKey; 

NSString *const DACINeolMovieIDUserInfoKey; 
NSString *const DACINeolNewsIDUserInfoKey; 
NSString *const DACINeolImageIDUserInfoKey;  

NSString *const DACINeolNumberOfWeeksUserInfoKey; 
NSString *const DACINeolNumberOfNewsUserInfoKey; 
NSString *const DACINeolNumberOfCommentsUserInfoKey; 

NSString *const DACINeolImageURLUserInfoKey; 
NSString *const DACINeolImageSizeUserInfoKey; 
NSString *const DACINeolStartInCommentUserInfoKey;

NSString *const DACINeolSearchQueryUserInfoKey; 


typedef enum {
    DACINeolImageSizeFull,
    DACINeolImageSizeThumbnail,
} DACINeolImageSize;


@interface DACINeolManager : NSObject {
    
    @protected
    NSOperationQueue *_queue;   // SIN USO.
    
    NSMutableDictionary *_currentDownloads; // Debe ser modificado solo en primer plano.
    
    NSString *_apiKey;
}

@property (nonatomic, copy, readonly) NSString *APIKey;

+ (void) initializeSharedManagerWithAPIKey:(NSString*)key;
+ (DACINeolManager*) sharedManager;

- (id) initWithAPIKey:(NSString*)apiKey;


/** 
 *  Los siguientes metodos se ejecutan todos en segundo plano,
 *  exceptuando "numberOfCommentsForMovieWithID:"
 **/
- (NSString*) movieWithID:(NSUInteger)ID;
- (NSString*) newsWithID:(NSUInteger)ID;
- (NSString*) searchMovies:(NSString*)searchString;

- (void) news:(NSUInteger)numberOfNews;
- (void) movieShowtimesForNumberOfWeeks:(NSUInteger)numberOfWeeks;

- (void) imageWithID:(NSUInteger)ID url:(NSString*)url size:(DACINeolImageSize)size;

- (void) downloadComments:(NSUInteger)numberOfComments 
        startingInComment:(NSUInteger)initialComment 
                 forMovie:(NSUInteger)CINeolID;

- (NSInteger) numberOfCommentsForMovieWithID:(NSUInteger)movieCINeolID;

@end