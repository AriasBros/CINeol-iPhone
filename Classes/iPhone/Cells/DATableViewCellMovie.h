//
//  DATableViewCellMovie.h
//  CINeol
//
//  Created by David Arias Vazquez on 05/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DATableViewCellNews.h"

@interface DATableViewCellMovie : DATableViewCellNews {

    @protected
    UILabel      *_genreLabel;
    UILabel      *_durationLabel;
    DARatingView *_ratingView;
}

@property (nonatomic, retain, readonly) UILabel      *genreLabel;
@property (nonatomic, retain, readonly) UILabel      *durationLabel;
@property (nonatomic, retain, readonly) DARatingView *ratingView;

@end
