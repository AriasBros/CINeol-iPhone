//
//  DANumberOfCommentsOperation.m
//  CINeol
//
//  Created by David Arias Vazquez on 28/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DANumberOfCommentsOperation.h"


//NSString *const kURLNumberOfComments = @"http://www.cineol.net/api/getcomentarios.php?apiKey=%@&idpelicula=%d";


@implementation DANumberOfCommentsOperation

- (id) initWithMovieCINeolID:(NSUInteger)CINeolID {
    
    if (self = [super init]) {
        _movieCINeolID = CINeolID;
    }
    
    return self;
}

- (void) main {
    [self numberOfComments];
}

- (NSUInteger) numberOfComments {
   /*
    NSURL *URL = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:kURLNumberOfComments, _movieCINeolID]];
    
    NSString *data = [[NSString alloc] initWithContentsOfURL:URL];
    
    NSUInteger value = [data integerValue];
    
    [data release];
    [URL release];
    
    return value;
    */
    return 0;
}

@end
