//
//  DAGridViewCellReviews.h
//  Cineol
//
//  Created by David Arias Vazquez on 22/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAGridViewCellNews.h"

@interface DAGridViewCellReviews : DAGridViewCellNews {

    @protected
    DARatingView  *_ratingView;
}

@property (nonatomic, retain, readonly) DARatingView *ratingView;

@end
