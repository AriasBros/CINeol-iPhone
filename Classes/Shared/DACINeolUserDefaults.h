//
//  DACINeolUserDefaults.h
//  CINeol
//
//  Created by David Arias Vazquez on 22/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAMovie.h"

/** Notifications **/
NSString *const DACINeolUserDefaultsDidChangeNumberOfNewsNotification;
NSString *const DACINeolUserDefaultsDidChangeMovieSortCategoryInMovieShowtimesNotification;
NSString *const DACINeolUserDefaultsDidChangeNumberOfWeeksNotification;

/** User Info Keys **/
NSString *const DACINeolUserDefaultsNumberOfNewsUserInfoKey; 
NSString *const DACINeolUserDefaultsMovieSortCategoryUserInfoKey;
NSString *const DACINeolUserDefaultsNumberOfWeeksUserInfoKey; 



@interface DACINeolUserDefaults : NSObject {
}

+ (void) registerDefaults;

+ (NSString*) applicationVersion;

+ (void) setInitialSection:(NSUInteger)value;
+ (NSUInteger) initialSection;

+ (void) setNumberOfCommentsPerPage:(NSUInteger)value;
+ (NSUInteger) numberOfCommentsPerPage;

+ (void) setNumberOfNewsInNewsSection:(NSUInteger)value;
+ (NSUInteger) numberOfNewsInNewsSection;

+ (void) setMovieSortCategoryInMovieShowtimesSection:(DAMovieSortCategory)category;
+ (DAMovieSortCategory) movieSortCategoryInMovieShowtimesSection;

+ (void) setNumberOfWeeksInMoviesShowtimesSection:(NSUInteger)value;
+ (NSUInteger) numberOfWeeksInMoviesShowtimesSection;


@end
