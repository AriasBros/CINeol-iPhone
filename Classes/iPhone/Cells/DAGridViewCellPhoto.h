//
//  DAGridViewCellPhoto.h
//  CINeol
//
//  Created by David Arias Vazquez on 16/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAGridViewCellPhoto : DAGridViewCell {

    @protected
    UIImage *_placeholderImage;
    
    @private
    struct {
        unsigned int settingPlaceholder:1;
    } _gridViewCellPhotoFlags;
}

@end
