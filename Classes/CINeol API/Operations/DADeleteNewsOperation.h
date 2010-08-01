//
//  DADeleteNewsOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACINeolOperation.h"

@interface DADeleteNewsOperation : DACINeolOperation {

    @protected
    NSUInteger _numberOfNewsToDelete;
}

- (id) initWithNumberOfNewsToDelete:(NSUInteger)numberOfNewsToDelete;

@end
