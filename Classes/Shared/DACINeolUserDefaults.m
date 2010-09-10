//
//  DACINeolUserDefaults.m
//  CINeol
//
//  Created by David Arias Vazquez on 22/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolUserDefaults.h"

/** Notifications **/
NSString *const DACINeolUserDefaultsDidChangeNumberOfNewsNotification = @"DACINeolUserDefaultsDidChangeNumberOfNews";
NSString *const DACINeolUserDefaultsDidChangeMovieSortCategoryInMovieShowtimesNotification = @"DACINeolUserDefaultsDidChangeMovieSortCategoryInMovieShowtimesNotification";
NSString *const DACINeolUserDefaultsDidChangeNumberOfWeeksNotification = @"DACINeolUserDefaultsDidChangeNumberOfWeeks";


/** User Info Keys **/
NSString *const DACINeolUserDefaultsNumberOfNewsUserInfoKey = @"DACINeolUserDefaultsNumberOfNews"; 
NSString *const DACINeolUserDefaultsMovieSortCategoryUserInfoKey = @"DACINeolUserDefaultsMovieSortCategory"; 
NSString *const DACINeolUserDefaultsNumberOfWeeksUserInfoKey = @"DACINeolUserDefaultsNumberOfWeeks"; 


/** User Defaults Keys **/
NSString *const DACINeolInitialSection = @"DACINeolInitialSection";
NSString *const DACINeolNumberOfCommentsPerPage = @"DACINeolNumberOfCommentsPerPage";
NSString *const DACINeolNumberOfNewsInNewsSection = @"DACINeolNumberOfNewsInNewsSection";
NSString *const DACINeolMovieSortCategoryInMovieShowtimesSection = @"DACINeolMovieSortCategoryInMovieShowtimesSection";
NSString *const DACINeolNumberOfWeeksInMovieShowtimesSection = @"DACINeolNumberOfWeeksInMovieShowtimesSection";


@implementation DACINeolUserDefaults


+ (void) registerDefaults {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"UserDefaults"
                                                     ofType:@"plist"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:file];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary]; 
    [dictionary release];
}


+ (NSString*) applicationVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
}


#pragma mark -
#pragma mark Initial Section.
+ (void) setInitialSection:(NSUInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value 
                                               forKey:DACINeolInitialSection];    
}

+ (NSUInteger) initialSection {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DACINeolInitialSection];
}


#pragma mark -
#pragma mark Number of comments per page.
+ (void) setNumberOfCommentsPerPage:(NSUInteger)value {
    [[NSUserDefaults standardUserDefaults] setInteger:value 
                                               forKey:DACINeolNumberOfCommentsPerPage];
}

+ (NSUInteger) numberOfCommentsPerPage {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DACINeolNumberOfCommentsPerPage];
}


#pragma mark -
#pragma mark Number of news in News Section.
+ (void) setNumberOfNewsInNewsSection:(NSUInteger)value {
    [NSFetchedResultsController deleteCacheWithName:@"NewsInBuffer"];

    [[NSUserDefaults standardUserDefaults] setInteger:value 
                                               forKey:DACINeolNumberOfNewsInNewsSection];  
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInteger:value], DACINeolUserDefaultsNumberOfNewsUserInfoKey, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolUserDefaultsDidChangeNumberOfNewsNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];
}

+ (NSUInteger) numberOfNewsInNewsSection {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DACINeolNumberOfNewsInNewsSection];
}


#pragma mark -
#pragma mark Movie Sort Category in Movies Showtimes Section.
+ (void) setMovieSortCategoryInMovieShowtimesSection:(DAMovieSortCategory)value {
    [NSFetchedResultsController deleteCacheWithName:@"MovieShowtimes"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:value 
                                               forKey:DACINeolMovieSortCategoryInMovieShowtimesSection];  
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInteger:value], DACINeolUserDefaultsMovieSortCategoryUserInfoKey, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolUserDefaultsDidChangeMovieSortCategoryInMovieShowtimesNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];    
}

+ (DAMovieSortCategory) movieSortCategoryInMovieShowtimesSection {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DACINeolMovieSortCategoryInMovieShowtimesSection];    
}

#pragma mark -
#pragma mark Number of weeks in Movie Showtimes Section.
+ (void) setNumberOfWeeksInMoviesShowtimesSection:(NSUInteger)value {
    [NSFetchedResultsController deleteCacheWithName:@"MovieShowtimes"];

    [[NSUserDefaults standardUserDefaults] setInteger:value 
                                               forKey:DACINeolNumberOfWeeksInMovieShowtimesSection]; 
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInteger:value], DACINeolUserDefaultsNumberOfWeeksUserInfoKey, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DACINeolUserDefaultsDidChangeNumberOfWeeksNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];
}

+ (NSUInteger) numberOfWeeksInMoviesShowtimesSection {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DACINeolNumberOfWeeksInMovieShowtimesSection];    
}

@end