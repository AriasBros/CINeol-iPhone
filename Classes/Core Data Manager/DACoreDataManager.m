//
//  DBCoreDataManager.m
//  Cineol
//
//  Created by David Arias Vazquez on 18/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import "DACoreDataManager.h"


static DACoreDataManager *singleton = nil;



@interface DACoreDataManager ()

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DACoreDataManager

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;


- (id) initWithDatabaseName: (NSString*) name {
    if (self = [super init]) {
        self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil]; 
        
        NSError *error = nil;
        NSURL *storeUrl = [NSURL fileURLWithPath: [self.applicationDocumentsDirectory 
                                                   stringByAppendingPathComponent: name]];
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                           initWithManagedObjectModel: self.managedObjectModel];
        if (![self.persistentStoreCoordinator
              addPersistentStoreWithType: NSSQLiteStoreType 
                           configuration: nil
                                     URL: storeUrl 
                                 options: nil
                                   error: &error]) 
        {
            // TODO -- Handle error
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }  
        
        if (self.persistentStoreCoordinator) {
            self.managedObjectContext = [[NSManagedObjectContext alloc] init];
            [self.managedObjectContext setPersistentStoreCoordinator: self.persistentStoreCoordinator];
        }        
    }
    
    return self;
}


+ (DACoreDataManager*) sharedManager {
    if (singleton == nil) { 
        [singleton release];
        
        NSString *name = [[[NSBundle mainBundle] infoDictionary]
                          objectForKey: @"DACoreDataManagerDatabaseName"];

        singleton = [[DACoreDataManager alloc] initWithDatabaseName:name];
        [singleton retain];
    }
    
    return singleton;
}


- (void) save {
    [self saveAction:self];
}

- (void) close {
    if (singleton) {
        [singleton release];
        singleton = nil;
    }
}

- (void) delete {
    [self deleteAction:self];
    
    if (singleton) {
        [singleton release];
        singleton = nil;
    }
    
    [DACoreDataManager sharedManager];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context 
 before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
            
            [FlurryAPI logError:DAFlurryErrorManagedObjectContext
                        message:@"Error save managed object context" 
                          error:error];
            
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {        
		// Handle error
        
        [FlurryAPI logError:DAFlurryErrorManagedObjectContext
                    message:@"Error save managed object context" 
                      error:error];
        
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}

#pragma mark -
#pragma mark Deleting
- (void)deleteAction:(id)sender {
    if ([[self.persistentStoreCoordinator persistentStores] count] <= 0)
        return;
    
    NSPersistentStore *store = [[self.persistentStoreCoordinator persistentStores] objectAtIndex:0];
    NSError *error = nil;
    NSURL *storeURL = store.URL;

    if (![self.persistentStoreCoordinator removePersistentStore:store error:&error]) {
        // Handle error
        
        NSString *log = [NSString stringWithFormat:@"persistentStoreCoordinator Unresolved error %@, %@",
                         error, [error userInfo]];
        
        [FlurryAPI logError:DAFlurryErrorPersistentStoreCoordinator
                    message:log 
                      error:error];
        
		NSLog(@"%@", log);
    }
    
    error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error]) {
        // Handle error
        
        NSString *log = [NSString stringWithFormat:@"NSFileManager Unresolved error %@, %@",
                         error, [error userInfo]];
        
        [FlurryAPI logError:DAFlurryErrorFileManager
                    message:log 
                      error:error];
        
		NSLog(@"%@", log);        
    }
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                         NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[super dealloc];
}


@end
