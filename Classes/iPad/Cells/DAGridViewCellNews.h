//
//  DAGridViewCellNews.h
//  Cineol
//
//  Created by David Arias Vazquez on 21/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DAGridViewCellNews : DAGridViewCell {

    @protected
    CAGradientLayer *_backgroundLayer;
    
    UIButton        *_readMoreButton;
    UIButton        *_commentsButton;
}

@property (nonatomic, retain, readonly) UIButton *readMoreButton;
@property (nonatomic, retain, readonly) UIButton *commentsButton;

- (void) portraitLayoutSubviews;
- (void) landscapeLayoutSubviews;

@end
