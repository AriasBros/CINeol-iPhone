//
//  DAGridViewCellNews.m
//  Cineol
//
//  Created by David Arias Vazquez on 21/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAGridViewCellNews.h"

@interface DAGridViewCellNews ()

@property (nonatomic, retain) CAGradientLayer       *backgroundLayer;
@property (nonatomic, retain, readwrite) UIButton   *readMoreButton;
@property (nonatomic, retain, readwrite) UIButton   *commentsButton;

@end


@implementation DAGridViewCellNews

@synthesize backgroundLayer = _backgroundLayer;
@synthesize readMoreButton  = _readMoreButton;
@synthesize commentsButton  = _commentsButton;

- (id)initWithStyle:(DAGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];

        self.textLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
        self.textLabel.shadowColor = [UIColor whiteColor];
        self.textLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 3;
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        
        self.detailTextLabel.textColor = [UIColor grayColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        
        UIImage *normal = [[UIImage imageNamed:@"DAReadMoreButtonBackgroundNormal.png"]
                           stretchableImageWithLeftCapWidth:16 topCapHeight:0];   
        
        UIImage *highlighted = [[UIImage imageNamed:@"DAReadMoreButtonBackgroundHighlighted.png"]
                                stretchableImageWithLeftCapWidth:16 topCapHeight:0];   
        
        self.readMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readMoreButton.frame = CGRectMake(0.0, 0.0, 100, 34);
        self.readMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.readMoreButton.reversesTitleShadowWhenHighlighted = YES;
        self.readMoreButton.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.readMoreButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0, -12.0, 0.0, 0.0);
        
        [self.readMoreButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0] 
                                  forState:UIControlStateNormal];
        
        [self.readMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [self.readMoreButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.readMoreButton setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:1.0] 
                                        forState:UIControlStateHighlighted];
        
        [self.readMoreButton setBackgroundImage:normal forState:UIControlStateNormal];
        [self.readMoreButton setBackgroundImage:highlighted forState:UIControlStateHighlighted];
        
        
        normal = [[UIImage imageNamed:@"DACommentsButtonBackgroundNormal.png"]
                  stretchableImageWithLeftCapWidth:24 topCapHeight:0];   
        
        highlighted = [[UIImage imageNamed:@"DACommentsButtonBackgroundHighlighted.png"]
                        stretchableImageWithLeftCapWidth:24 topCapHeight:0];   
        
        self.commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentsButton.frame = CGRectMake(0.0, 0.0, 50, 34);
        self.commentsButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.commentsButton.reversesTitleShadowWhenHighlighted = YES;
        self.commentsButton.titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        self.commentsButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0, 16.0, 0.0, 0.0);
        
        [self.commentsButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1.0] 
                                  forState:UIControlStateNormal];
        
        [self.commentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [self.commentsButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.commentsButton setTitleShadowColor:[UIColor colorWithWhite:0.3 alpha:1.0] 
                                        forState:UIControlStateHighlighted];
        
        [self.commentsButton setBackgroundImage:normal forState:UIControlStateNormal];
        [self.commentsButton setBackgroundImage:highlighted forState:UIControlStateHighlighted];

        
        [self addSubview:self.readMoreButton];
        [self addSubview:self.commentsButton];
        
        self.layer.cornerRadius  = 5.0;        
        self.layer.shadowOffset  = CGSizeMake(1.0, 1.0);
        self.layer.shadowColor   = [[UIColor grayColor] CGColor];
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius  = 2.0;
        
        self.backgroundLayer = [[CAGradientLayer alloc] init];
        
        self.backgroundLayer.colors = [NSArray arrayWithObjects:
                                       (id)[[UIColor colorWithWhite:1.0 alpha:1.0] CGColor], 
                                       (id)[[UIColor colorWithWhite:0.9 alpha:0.3] CGColor], nil];
        
        self.backgroundLayer.startPoint = CGPointMake(0.5, 0.6);
        self.backgroundLayer.endPoint   = CGPointMake(0.5, 1.0);
        self.backgroundLayer.cornerRadius = self.layer.cornerRadius;
        
        [self.backgroundView.layer addSublayer:self.backgroundLayer];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        // TEMP
        //self.imageView.backgroundColor = [UIColor redColor];
        //self.textLabel.backgroundColor = [UIColor blueColor];
        //self.detailTextLabel.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}

- (void) portraitLayoutSubviews {
    CGRect rect;
    
    // Situamos el ImageView.
    rect.size.width = self.frame.size.width - 16;
    rect.size.height = 120;
    rect.origin.x = (self.frame.size.width - rect.size.width) / 2;
    rect.origin.y = 8;
    self.imageView.frame = rect;
    
    // Situamos el TextLabel.
    rect = CGRectMake(rect.origin.x, rect.size.height + rect.origin.y + 4, rect.size.width, 50);
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
}

- (void) landscapeLayoutSubviews {
    CGRect rect;
    
    // Situamos el TextLabel.
    rect = CGRectMake(10, 12, self.frame.size.width - 16, 500);
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font 
                                  constrainedToSize:rect.size];
    rect.size = size;
    self.textLabel.frame = rect;

    
    // Situamos el CommentsButton.
    rect.origin.x = 10;
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
    rect.origin.x = self.frame.size.width - rect.size.width - 10;
    self.readMoreButton.frame = rect;

    
    // Situamos el ImageView.
    rect.origin.y = self.textLabel.frame.size.height + self.textLabel.frame.origin.y + 4;
    rect.origin.x = 10;
    rect.size.width = 120;
    rect.size.height = 100;
    self.imageView.frame = rect;

    
    // Situamos el DetailTextLabel.
    rect.origin.x = rect.size.width + rect.origin.x + 4;
    rect.size.width = self.frame.size.width - rect.origin.x;
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font 
                                 constrainedToSize:rect.size];
    rect.size = size;
    self.detailTextLabel.frame = rect;    
}

- (void) layoutSubviews {
    [super layoutSubviews];
        
    CGRect rect = self.frame;
    rect.origin.x = 0.0;
    rect.origin.y = 0.0;
    
    self.backgroundView.frame = rect;
    self.backgroundLayer.frame = rect;
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        [self portraitLayoutSubviews];
    else
        [self landscapeLayoutSubviews];
}


- (void) dealloc {
    [_backgroundLayer release];
    [_readMoreButton release];
    [_commentsButton release];
    [super dealloc];
}

@end
