//
//  DALateralBarItem.m
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DALateralBarItem.h"

@interface DALateralBarItem ()

@property (nonatomic, retain, readwrite) UILabel *titleLabel;
@property (nonatomic, retain, readwrite) UIView  *separatorView;

@end


@implementation DALateralBarItem

@synthesize titleLabel = _titleLabel;
@synthesize separatorView = _separatorView;

- (id) initWithFrame:(CGRect)frame title:(NSString*)title {
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.titleLabel.text = title;
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.separatorView.backgroundColor = [UIColor colorWithPatternImage:
                                              [UIImage imageNamed:@"DALateralBarSeparatorPattern.png"]];
        
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 3;
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
        self.titleLabel.shadowColor = [UIColor whiteColor];
        self.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
             
        // Layout Title Label.
        CGSize size = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(frame.size.width, 200.0)];
        frame.size.height = size.height;
        frame.origin = CGPointMake(0.0, 15.0);
        self.titleLabel.frame = frame;
        
        // Layout Separator View.
        frame = CGRectMake(0.0, 0.0, 80, 2);
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
        frame.origin.y = self.frame.size.height - frame.size.height;
        self.separatorView.frame = frame;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.separatorView];
        
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleRightMargin|
                                           UIViewAutoresizingFlexibleLeftMargin;
 
        self.separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                              UIViewAutoresizingFlexibleRightMargin|
                                              UIViewAutoresizingFlexibleLeftMargin|
                                              UIViewAutoresizingFlexibleTopMargin;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|
                                UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleTopMargin;
    }
    
    return self;
}

@end
