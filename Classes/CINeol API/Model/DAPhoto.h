//
//  DAPhoto.h
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DAMovie;

@interface DAPhoto :  NSManagedObject {
    
    @private
    struct {
        unsigned int downloandingThumbnail:1;
        unsigned int downloandingPhoto:1;
    } _photoFlags;
}

@property (nonatomic, assign) NSUInteger galleryID;
@property (nonatomic, assign) NSUInteger photoID;
@property (nonatomic, retain) UIImage   *photo;
@property (nonatomic, retain) UIImage   *thumbnail;
@property (nonatomic, copy) NSString  *photoURL;
@property (nonatomic, copy) NSString  *thumbnailURL;

@property (nonatomic, assign) BOOL      isPhotoLoaded;
@property (nonatomic, assign) BOOL      isThumbnailLoaded;

@property (nonatomic, retain) DAMovie *movie;
@property (nonatomic, retain) DAMovie *gallery;

@end