    //
//  DAContentViewController.m
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DAContentViewController.h"
#import "DAContentViewItem.h"
#import "DAGridViewCellNews.h"
#import "DAGridViewCellReviews.h"
#import "DAGridViewCellShowtimes.h"

#define SHADOW_WIDTH 9
#define NEWS_SECTION        0
#define SHOWTIMES_SECTION   1
#define REVIEWS_SECTION     2

@interface DAContentViewController ()

@property (nonatomic, retain) UIImageView *leftShadow;
@property (nonatomic, retain) UIImageView *rightShadow;

- (void) createSections;
- (UIImageView*) configureShadowViewWithShadow:(UIImage*)shadow withFrame:(CGRect)frame;

@end



@implementation DAContentViewController

@synthesize leftShadow  = _leftShadow;
@synthesize rightShadow = _rightShadow;

- (id) initWithNumberOfSections:(NSInteger)sections {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _numberOfSections = sections;
    }
    
    return self;
}


- (void)loadView {
    [super loadView];
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0.0;
    self.view.frame = rect;
    
    [self createSections];
    
    rect = CGRectZero;
    rect.size.width = SHADOW_WIDTH;
    rect.size.height = self.view.frame.size.height;
    
    self.leftShadow = [self configureShadowViewWithShadow:[UIImage imageNamed:@"DAContentViewLeftShadowPattern.png"]
                                                withFrame:rect];
    
    rect.origin.x = self.view.frame.size.width - rect.size.width;
    self.rightShadow = [self configureShadowViewWithShadow:[UIImage imageNamed:@"DAContentViewRightShadowPattern.png"]
                                                 withFrame:rect];
    
    [self.view addSubview:self.leftShadow];
    [self.view addSubview:self.rightShadow];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private Methods.
- (UIImageView*) configureShadowViewWithShadow:(UIImage*)shadow withFrame:(CGRect)frame {
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:frame];

    shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight|
                                  UIViewAutoresizingFlexibleRightMargin|
                                  UIViewAutoresizingFlexibleLeftMargin;
    shadowView.image = shadow;

    return [shadowView autorelease];
}

- (void) createSections {    
    _sizeForSection.width = self.view.frame.size.width;
    _sizeForSection.height = (self.view.frame.size.height - 15 * _numberOfSections) / _numberOfSections;
    
    CGRect rect = CGRectZero;
    rect.size = _sizeForSection;
    for (int i = 0; i < _numberOfSections; i++) {
        rect.origin.y = _sizeForSection.height * i;
        DAContentViewItem *view = [[DAContentViewItem alloc] initWithFrame:rect];
        
        view.gridView.pagingEnabled = NO;
        view.gridView.showsVerticalScrollIndicator = NO;
        view.gridView.showsHorizontalScrollIndicator = NO;
        view.gridView.delegate      = self;
        view.gridView.dataSource    = self;
        view.gridView.tag           = i;
        
        [self.view addSubview:view];        
        
        [view release];
    }
}


#pragma mark -
#pragma mark DAGridView DataSource Methods.
- (DAGridViewCell*) gridView: (DAGridView*) gridView cellForItemAtIndexPath: (NSIndexPath*) indexPath {
    
    static NSString *CellIdentifier = @"DAGridViewCell";
    
    int tag = gridView.tag;
    
    DAGridViewCellNews *cell = (DAGridViewCellNews*)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        
        switch (tag) {
            case NEWS_SECTION:
            default:
                cell = [[[DAGridViewCellNews alloc] initWithStyle: DAGridViewCellStyleSubtitle
                                                  reuseIdentifier: CellIdentifier] autorelease];
                [cell.readMoreButton setTitle:@"Leer más" forState:UIControlStateNormal];
                break;
                
            case REVIEWS_SECTION:
                cell = [[[DAGridViewCellReviews alloc] initWithStyle: DAGridViewCellStyleSubtitle
                                                     reuseIdentifier: CellIdentifier] autorelease];
                [cell.readMoreButton setTitle:@"Leer más" forState:UIControlStateNormal];
                break;
                
            case SHOWTIMES_SECTION:
                cell = [[[DAGridViewCellShowtimes alloc] initWithStyle: DAGridViewCellStyleSubtitle
                                                       reuseIdentifier: CellIdentifier] autorelease];
                [cell.readMoreButton setTitle:@"Ver ficha" forState:UIControlStateNormal];
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.commentsButton setTitle:@"999" forState:UIControlStateNormal];
    }
    
    if (gridView.tag == NEWS_SECTION) {
        //cell.imageView.image = [UIImage imageNamed:@"news_testing.jpg"];
        //cell.textLabel.text = @"Spielberg comenzará a rodar en agosto 'War Horse' 'War Horse' 'War Horse'";
        //cell.detailTextLabel.text = @"La odisea de un caballo en medio de las trincheras del frente francés de la Primera Guerra Mundial";
    }
    else if (gridView.tag == REVIEWS_SECTION) {
        //cell.imageView.image = [UIImage imageNamed:@"reviews_testing.jpg"];
        //cell.textLabel.text = @"The Blind side (Un sueño posible)";
        //cell.detailTextLabel.text = @"'Nunca te fíes de un enterrador… con una boina francesa'";
    }
    else {
        //cell.imageView.image = [UIImage imageNamed:@"showtimes_testing.jpg"];
        //cell.textLabel.text = @"Anvil. El Sueño de una banda de rock";
        //cell.detailTextLabel.text = @"Venecia. 1763. El escritor Lorenzo Da Ponte, sacerdote en su origen, es exiliado a Viena por difundir versos contra la Iglesia y el poder de la Inquisición. Con el apoyo de Casanova, Lorenzo es presentado al maestro Salieri, compositor preferido del emperador y Mozart. Salieri empuja a Mozart a tomar a este libertino desconocido como su libretista. La naturaleza de Lorenzo será una fuente de inspiración para una de sus obras más audaces y de mayor alcance: Don Giovanni.";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %i -- Column: %i", indexPath.row, indexPath.column];
    
    return cell;    
}


- (NSInteger) numbersOfItemsInGridView: (DAGridView*) gridView {
    return 10;
}


#pragma mark -
#pragma mark DAGridView Delegate Methods.
- (CGSize) sizeForItemsInGridView: (DAGridView*) gridView {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        switch (gridView.tag) {
            case NEWS_SECTION:
            default:
                return CGSizeMake(330, 195);

            case SHOWTIMES_SECTION:
                return CGSizeMake(390, 215);
                
            case REVIEWS_SECTION:
                return CGSizeMake(324, 215);
        }
    }
    else {
        switch (gridView.tag) {
            case NEWS_SECTION:
            default:
                return CGSizeMake(250, 280);
                
            case SHOWTIMES_SECTION:
                return CGSizeMake(300, 290);
                
            case REVIEWS_SECTION:
                return CGSizeMake(250, 280);
        }        
    }
}

- (CGSize) spacingForItemsInGridView: (DAGridView*) gridView {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        switch (gridView.tag) {
            case NEWS_SECTION:
            default:
                return CGSizeMake(12, 22);
                
            case SHOWTIMES_SECTION:
                return CGSizeMake(12, 10);
                
            case REVIEWS_SECTION:
                return CGSizeMake(12, 10);
        }        
    }
    else {
        switch (gridView.tag) {
            case NEWS_SECTION:
            default:
                return CGSizeMake(12, 20);
                
            case SHOWTIMES_SECTION:
                return CGSizeMake(12, 14);
                
            case REVIEWS_SECTION:
                return CGSizeMake(12, 20);
        }        
    }
}

#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.leftShadow = nil;
    self.rightShadow = nil;
}


- (void)dealloc {
    [_leftShadow release];
    [_rightShadow release];
    
    [super dealloc];
}


@end
