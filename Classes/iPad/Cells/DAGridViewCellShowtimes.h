//
//  DAGridViewCellShowtimes.h
//  Cineol
//
//  Created by David Arias Vazquez on 22/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAGridViewCellReviews.h"

@interface DAGridViewCellShowtimes : DAGridViewCellReviews {

    @protected
    UILabel *_genreLabel;
    UILabel *_durationLabel;
    UILabel *_premierLabel;
}

@property (nonatomic, retain, readonly) UILabel *genreLabel;
@property (nonatomic, retain, readonly) UILabel *durationLabel;
@property (nonatomic, retain, readonly) UILabel *premierLabel;

@end
