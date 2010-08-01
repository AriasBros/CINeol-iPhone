//
//  DATableViewCellMovie.m
//  CINeol
//
//  Created by David Arias Vazquez on 05/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DATableViewCellMovie.h"


@interface DATableViewCellMovie ()

@property (nonatomic, retain) UILabel       *genreLabel;
@property (nonatomic, retain) UILabel       *durationLabel;
@property (nonatomic, retain) DARatingView  *ratingView;

@end

@implementation DATableViewCellMovie

@synthesize genreLabel      = _genreLabel;
@synthesize durationLabel   = _durationLabel;
@synthesize ratingView      = _ratingView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.textLabel.numberOfLines = 1;
        
        self.detailTextLabel.numberOfLines = 5;
        
        /** Por alguna razon la sombra no aparece **/
        /** SOLUCION: el imageView debe tener el atributo "clipToBounds" a NO **/
        /*
        #if __IPHONE_OS_VERSION_MIN_REQUIRED > 30000
        self.imageView.layer.shadowOffset   = CGSizeMake(4.0, 4.0);
        self.imageView.layer.shadowColor    = [[UIColor blackColor] CGColor];
        self.imageView.layer.shadowOpacity  = 1.0;
        self.imageView.layer.shadowRadius   = 8.0;
        #endif 
        */
                
        self.genreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.ratingView = [[DARatingView alloc] initWithStyle:DARatingViewStyleColorSmall];
        
        self.ratingView.numberOfItems = 5;
        self.ratingView.userInteractionEnabled = NO;
        
        self.genreLabel.font = [UIFont boldSystemFontOfSize: 12];
        self.durationLabel.font = self.genreLabel.font;
        
        self.genreLabel.highlightedTextColor = [UIColor whiteColor];
        self.durationLabel.highlightedTextColor = self.genreLabel.highlightedTextColor;
        
        self.genreLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
        self.durationLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];

        self.genreLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        self.durationLabel.shadowOffset = CGSizeMake(1.0, 1.0);

        self.genreLabel.shadowColor = [UIColor whiteColor];
        self.durationLabel.shadowColor = [UIColor whiteColor];

        
        [self.frontView addSubview:self.genreLabel];
        [self.frontView addSubview:self.durationLabel];
        [self.frontView addSubview:self.ratingView];        
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.genreLabel.shadowOffset = CGSizeMake(0.0, 0.0);
        self.durationLabel.shadowOffset = CGSizeMake(0.0, 0.0);
        self.shadowImageView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        self.genreLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        self.durationLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        self.shadowImageView.backgroundColor = [UIColor grayColor];
    }
    
    [super setHighlighted:highlighted animated:animated];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(8.0, 0.0, 60, 90);
    
    [self.textLabel sizeToFit];
    [self.genreLabel sizeToFit];
    [self.durationLabel sizeToFit];
    
    CGRect frame = CGRectZero;
        
    // Situamos el titulo de la pelicula.
    frame = self.textLabel.frame;
    frame.origin.x = self.imageView.frame.origin.x;
    frame.origin.y = 5.0;
    frame.size.width = self.frame.size.width - (self.ratingView.frame.size.width + 20);
    self.textLabel.frame = frame;
    
    // Situamos la puntuacion de la pelicula.
    frame = self.ratingView.frame;
    frame.origin.x = self.textLabel.frame.size.width + self.textLabel.frame.origin.x + 4;
    frame.origin.y = self.textLabel.frame.origin.y + 2;
    self.ratingView.frame = frame;
        
    // Situamos el género de la pelicula.
    frame = self.genreLabel.frame;
    frame.size.width = (self.frame.size.width - (self.imageView.frame.size.width + self.imageView.frame.origin.x)) - 
                       (self.durationLabel.frame.size.width + 20);
    frame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 10;
    frame.origin.y = self.textLabel.frame.size.height + self.textLabel.frame.origin.y + 4;
    self.genreLabel.frame = frame;
    
    // Situamos la duracion de la pelicula.
    frame = self.durationLabel.frame;
    frame.origin.x = self.genreLabel.frame.size.width + self.genreLabel.frame.origin.x + 4;
    frame.origin.y = self.genreLabel.frame.origin.y;
    self.durationLabel.frame = frame;
    
    // Situamos la sinopsis de la pelicula.
    frame = self.detailTextLabel.frame;
    frame.origin.x = self.genreLabel.frame.origin.x;
    frame.origin.y = self.genreLabel.frame.origin.y + self.genreLabel.frame.size.height + 4;
    frame.size.width = self.frame.size.width - frame.origin.x - 26;
    frame.size.height = self.frame.size.height - frame.origin.y - 12;
    self.detailTextLabel.frame = frame;

    // Situamos el poster de la pelicula.
    frame = self.imageView.frame;
    frame.origin.y = self.genreLabel.frame.origin.y + 4;
    self.imageView.frame = frame;
    
    // Situamos la sombra del poster.
    frame.origin.x += 2;
    frame.origin.y += 2;
    self.shadowImageView.frame = frame;
}


- (void)dealloc {
    [_genreLabel release];
    [_durationLabel release];
    [_ratingView release];
    [super dealloc];
}

@end
