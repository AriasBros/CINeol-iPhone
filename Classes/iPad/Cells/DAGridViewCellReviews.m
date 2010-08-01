//
//  DAGridViewCellReviews.m
//  Cineol
//
//  Created by David Arias Vazquez on 22/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAGridViewCellReviews.h"
#import "DAGridViewCellNews.h"

#define TOP_MARGIN      8
#define MARGIN          12
#define DOBLE_MARGIN    24

@interface DAGridViewCellReviews ()

@property (nonatomic, retain) DARatingView *ratingView;

@end


@implementation DAGridViewCellReviews

@synthesize ratingView = _ratingView;


- (id) initWithStyle:(DAGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.ratingView = [[DARatingView alloc] initWithFullImage:[UIImage imageNamed:@"star_full_15.png"]
                                                       emptyImage:[UIImage imageNamed:@"star_empty_15.png"]
                                                      middleImage:[UIImage imageNamed:@"star_middle_15.png"]
                                                         dotImage:[UIImage imageNamed:@"star_dot_15.png"]
                                                           origin:CGPointMake(0.0, 0.0)
                                                        useMargin:NO];
        self.ratingView.rating = 5;
        
        [self addSubview:self.ratingView];
    }
    
    return self;
}

- (void) portraitLayoutSubviews {
    self.textLabel.numberOfLines = 3;
    self.detailTextLabel.numberOfLines = 5;
    
    CGRect rect;
    
    // Situamos el ImageView.
    rect.size.width = self.frame.size.width - 16;
    rect.size.height = 120;
    rect.origin.x = (self.frame.size.width - rect.size.width) / 2;
    rect.origin.y = 8;
    self.imageView.frame = rect;
    
    // Situamos el TextLabel.
    rect = CGRectMake(rect.origin.x, rect.size.height + rect.origin.y + 8, rect.size.width, 50);
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font 
                                  constrainedToSize:rect.size];
    rect.size = size;
    self.textLabel.frame = rect;
    
    // Situamos el DetailTextLabel.
    rect = CGRectMake(rect.origin.x, rect.size.height + rect.origin.y + 2, self.imageView.frame.size.width, 75);
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font 
                                 constrainedToSize:rect.size];
    rect.size = size;
    self.detailTextLabel.frame = rect;    
    
    // Situamos el CommentsButton.
    rect = CGRectMake(4, self.frame.size.height - self.commentsButton.frame.size.height - 2,
                      0, self.commentsButton.frame.size.height);
    size = [self.commentsButton.currentTitle sizeWithFont:self.commentsButton.titleLabel.font];
    size.width += 35;
    rect.size.width = size.width;
    self.commentsButton.frame = rect;
    
    // Situamos el ReadMoreButton.
    size = [self.readMoreButton.currentTitle sizeWithFont:self.readMoreButton.titleLabel.font];
    size.width += 35;
    rect.size.width = size.width;
    rect.origin.x = self.frame.size.width - rect.size.width - 4;
    self.readMoreButton.frame = rect;
    
    // Situamos el RatingView.
    rect = self.ratingView.frame;
    rect.origin.x = 8;
    rect.origin.y = self.detailTextLabel.frame.size.height + self.detailTextLabel.frame.origin.y + 8;
    self.ratingView.frame = rect;
}

- (void) landscapeLayoutSubviews {
    self.textLabel.numberOfLines = 2;
    self.detailTextLabel.numberOfLines = 2;
    
    CGRect rect;
    
    // Situamos el TextLabel.
    rect = CGRectMake(MARGIN, TOP_MARGIN, self.frame.size.width - 16, 500);
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font 
                                  constrainedToSize:rect.size];
    rect.size = size;
    self.textLabel.frame = rect;
    
    
    // Situamos el CommentsButton.
    rect.origin.x = MARGIN;
    rect.origin.y = self.frame.size.height - self.commentsButton.frame.size.height - 2;
    rect.size.height = self.commentsButton.frame.size.height;
    size = [self.commentsButton.currentTitle sizeWithFont:self.commentsButton.titleLabel.font];
    size.width += 35;
    rect.size.width = size.width;
    self.commentsButton.frame = rect;
    
    
    // Situamos el ReadMoreButton.
    size = [self.readMoreButton.currentTitle sizeWithFont:self.readMoreButton.titleLabel.font];
    size.width += 35;
    rect.size.width = size.width;
    rect.origin.x = self.frame.size.width - rect.size.width - MARGIN;
    self.readMoreButton.frame = rect;
    
    
    // Situamos el ImageView.
    rect.origin.y = self.textLabel.frame.size.height + self.textLabel.frame.origin.y + 4;
    rect.origin.x = MARGIN;
    rect.size.width = self.frame.size.width - DOBLE_MARGIN;
    rect.size.height = 110;
    self.imageView.frame = rect;
    
    
    // Situamos el RatingView.
    rect = self.ratingView.frame;
    rect.origin.x = self.frame.size.width - self.ratingView.frame.size.width - MARGIN;
    rect.origin.y = self.imageView.frame.size.height + self.imageView.frame.origin.y + 4;
    self.ratingView.frame = rect;
    
    
    // Situamos el DetailTextLabel.
    rect.size.width = rect.origin.x - 14;
    rect.size.height = 200;
    rect.origin.x = MARGIN;
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font 
                                 constrainedToSize:rect.size];
    rect.size = size;
    self.detailTextLabel.frame = rect;  
}


- (void) dealloc {
    [_ratingView release];
    [super dealloc];
}

@end