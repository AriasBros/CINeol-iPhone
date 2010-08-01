//
//  DACINeolObject.h
//  CINeol
//
//  Created by David Arias Vazquez on 22/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DAPhoto;

@interface DACINeolObject :  NSManagedObject  
{
}

@property (nonatomic, assign) NSUInteger CINeolID;
@property (nonatomic, assign) NSUInteger numberOfVisits;
@property (nonatomic, assign) NSUInteger numberOfComments;

@property (nonatomic, assign, getter=isBuffering) BOOL buffering;

@property (nonatomic, copy)   NSString  *forumCINeolURL;
@property (nonatomic, copy)   NSString  *author;
@property (nonatomic, copy)   NSString  *CINeolURL;
@property (nonatomic, copy)   NSString  *title;

@property (nonatomic, retain) NSDate    *date;

@property (nonatomic, retain) DAPhoto   *photo;

@end



