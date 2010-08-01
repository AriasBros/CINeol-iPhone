//
//  DANews.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DANews.h"
#import "DACINeolFacade.h"

#define NEWS_DATE_FORMAT @"dd/MM/yyyy"
#define URL_BASE @"http://www.cineol.net/noticias/"

NSString* const kCINeolDateNewsFormat = @"yyy-MM-dd HH:mm:ss";
NSString* const kCINeolTitleDateNewsFormat = @"dd/MM/yyyy";

@implementation DANews

@dynamic body;
@dynamic introduction;


- (BOOL) needsDownloadContent {
    return self.body == nil;
}


- (NSString*) dateString {
    return [[DACalendar defaultCalendar] stringFromDate:self.date withDateFormat:NEWS_DATE_FORMAT];
}


- (NSString*) CINeolURL {    
    NSString * CINeolURL;
    
    [self willAccessValueForKey:@"CINeolURL"];
    CINeolURL = [self primitiveValueForKey:@"CINeolURL"];
    [self didAccessValueForKey:@"CINeolURL"];
    
    if (CINeolURL == nil) {
        NSMutableString *URL = [[NSMutableString alloc] initWithString:URL_BASE];
        
        [URL appendFormat:@"%i_%@", self.CINeolID, self.title];
        
        NSInteger loc = [URL_BASE length];
        NSInteger len = [URL length];
        
        [URL replaceOccurrencesOfString:@" "
                             withString:@"-"
                                options:NSCaseInsensitiveSearch
                                  range:NSMakeRange(loc, len - loc)];
        
        self.CINeolURL = URL;
        CINeolURL = URL;
        
        [URL release];
    }


    return CINeolURL;
}

@end