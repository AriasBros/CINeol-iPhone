//
//  DACINeolFlurryEvents.h
//  CINeol
//
//  Created by David Arias Vazquez on 31/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "FlurryAPI.h"

@class DAMovie;
@class DANews;
@class DATrailer;


/** ERRORS **/
NSString *const DAFlurryErrorPerformFetch;
NSString *const DAFlurryErrorCINeolManager;
NSString *const DAFlurryErrorManagedObjectContext;
NSString *const DAFlurryErrorFileManager;
NSString *const DAFlurryErrorPersistentStoreCoordinator;
NSString *const DAFlurryErrorSendMail;
NSString *const DAFlurryErrorDownloadImage;


/** EVENTS **/
NSString *const DAFlurryEventUsingDevicePhone;
NSString *const DAFlurryEventUsingDevicePad;

NSString *const DAFlurryEventSearchInCINeol;

NSString *const DAFlurryEventShowNews;
NSString *const DAFlurryEventShowMovie;
NSString *const DAFlurryEventShowPoster;
NSString *const DAFlurryEventShowGallery;
NSString *const DAFlurryEventShowTrailer;
NSString *const DAFlurryEventShowComments;
NSString *const DAFlurryEventShowComment;

NSString *const DAFlurryEventShowAboutView;

NSString *const DAFlurryEventStoreMovie;
NSString *const DAFlurryEventShowMovieOnCINeol;
NSString *const DAFlurryEventSendMovieForMail;

NSString *const DAFlurryEventShowNewsOnCINeol;
NSString *const DAFlurryEventSendNewsForMail;


@interface FlurryAPI (DACINeolFlurry)

+ (void) logEvent:(NSString*)event withMovie:(DAMovie*)movie;
+ (void) logEvent:(NSString*)event withNews:(DANews*)news;
+ (void) logEvent:(NSString*)event withTrailer:(DATrailer*)trailer;
+ (void) logEvent:(NSString*)event withSearchQuery:(NSString*)query;

@end