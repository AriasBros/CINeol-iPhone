//
//  DAComment.h
//  CINeol
//
//  Created by David Arias Vazquez on 22/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

NSString* const kCINeolDateCommentFormat;


@class DAMovie;

@interface DAComment :  NSManagedObject  
{
}

@property (nonatomic, copy) NSString  *user;
@property (nonatomic, copy) NSString  *message;
@property (nonatomic, retain) NSDate    *date;
@property (nonatomic, retain) DAMovie   *movie;

@end



