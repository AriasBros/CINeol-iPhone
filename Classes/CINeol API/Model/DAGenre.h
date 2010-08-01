//
//  DAGenre.h
//  CINeol
//
//  Created by David Arias Vazquez on 30/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DAMovie;

@interface DAGenre :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *movies;

@end


@interface DAGenre (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(DAMovie *)value;
- (void)removeMoviesObject:(DAMovie *)value;
- (void)addMovies:(NSSet *)value;
- (void)removeMovies:(NSSet *)value;

@end

