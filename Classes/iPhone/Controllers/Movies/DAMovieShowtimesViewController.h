//
//  DAMovieShowtimesViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 05/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAMoviesViewController.h"

@interface DAMovieShowtimesViewController : DAMoviesViewController
{
    @protected
    NSUInteger _numberOfMovies;
    NSInteger _numberOfWeeks;    
}

@end
