//
//  DANumberOfCommentsOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 28/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACINeolOperation.h"

@interface DANumberOfCommentsOperation : DACINeolOperation {

    @protected
    NSUInteger _movieCINeolID;
}

- (id) initWithMovieCINeolID:(NSUInteger)CINeolID;

- (NSUInteger) numberOfComments;

@end