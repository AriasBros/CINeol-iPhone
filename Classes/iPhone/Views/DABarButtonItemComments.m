//
//  DABarButtonItemComments.m
//  CINeol
//
//  Created by David Arias Vazquez on 14/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DABarButtonItemComments.h"

@interface DABarButtonItemComments ()

//- (void) applicationDidChangeOrientation:(NSNotification*)notification;

@end


@implementation DABarButtonItemComments

@synthesize numberOfComments = _numberOfComments;
@synthesize target = _target;
@synthesize action = _selector;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

    }
    return self;
}

- (id) initWithNumberOfComments:(NSUInteger)comments {
    return [self initWithNumberOfComments:comments target:nil action:NULL];
}

- (id) initWithNumberOfComments:(NSUInteger)comments target:(id)target action:(SEL)selector {
    if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, 30, 44)])) {
        
        _numberOfComments = comments;
        _target = target;
        _selector = selector;
        
        
        if (selector != NULL)
            [self addTarget:target
                     action:selector 
           forControlEvents:UIControlEventTouchUpInside];
        
        
        _overlay = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_overlay setTitleColor:[UIColor colorWithRed:73.0/255 
                                                green:148.0/255
                                                 blue:203.0/255
                                                alpha:1.0] 
                      forState:UIControlStateNormal];
        
        _overlay.titleLabel.shadowOffset = CGSizeMake(0.0, -0.2);
        [self setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [_overlay setImage:[UIImage imageNamed:@"DACommentsToolbarIcon.png"]
                  forState:UIControlStateNormal];
        
        [_overlay setImage:[UIImage imageNamed:@"DAMovieInfoToolbarIcon-v2.png"]
                  forState:UIControlStateSelected];
        
        [_overlay setTitle:[NSString stringWithFormat:@"%i", comments] 
                  forState:UIControlStateNormal];
        
        [_overlay setTitle:@"" 
                  forState:UIControlStateSelected];
        
        _overlay.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _overlay.imageEdgeInsets = UIEdgeInsetsMake(3.0, 0.0, -3.0, 0.0);
        _overlay.titleEdgeInsets = UIEdgeInsetsMake(1.0, -23.0, 0.0, 0.0);
                    
        _overlay.frame = self.frame;
        _overlay.userInteractionEnabled = NO;
        
        [self addSubview:_overlay];
        self.showsTouchWhenHighlighted = YES;
        
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidChangeOrientation:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:[UIApplication sharedApplication]];
         */
    }
    
    return self;    
}

/*
- (void) applicationDidChangeOrientation:(NSNotification*)notification {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.frame = CGRectMake(0.0, 0.0, 24, 20);
        _overlay.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _overlay.titleEdgeInsets = UIEdgeInsetsMake(2.5, -23.0, 0.0, 0.0);
    }
    else {
        self.frame = CGRectMake(0.0, 0.0, 24, 28);
        _overlay.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _overlay.titleEdgeInsets = UIEdgeInsetsMake(1.0, -23.0, 0.0, 0.0);
    }

    _overlay.frame = self.frame;
}
*/

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    _overlay.selected = selected;
    
    if (selected) {
        _overlay.imageEdgeInsets = UIEdgeInsetsMake(2.0, 0.0, -2.0, 0.0);
    }
    else {
        _overlay.imageEdgeInsets = UIEdgeInsetsMake(3.0, 0.0, -3.0, 0.0);
    }
}

/*
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    self.selected = !self.selected;
    [super sendAction:action to:target forEvent:event];
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
