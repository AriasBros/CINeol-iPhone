// 
//  DACINeolObject.m
//  CINeol
//
//  Created by David Arias Vazquez on 22/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolObject.h"

#import "DAPhoto.h"

@implementation DACINeolObject 

@dynamic numberOfVisits;
@dynamic forumCINeolURL;
@dynamic author;
@dynamic CINeolID;
@dynamic buffering;
@dynamic date;
@dynamic CINeolURL;
@dynamic numberOfComments;
@dynamic title;
@dynamic photo;


- (void) setBuffering:(BOOL)buffering {
    [super willChangeValueForKey: @"buffering"];
    [super setPrimitiveValue: [NSNumber numberWithBool:buffering] forKey: @"buffering"];
    [super didChangeValueForKey: @"buffering"];
}

- (BOOL) isBuffering {
    [super willAccessValueForKey: @"buffering"];
    BOOL buffering =[(NSNumber*)[super primitiveValueForKey: @"buffering"] boolValue];
    [super didAccessValueForKey: @"buffering"];
    
    return buffering;
}

- (void) setCINeolID:(NSUInteger)cineolID {
    [super willChangeValueForKey: @"CINeolID"];
    [super setPrimitiveValue:[NSNumber numberWithInteger:cineolID] forKey: @"CINeolID"];
    [super didChangeValueForKey: @"CINeolID"];
}

- (NSUInteger) CINeolID {
    [super willAccessValueForKey: @"CINeolID"];
    NSUInteger cineolID =[(NSNumber*)[super primitiveValueForKey: @"CINeolID"] integerValue];
    [super didAccessValueForKey: @"CINeolID"];
    
    return cineolID;
}

- (void) setNumberOfComments:(NSUInteger)comments {
    [super willChangeValueForKey: @"numberOfComments"];
    [super setPrimitiveValue:[NSNumber numberWithInteger:comments] forKey: @"numberOfComments"];
    [super didChangeValueForKey: @"numberOfComments"];
}

- (NSUInteger) numberOfComments {
    [super willAccessValueForKey: @"numberOfComments"];
    NSUInteger comments =[(NSNumber*)[super primitiveValueForKey: @"numberOfComments"] intValue];
    [super didAccessValueForKey: @"numberOfComments"];
    
    return comments;
}

- (void) setNumberOfVisits:(NSUInteger)visits {
    [super willChangeValueForKey: @"numberOfVisits"];
    [super setPrimitiveValue:[NSNumber numberWithInteger:visits] forKey: @"numberOfVisits"];
    [super didChangeValueForKey: @"numberOfVisits"];
}

- (NSUInteger) numberOfVisits {
    [super willAccessValueForKey: @"numberOfVisits"];
    NSUInteger visits =[(NSNumber*)[super primitiveValueForKey: @"numberOfVisits"] intValue];
    [super didAccessValueForKey: @"numberOfVisits"];
    
    return visits;
}

@end
