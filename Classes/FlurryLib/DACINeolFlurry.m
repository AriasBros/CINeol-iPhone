//
//  DACINeolFlurryEvents.m
//  CINeol
//
//  Created by David Arias Vazquez on 31/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolFlurry.h"

#import "DAMovie.h"
#import "DANews.h"
#import "DATrailer.h"

/** ERRORS **/
NSString *const DAFlurryErrorPerformFetch               = @"DAFlurryErrorPerformFetch";
NSString *const DAFlurryErrorCINeolManager              = @"DAFlurryErrorCINeolManager";
NSString *const DAFlurryErrorManagedObjectContext       = @"DAFlurryErrorManagedObjectContext";
NSString *const DAFlurryErrorFileManager                = @"DAFlurryErrorFileManager";
NSString *const DAFlurryErrorPersistentStoreCoordinator = @"DAFlurryErrorPersistentStoreCoordinator";
NSString *const DAFlurryErrorDownloadImage              = @"DAFlurryErrorDownloadImage";
NSString *const DAFlurryErrorSendMail                   = @"DAFlurryErrorSendMail";
NSString *const DAFlurryErrorShowTrailer                = @"DAFlurryErrorShowTrailer";


/** EVENTS **/
NSString *const DAFlurryEventUsingDevicePhone = @"DAFlurryEventUsingDevicePhone";
NSString *const DAFlurryEventUsingDevicePad   = @"DAFlurryEventUsingDevicePad";

NSString *const DAFlurryEventSearchInCINeol = @"DAFlurryEventSearchInCINeol";

NSString *const DAFlurryEventShowNews       = @"DAFlurryEventShowNews";
NSString *const DAFlurryEventShowMovie      = @"DAFlurryEventShowMovie";
NSString *const DAFlurryEventShowPoster     = @"DAFlurryEventShowPoster";
NSString *const DAFlurryEventShowGallery    = @"DAFlurryEventShowGallery";
NSString *const DAFlurryEventShowTrailer    = @"DAFlurryEventShowTrailer";
NSString *const DAFlurryEventShowComments   = @"DAFlurryEventShowComments";
NSString *const DAFlurryEventShowComment    = @"DAFlurryEventShowComment";

NSString *const DAFlurryEventShowAboutView = @"DAFlurryEventShowAboutView";

NSString *const DAFlurryEventStoreMovie          = @"DAFlurryEventStoreMovie";
NSString *const DAFlurryEventShowMovieOnCINeol   = @"DAFlurryEventShowMovieOnCINeol";
NSString *const DAFlurryEventSendMovieForMail    = @"DAFlurryEventSendMovieForMail";

NSString *const DAFlurryEventShowNewsOnCINeol   = @"DAFlurryEventShowNewsOnCINeol";
NSString *const DAFlurryEventSendNewsForMail    = @"DAFlurryEventSendNewsForMail";


@implementation FlurryAPI (DACINeolFlurry)


+ (void) logEvent:(NSString*)event withMovie:(DAMovie*)movie {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          movie.title, @"Movie Title",
                          [NSNumber numberWithInteger:movie.CINeolID], @"Movie CINeol ID", nil];
    [FlurryAPI logEvent:event withParameters:dict];
    [dict release];
}

+ (void) logEvent:(NSString*)event withNews:(DANews*)news {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          news.title, @"News Title",
                          [NSNumber numberWithInteger:news.CINeolID], @"News CINeol ID", nil];
    [FlurryAPI logEvent:event withParameters:dict];
    [dict release];
}

+ (void) logEvent:(NSString*)event withTrailer:(DATrailer*)trailer {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          trailer.movie.title, @"Movie Title",
                          [NSNumber numberWithInteger:trailer.movie.CINeolID], @"Movie CINeol ID",
                          trailer.dailymotionID, @"Trailer Dailymotion ID",
                          trailer.desc, @"Trailer Description", nil];
    [FlurryAPI logEvent:event withParameters:dict];
    [dict release];    
}


+ (void) logEvent:(NSString*)event withSearchQuery:(NSString*)query {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          query, @"Search Query", nil];
    [FlurryAPI logEvent:event withParameters:dict];
    [dict release];
}

@end