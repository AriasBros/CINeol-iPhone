//
//  DAMovieRatingView.m
//  CINeol
//
//  Created by David Arias Vazquez on 15/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAMovieRatingView.h"

@interface DAMovieRatingView ()

@property (nonatomic, assign) DATextView *textView;

@end


@implementation DAMovieRatingView

@synthesize textView = _textView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        frame.origin.x = 10.0;
        frame.size.width -= 20;
        frame.size.height = 300;
        frame.origin.y = self.bounds.size.height - frame.size.height - 15;
        self.textView = [[DATextView alloc] initWithFrame:frame];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                         UIViewAutoresizingFlexibleHeight|
                                         UIViewAutoresizingFlexibleBottomMargin;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
        
        [self addSubview:self.textView];
        [self.textView release];
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
