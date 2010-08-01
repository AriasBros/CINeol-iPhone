//
//  DATableViewCellNews.h
//  Cineol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DATableViewCellNews : DATableViewCellSlide {

    @protected
    UIView       *_shadowImageView;
}

@property (nonatomic, retain, readonly) UIView *shadowImageView;

+ (CGSize) constrainSizeForLabels;
+ (CGFloat) heightForImageView;
+ (UIFont*) fontForTextLabel;
+ (UIFont*) fontForDetailTextLabel;

@end
