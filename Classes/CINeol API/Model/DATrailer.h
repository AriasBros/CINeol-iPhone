//
//  DATrailer.h
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DAMovie;

NSString* const kCINeolDateTrailerFormat;


@interface DATrailer :  NSManagedObject  
{
}

@property (nonatomic, copy) NSString  *dailymotionID;
@property (nonatomic, copy) NSString  *desc;
@property (nonatomic, retain) NSDate    *date;
@property (nonatomic, retain) DAMovie   *movie;

@end



