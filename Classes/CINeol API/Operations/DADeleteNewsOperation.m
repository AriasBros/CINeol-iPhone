//
//  DADeleteNewsOperation.m
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DADeleteNewsOperation.h"
#import "DACINeolFacade.h"


@implementation DADeleteNewsOperation

- (id) initWithNumberOfNewsToDelete:(NSUInteger)numberOfNewsToDelete {
    if (self = [super init]) {
        _numberOfNewsToDelete = numberOfNewsToDelete;
    }
    
    return self;
}

- (void) performOperation {        
    NSFetchRequest *request = [DACINeolFacade fetchRequestForNewsInBuffer];
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
    int count = [objects count];
    if (_numberOfNewsToDelete > 0 && count >= _numberOfNewsToDelete) {
        for (int i = 1; i <= _numberOfNewsToDelete; i++)
            [self.managedObjectContext deleteObject:[objects objectAtIndex:count - i]];            
        
        [self.managedObjectContext save:NULL];
    }    
}

- (void) dealloc {
    [super dealloc];
}

@end
