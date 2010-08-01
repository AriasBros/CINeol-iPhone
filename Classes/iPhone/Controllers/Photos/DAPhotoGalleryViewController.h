//
//  DAPhotoGalleryViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 16/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAPhotoGalleryViewController : DAGridViewController <DASlideViewControllerDelegate>
{
    @protected
    NSArray *_photos;
    DASlideViewController *_photosViewerController;
    
    struct {
        unsigned int showingPhotoViewer:1;
    } _photoGalleryViewController;
}

- (id) initWithPhotos:(NSArray*)photos;

@end
