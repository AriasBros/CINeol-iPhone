//
//  DAGridViewCellShowtimes.m
//  Cineol
//
//  Created by David Arias Vazquez on 22/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAGridViewCellShowtimes.h"

@interface DAGridViewCellShowtimes ()

@property (nonatomic, retain, readwrite) UILabel *genreLabel;
@property (nonatomic, retain, readwrite) UILabel *durationLabel;
@property (nonatomic, retain, readwrite) UILabel *premierLabel;

@end


@implementation DAGridViewCellShowtimes

@synthesize genreLabel      = _genreLabel;
@synthesize durationLabel   = _durationLabel;
@synthesize premierLabel    = _premierLabel;

- (id) initWithStyle:(DAGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.genreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.genreLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
        self.genreLabel.font = [UIFont boldSystemFontOfSize:13];
        self.genreLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        self.genreLabel.shadowColor = [UIColor whiteColor];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.durationLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
        self.durationLabel.font = [UIFont boldSystemFontOfSize:13];
        self.durationLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        self.durationLabel.shadowColor = [UIColor whiteColor];
        
        self.premierLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.premierLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
        self.premierLabel.font = [UIFont boldSystemFontOfSize:13];
        self.premierLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        self.premierLabel.shadowColor = [UIColor whiteColor];
        
        [self addSubview:self.genreLabel];
        [self addSubview:self.durationLabel];
        [self addSubview:self.premierLabel];
                
        //TEST
        self.genreLabel.text = @"Drama / Musical";
        self.durationLabel.text = @"72 min.";
        self.premierLabel.text = @"Estreno el 25 - 6 - 2010";
    }
    
    return self;
}


- (void) portraitLayoutSubviews {    
    CGRect rect;
    
    // Situamos el ImageView.
    rect.size.width = 105;
    rect.size.height = 150;
    rect.origin.x = 8;
    rect.origin.y = 8;
    self.imageView.frame = rect;
    
    
    // Situamos el RatingView.
    rect = self.ratingView.frame;
    rect.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 6;
    rect.origin.y = self.imageView.frame.size.height - 12;
    self.ratingView.frame = rect;
    
    
    // Situamos el TextLabel.
    rect.origin.y = self.imageView.frame.origin.y;
    rect.origin.x = self.imageView.frame.size.width + self.imageView.frame.origin.x + 4;
    rect.size.width = self.frame.size.width - rect.origin.x - 8;
    rect.size.height = 75;
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font 
                                  constrainedToSize:rect.size];
    rect.size = size;
    self.textLabel.frame = rect;
    
    
    // Situamos el GenreLabel.
    rect.origin.y = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 4;
    size = [self.genreLabel.text sizeWithFont:self.genreLabel.font];
    rect.size = size;   
    self.genreLabel.frame = rect;

    
    // Situamos el DurationLabel.
    rect.origin.y = self.genreLabel.frame.origin.y + self.genreLabel.frame.size.height + 4;
    size = [self.durationLabel.text sizeWithFont:self.durationLabel.font];
    rect.size = size;   
    self.durationLabel.frame = rect;
    
    
    // Situamos el PremierLabel.
    rect.origin.y = self.durationLabel.frame.origin.y + self.durationLabel.frame.size.height + 4;
    size = [self.premierLabel.text sizeWithFont:self.premierLabel.font];
    rect.size.width = self.frame.size.width - rect.origin.x - 8;
    rect.size.height = size.height;   
    self.premierLabel.frame = rect;
    
    
    // Situamos el DetailTextLabel.
    rect.origin.x = self.imageView.frame.origin.x;
    rect.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 8;
    rect.size.width = self.frame.size.width - 16;
    rect.size.height = self.commentsButton.frame.origin.y - rect.origin.y - 8;
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
}


- (void) landscapeLayoutSubviews {
    CGRect rect;
    CGSize size;
    
    // Situamos el ImageView.
    rect.size.width = 105;
    rect.size.height = 150;
    rect.origin.x = 10;
    rect.origin.y = 16;
    self.imageView.frame = rect;
    
    
    // Situamos el TextLabel.
    rect.origin.y = 8;
    rect.origin.x = self.imageView.frame.size.width + self.imageView.frame.origin.x + 8;
    rect.size.width = self.frame.size.width - rect.origin.x - 8;
    rect.size.height = 75;
    size = [self.textLabel.text sizeWithFont:self.textLabel.font 
                           constrainedToSize:rect.size];
    rect.size = size;
    self.textLabel.frame = rect;
    
    
    // Situamos el DurationLabel.
    size = [self.durationLabel.text sizeWithFont:self.durationLabel.font];
    rect.size = size;
    rect.origin.y = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 4;
    rect.origin.x = self.frame.size.width - rect.size.width - 8;
    self.durationLabel.frame = rect;
    
    
    // Situamos el GenreLabel.
    rect.origin.x = self.textLabel.frame.origin.x;
    rect.origin.y = self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 4;
    size = [self.genreLabel.text sizeWithFont:self.genreLabel.font];
    rect.size.height = size.height;
    rect.size.width = self.frame.size.width - rect.origin.x - self.durationLabel.frame.size.width - 14;
    self.genreLabel.frame = rect;
    
    
    // Situamos el PremierLabel.
    rect.origin.x = self.textLabel.frame.origin.x;
    rect.origin.y = self.durationLabel.frame.origin.y + self.durationLabel.frame.size.height + 4;
    size = [self.premierLabel.text sizeWithFont:self.premierLabel.font];
    rect.size.width = self.frame.size.width - rect.origin.x - self.ratingView.frame.size.width - 14;
    rect.size.height = size.height;   
    self.premierLabel.frame = rect;
    
    
    // Situamos el RatingView.
    rect = self.ratingView.frame;
    rect.origin.x = self.frame.size.width - rect.size.width - 8;
    rect.origin.y = self.premierLabel.frame.origin.y;
    self.ratingView.frame = rect;
    
    
    // Situamos el DetailTextLabel.
    rect.origin.x = self.textLabel.frame.origin.x;
    rect.origin.y = self.premierLabel.frame.origin.y + self.premierLabel.frame.size.height + 4;
    rect.size.width = self.frame.size.width - rect.origin.x - 16;
    rect.size.height = self.commentsButton.frame.origin.y - rect.origin.y - 8;
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
}

@end
