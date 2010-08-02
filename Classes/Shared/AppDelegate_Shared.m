//
//  AppDelegate_Shared.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright Yo 2010. All rights reserved.
//

#import "AppDelegate_Shared.h"
#import "DACINeolManager.h"
#import "DACoreDataManager.h"
#import "DACINeolManager.h"
#import "DACINeolUserDefaults.h"


@implementation AppDelegate_Shared

@synthesize window;


#pragma mark -
#pragma mark Methods for subclassing.
- (void) initUserInterface {
    return;
}

- (UIView*) mainView {
    return nil;
}


void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"UncaughtException" message:@"Crash" exception:exception];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //[DACINeolManager initializeSharedManagerWithAPIKey:<#(NSString*)YOUR API KEY HERE#>];
    [DACINeolUserDefaults registerDefaults];

    //[FlurryAPI startSession:<#(NSString*)YOUR API KEY HERE#>];
    
    [self initUserInterface];
    
    [self.window addSubview:[self mainView]];
    [self.window makeKeyAndVisible];

	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[DACoreDataManager sharedManager] save];
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 
 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
    */
    
    [[DACoreDataManager sharedManager] save];
}


#pragma mark -
#pragma mark Core Data stack
/*
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.

 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CINeol.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
*/

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[window release];
	[super dealloc];
}


@end

