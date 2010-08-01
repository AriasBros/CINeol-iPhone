//
//  DBCoreDataManager.h
//  Cineol
//
//  Created by David Arias Vazquez on 18/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>


@interface DACoreDataManager : NSObject <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

+ (id) sharedManager;

- (void) save;
- (void) delete;
- (void) close;

- (void)saveAction:(id)sender;
- (void)deleteAction:(id)sender;

@end
