    //
//  DAPhotoGalleryViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 16/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAPhotoGalleryViewController.h"
#import "DAPhoto.h"
#import "DAGridViewCellPhoto.h"

@interface DAPhotoGalleryViewController ()

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) DASlideViewController *photosViewerController;

@end


@implementation DAPhotoGalleryViewController

@synthesize photos = _photos;
@synthesize photosViewerController = _photosViewerController;


- (id) initWithPhotos:(NSArray*)photos {
    if (self = [super initWithStyle:DAGridViewStyleNormalScroll]) {
        self.photos = photos;
        _photoGalleryViewController.showingPhotoViewer = false;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Galería"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _photoGalleryViewController.showingPhotoViewer = false;
    [self.navigationController setToolbarHidden:YES animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) setPhotos:(NSArray *)photos {
    if (_photos != photos) {        
        self.title = [NSString stringWithFormat:@"%i fotos", [photos count]];        

        NSRange range = NSMakeRange(0, [_photos count]);
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndexesInRange:range];
        
        [_photos removeObserver:self fromObjectsAtIndexes:set forKeyPath:@"thumbnail"];
        [_photos removeObserver:self fromObjectsAtIndexes:set forKeyPath:@"photo"];
        [set removeAllIndexes];
        
        [_photos release];
        _photos = photos;
        [_photos retain];
        
        range = NSMakeRange(0, [_photos count]);
        [set addIndexesInRange:range];
        
        [_photos addObserver:self 
          toObjectsAtIndexes:set 
                  forKeyPath:@"thumbnail" 
                     options:0 
                     context:NULL];
        
        [_photos addObserver:self
          toObjectsAtIndexes:set 
                  forKeyPath:@"photo"
                     options:0
                     context:NULL];
        
        [set release];        
    }
}

- (DASlideViewController*) photosViewerController {
    if (_photosViewerController == nil) {
        DASlideViewController *controller = [[DASlideViewController alloc] 
                                             initWithNumberOfSlides:[_photos count] 
                                                              type:DASlideViewControllerTypePhotoViewer
                                                             style:DASlideViewControllerStyleFullScreen];
        self.photosViewerController = controller;
        [controller release];
        
        _photosViewerController.delegate = self;
        _photosViewerController.titleFormat = @"%i de %i";
    }
    
    return _photosViewerController;
}


#pragma mark -
#pragma mark Key Value Observing Methods.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"thumbnail"] && [object isThumbnailLoaded]) {
        [self.gridView reloadData];
    }
    else if (_photoGalleryViewController.showingPhotoViewer == true &&
             [keyPath isEqualToString:@"photo"]                     &&
             [object isPhotoLoaded])
    {
        NSUInteger index = [_photos indexOfObject:object];
        [self.photosViewerController reloadSlideAtIndex:index];
    }

}


#pragma mark Grid View Data Source Methods
- (DAGridViewCell*) gridView: (DAGridView*) gridView cellForItemAtIndexPath: (NSIndexPath*) indexPath {    
    static NSString *CellIdentifier = @"DAGridViewCell";
        
    DAGridViewCellPhoto *cell = (DAGridViewCellPhoto*)[self.gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[[DAGridViewCellPhoto alloc] initWithStyle:DAGridViewCellStyleOnlyImage
                                           reuseIdentifier:CellIdentifier] autorelease];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;        
    }

    indexPath = [indexPath classicIndexPathForGridView: self.gridView];
    DAPhoto *photo = [_photos objectAtIndex:indexPath.row];
        
    cell.imageView.image = photo.thumbnail;

    return cell;    
}


- (NSInteger) numbersOfItemsInGridView: (DAGridView*) gridView {
    return [_photos count];
}

#pragma mark -
#pragma mark GridView Delegate Methods.
- (CGSize) sizeForItemsInGridView: (DAGridView*) gridView {
    return CGSizeMake(75, 75);
}

- (CGSize) spacingForItemsInGridView: (DAGridView*) gridView {
    return CGSizeMake(4, 4);
}

- (void) gridView:(DAGridView*) gridView didSelectItemAtIndexPath:(NSIndexPath*) indexPath {
    indexPath = [indexPath classicIndexPathForGridView: self.gridView];        
    [self.photosViewerController scrollToSlide:indexPath.row animated:NO];
    [self.navigationController pushViewController:self.photosViewerController animated:YES];
    _photoGalleryViewController.showingPhotoViewer = true;
}


#pragma mark -
#pragma mark DAPageScrollViewController Delegate Methods.
- (UIView*) slideViewController:(DASlideViewController*)controller
                    pageAtIndex:(NSUInteger)index
{
    DAPhoto *photo = [_photos objectAtIndex:index];
    DASlideView *slide = [controller dequeueReusableSlide];
    if (slide == nil) {
        slide = [[[DASlideView alloc] initWithFrame:CGRectZero] autorelease];
        slide.textLabel.text = @"Descargando imagen...";
    }
    
    slide.imageView.image = photo.photo;
        
    return slide;
}


#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
    
    if (_photosViewerController.view.superview == nil)
        self.photosViewerController = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    NSRange range = NSMakeRange(0, [_photos count]);
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndexesInRange:range];
    
    [_photos removeObserver:self fromObjectsAtIndexes:set forKeyPath:@"thumbnail"];    
    [_photos removeObserver:self fromObjectsAtIndexes:set forKeyPath:@"photo"];    
    [set release]; set = nil;
    
    [_photos release];                  _photos = nil;
    [_photosViewerController release];  _photosViewerController = nil;
    
    [super dealloc];
}

@end