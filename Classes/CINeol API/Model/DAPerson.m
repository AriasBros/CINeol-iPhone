// 
//  DAPerson.m
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAPerson.h"

#import "DACredit.h"

@implementation DAPerson 

@dynamic name;
@dynamic buffering;
@dynamic jobs;
@dynamic cineolID;
@dynamic cineolURL;

+ (NSUInteger) personIDFromURL:(NSString*)URL {
    NSScanner *scanner = [NSScanner scannerWithString:URL];
    NSInteger ID = 0;
    
    [scanner scanString:@"http://www.cineol.net/gente/" intoString:NULL];
    [scanner scanInteger:&ID];
    
    return ID;
}

- (void) setCineolID:(NSUInteger)ID {
    [super willChangeValueForKey: @"cineolID"];
    [super setPrimitiveValue: [NSNumber numberWithInteger: ID] forKey: @"cineolID"];
    [super didChangeValueForKey: @"cineolID"];
}

- (NSUInteger) cineolID {
    [super willAccessValueForKey: @"cineolID"];
    NSUInteger cineolID =[(NSNumber*)[super primitiveValueForKey: @"cineolID"] integerValue];
    [super didAccessValueForKey: @"cineolID"];
    
    return cineolID;
}

- (void) setBuffering:(BOOL)buffering {
    [super willChangeValueForKey: @"buffering"];
    [super setPrimitiveValue: [NSNumber numberWithBool:buffering] forKey: @"buffering"];
    [super didChangeValueForKey: @"buffering"];
}

- (BOOL) buffering {
    [super willAccessValueForKey: @"buffering"];
    BOOL buffering =[(NSNumber*)[super primitiveValueForKey: @"buffering"] boolValue];
    [super didAccessValueForKey: @"buffering"];
    
    return buffering;
}


@end
