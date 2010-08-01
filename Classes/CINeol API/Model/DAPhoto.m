// 
//  DAPhoto.m
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolManager.h"

#import "DAPhoto.h"
#import "DAMovie.h"


@interface DAPhoto ()

- (void) willDownloadImage:(NSNotification*)notification;
- (void) didDownloadImage:(NSNotification*)notification;
- (void) didFailToDownloadImage:(NSNotification*)notification;

@end


@implementation DAPhoto 

@dynamic galleryID;
@dynamic photoID;
@dynamic photo;
@dynamic thumbnail;
@dynamic movie;
@dynamic gallery;
@dynamic photoURL;
@dynamic thumbnailURL;

@dynamic isPhotoLoaded;
@dynamic isThumbnailLoaded;


+ (void)initialize {
	if (self == [DAPhoto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName: @"UIImageToDataTransformer"];
	}
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    _photoFlags.downloandingThumbnail = 0;
    _photoFlags.downloandingPhoto = 0;
    
    /*
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(willDownloadImage:)
     name:DACINeolWillDownloadImageNotification
     object:[DACINeolManager sharedManager]];
     */
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDownloadImage:)
                                                 name:DACINeolDidDownloadImageNotification
                                               object:[DACINeolManager sharedManager]];
    

     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(didFailToDownloadImage:)
                                                  name:DACINeolDidFailToDownloadImageNotification
                                                object:[DACINeolManager sharedManager]];
}



- (void)willTurnIntoFault {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImage*)thumbnail {
    UIImage *tmpValue;
            
    [self willAccessValueForKey:@"thumbnail"];
    tmpValue = [self primitiveValueForKey:@"thumbnail"];
    [self didAccessValueForKey:@"thumbnail"];
        
    if (tmpValue == nil && _photoFlags.downloandingThumbnail == 0 && self.thumbnailURL != nil) {
        _photoFlags.downloandingThumbnail = 1;
        [[DACINeolManager sharedManager] imageWithID:self.photoID
                                                 url:self.thumbnailURL
                                                size:DACINeolImageSizeThumbnail];
    }
    
    return tmpValue;
}

- (UIImage*)photo {
    UIImage *tmpValue;
        
    [self willAccessValueForKey:@"photo"];
    tmpValue = [self primitiveValueForKey:@"photo"];
    [self didAccessValueForKey:@"photo"];
    
    if (tmpValue == nil && _photoFlags.downloandingPhoto == 0 && self.photoURL != nil) {
        _photoFlags.downloandingPhoto = 1;
        [[DACINeolManager sharedManager] imageWithID:self.photoID
                                                 url:self.photoURL
                                                size:DACINeolImageSizeFull];        
    }
    
    return tmpValue;
}

- (BOOL) isThumbnailLoaded {
    UIImage *tmpValue;
    
    [self willAccessValueForKey:@"thumbnail"];
    tmpValue = [self primitiveValueForKey:@"thumbnail"];
    [self didAccessValueForKey:@"thumbnail"];
    
    return (tmpValue != nil);
}

- (BOOL) isPhotoLoaded {
    UIImage *tmpValue;
    
    [self willAccessValueForKey:@"photo"];
    tmpValue = [self primitiveValueForKey:@"photo"];
    [self didAccessValueForKey:@"photo"];
    
    return (tmpValue != nil);
}

- (NSUInteger)galleryID 
{    
    [self willAccessValueForKey:@"galleryID"];
    NSUInteger galleryID = [[self primitiveValueForKey:@"galleryID"] integerValue];
    [self didAccessValueForKey:@"galleryID"];
    
    return galleryID;
}

- (void)setGalleryID:(NSUInteger)value 
{
    [self willChangeValueForKey:@"galleryID"];
    [self setPrimitiveValue:[NSNumber numberWithInteger:value] forKey:@"galleryID"];
    [self didChangeValueForKey:@"galleryID"];
}

- (NSUInteger)photoID {    
    [self willAccessValueForKey:@"photoID"];
    NSUInteger photoID = [[self primitiveValueForKey:@"photoID"] integerValue];
    [self didAccessValueForKey:@"photoID"];
    
    return photoID;
}

- (void)setPhotoID:(NSUInteger)value {
    [self willChangeValueForKey:@"photoID"];
    [self setPrimitiveValue:[NSNumber numberWithInteger:value] forKey:@"photoID"];
    [self didChangeValueForKey:@"photoID"];
}

#pragma mark -
#pragma mark Private Methods.
- (void) willDownloadImage:(NSNotification*)notification {
}

- (void) didDownloadImage:(NSNotification*)notification {    
    NSUInteger ID = [[[notification userInfo] objectForKey:DACINeolImageIDUserInfoKey] integerValue];
    if (ID != self.photoID)
        return;
            
    NSData *data = [[notification userInfo] objectForKey:DACINeolDownloadedDataUserInfoKey];
    DACINeolImageSize size = [[[notification userInfo] objectForKey:DACINeolImageSizeUserInfoKey] intValue];
            
    if (size == DACINeolImageSizeThumbnail) {
        _photoFlags.downloandingThumbnail = 0;
        self.thumbnail = [UIImage imageWithData:data];
    }
    else if (size == DACINeolImageSizeFull) {  
        _photoFlags.downloandingPhoto = 0;
        self.photo = [UIImage imageWithData:data];        
    }
}

- (void) didFailToDownloadImage:(NSNotification*)notification {
    [FlurryAPI logError:DAFlurryErrorDownloadImage
                message:[[notification userInfo] description]
                  error:nil];
}

@end