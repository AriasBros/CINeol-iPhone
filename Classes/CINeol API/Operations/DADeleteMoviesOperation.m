//
//  DADeleteMoviesOperation.m
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DADeleteMoviesOperation.h"
#import "DACINeolFacade.h"


@implementation DADeleteMoviesOperation

- (id) initWithNumberOfWeeks:(NSUInteger)weeks {
    if (self = [super init]) {
        _numberOfWeeks = weeks;
    }
    
    return self;
}

- (void) performOperation {    
    NSFetchRequest *request = [DACINeolFacade fetchRequestForMoviesToDelete:_numberOfWeeks];
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:NULL];

    if ([objects count] > 0) {
        for (id object in objects)
            [self.managedObjectContext deleteObject:object];
        
        [self.managedObjectContext save:NULL];
    }
}

@end
