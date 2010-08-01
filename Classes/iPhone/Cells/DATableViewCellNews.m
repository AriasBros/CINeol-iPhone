//
//  DATableViewCellNews.m
//  Cineol
//
//  Created by David Arias Vazquez on 11/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DATableViewCellNews.h"

#define IMAGE_SIZE 60

@interface DATableViewCellNews ()

@property (nonatomic, retain) UIView *shadowImageView;

@end

@implementation DATableViewCellNews

@synthesize shadowImageView = _shadowImageView;


#pragma mark -
#pragma mark Class Methods.
+ (CGSize) constrainSizeForLabels {

    float width = [UIScreen mainScreen].bounds.size.width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        width = [UIScreen mainScreen].bounds.size.height;
    
    return CGSizeMake(width - IMAGE_SIZE - 40, 20000.0f);
}

+ (CGFloat) heightForImageView {
    return 76.0;
}

+ (UIFont*) fontForTextLabel {
    return [UIFont boldSystemFontOfSize:14];
}

+ (UIFont*) fontForDetailTextLabel {
    return [UIFont systemFontOfSize:13];
}


#pragma mark -
#pragma mark -
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        self.textLabel.font = [DATableViewCellNews fontForTextLabel];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        
        self.detailTextLabel.font = [DATableViewCellNews fontForDetailTextLabel];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
        self.detailTextLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        self.detailTextLabel.shadowColor = [UIColor whiteColor];
        
        self.accessoryView = nil;
        
        self.shadowImageView = [[UIView alloc] initWithFrame:CGRectZero];
        self.shadowImageView.backgroundColor = [UIColor grayColor];
        [self.frontView addSubview:self.shadowImageView];
    }
    
    return self;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated; {
    
    if (highlighted) {
        self.textLabel.shadowOffset = CGSizeMake(0.0, 0.0);
        self.detailTextLabel.shadowOffset = CGSizeMake(0.0, 0.0);
    }
    else {
        self.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        self.detailTextLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    }

    [super setHighlighted:highlighted animated:animated];
}

- (CGSize) sizeForLabel:(UILabel*)label {
    return [label.text sizeWithFont:label.font 
                  constrainedToSize:[DATableViewCellNews constrainSizeForLabels]];;
}

- (void) layoutSubviews {
    [super layoutSubviews];

    float swap = 0;
    CGRect frame = CGRectZero;

    // Situamos la imagen de la noticia.
    frame = self.imageView.frame;
    frame.size.width = 60;
    frame.size.height = 60;
    frame.origin.x = 8.0;
    frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
    self.imageView.frame = frame;

    // Situamos la sombra de la imagen.
    frame = self.imageView.frame;
    frame.origin.x += 2;
    frame.origin.y += 2;
    self.shadowImageView.frame = frame;    

    // Situamos el titulo de la noticia.
    frame = self.textLabel.frame;
    frame.origin.x = self.imageView.frame.size.width + self.imageView.frame.origin.x + 10;
    frame.size = [self sizeForLabel:self.textLabel];
    self.textLabel.frame = frame;
    
    // Situamos la descripcion de la noticia.
    frame = self.detailTextLabel.frame;
    frame.origin.x = self.textLabel.frame.origin.x;
    frame.size = [self sizeForLabel:self.detailTextLabel];
    self.detailTextLabel.frame = frame;        
    
    
    // Centramos el titulo y la descripcion de la noticia en relacion a la altura de la cell.
    frame = self.textLabel.frame;
    swap = self.textLabel.frame.size.height + self.detailTextLabel.frame.size.height + 4;
    frame.origin.y = (self.frame.size.height - swap) / 2;
    self.textLabel.frame = frame;
    
    swap = frame.origin.y;
    frame = self.detailTextLabel.frame;
    frame.origin.y = swap + self.textLabel.frame.size.height + 4;
    self.detailTextLabel.frame = frame;
}

- (void)dealloc {
    [_shadowImageView release];
    [super dealloc];
}


@end
