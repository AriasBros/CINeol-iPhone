//
//  DAGridViewCellPhoto.m
//  CINeol
//
//  Created by David Arias Vazquez on 16/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAGridViewCellPhoto.h"


@interface DAGridViewCellPhoto ()

@property (nonatomic, retain) UIImage *placeholderImage;

@end


@implementation DAGridViewCellPhoto

@synthesize placeholderImage = _placeholderImage;

- (id)initWithStyle:(DAGridViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _gridViewCellPhotoFlags.settingPlaceholder = 0;
        self.placeholderImage = [UIImage imageNamed:@"DAPhotoThumbnailPlaceholder.png"];
        
        [self.imageView addObserver:self forKeyPath:@"image" options:0 context:NULL];
        
        self.borderColor = [UIColor lightGrayColor];
        //self.layer.shouldRasterize = YES;
        //self.imageView.layer.shouldRasterize = YES;
    }
    
    return self;
}


- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change 
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        if (self.imageView.image == nil) {
            _gridViewCellPhotoFlags.settingPlaceholder = true;
            self.borderWidth = 0.0;
            self.imageView.image = self.placeholderImage;
        }
        else if (_gridViewCellPhotoFlags.settingPlaceholder == true) {
            _gridViewCellPhotoFlags.settingPlaceholder = false;
        }
        else {
            self.borderWidth = 1.0;
        }
    }
}


- (void)dealloc {
    [_placeholderImage release]; _placeholderImage = nil;
    [super dealloc];
}


@end
