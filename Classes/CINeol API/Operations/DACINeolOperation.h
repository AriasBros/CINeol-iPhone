//
//  DACINeolOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//


@interface DACINeolOperation : NSOperation {

    @protected
    NSManagedObjectContext  *_managedObjectContext;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;


// For subclasses.
- (void) performOperation;

@end
