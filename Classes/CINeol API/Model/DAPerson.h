//
//  DAPerson.h
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DACredit;

@interface DAPerson :  NSManagedObject  
{
}

@property (nonatomic, assign) NSUInteger    cineolID;
@property (nonatomic, assign) BOOL          buffering;

@property (nonatomic, copy) NSString      *name;
@property (nonatomic, copy) NSString      *cineolURL;

@property (nonatomic, retain) NSSet         *jobs;

+ (NSUInteger) personIDFromURL:(NSString*)URL;

@end


@interface DAPerson (CoreDataGeneratedAccessors)

- (void)addJobsObject:(DACredit *)value;
- (void)removeJobsObject:(DACredit *)value;
- (void)addJobs:(NSSet *)value;
- (void)removeJobs:(NSSet *)value;

@end

