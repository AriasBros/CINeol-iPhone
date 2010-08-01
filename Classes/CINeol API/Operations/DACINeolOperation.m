//
//  DACINeolOperation.m
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolOperation.h"
#import "DACoreDataManager.h"

@interface DACINeolOperation ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) mergeChanges:(NSNotification*)notification;

@end

@implementation DACINeolOperation


@synthesize managedObjectContext = _managedObjectContext;


- (void) performOperation {
    return;
}

- (void) main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:
     [[DACoreDataManager sharedManager] persistentStoreCoordinator]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    
    [self performOperation];
    
    [pool drain];
    [self.managedObjectContext reset];
    self.managedObjectContext = nil;
}

- (void) mergeChanges:(NSNotification*)notification {    
    [[[DACoreDataManager sharedManager] managedObjectContext]
     performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
     withObject:notification
     waitUntilDone:YES];
}

- (void) dealloc {
    [_managedObjectContext release];    _managedObjectContext = nil;
    [super dealloc];
}

@end
