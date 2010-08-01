//
//  DAContentViewItem.m
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAContentViewItem.h"

@interface DAContentViewItem ()

@property (nonatomic, retain, readwrite) UIView     *separatorView;
@property (nonatomic, retain, readwrite) DAGridView *gridView;

@end


@implementation DAContentViewItem

@synthesize separatorView   = _separatorView;
@synthesize gridView        = _gridView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        frame.origin.x = 0.0;
        frame.origin.y = 0.0;
        self.gridView = [[DAGridView alloc] initWithFrame:frame 
                                                    style:DAGridViewStylePageScroll];
        
        frame.origin.x = 0.0;
        frame.origin.y = frame.size.height - 2;
        frame.size.height = 2;
        self.separatorView = [[UIView alloc] initWithFrame:frame];
        self.separatorView.backgroundColor = [UIColor colorWithPatternImage:
                                              [UIImage imageNamed:@"DAContentViewSeparatorPattern.png"]];
  
        
        self.separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                              UIViewAutoresizingFlexibleRightMargin|
                                              UIViewAutoresizingFlexibleLeftMargin|
                                              UIViewAutoresizingFlexibleTopMargin;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                UIViewAutoresizingFlexibleHeight|
                                UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleTopMargin;
        
        self.gridView.autoresizingMask = self.autoresizingMask;
        
        [self addSubview:self.gridView];
        [self addSubview:self.separatorView];
    }
    
    return self;
}


- (void)dealloc {
    [_gridView release];
    [_separatorView release];
    
    [super dealloc];
}


@end
