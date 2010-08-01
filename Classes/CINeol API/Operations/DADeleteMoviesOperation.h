//
//  DADeleteMoviesOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACINeolOperation.h"


@interface DADeleteMoviesOperation : DACINeolOperation {
    @protected
    NSUInteger _numberOfWeeks;
}

- (id) initWithNumberOfWeeks:(NSUInteger)weeks;

@end
