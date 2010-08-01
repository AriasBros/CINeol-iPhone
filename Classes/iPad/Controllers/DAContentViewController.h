//
//  DAContentViewController.h
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAContentViewController : UIViewController <DAGridViewDelegate, DAGridViewDataSource>
{
    @protected
    NSInteger _numberOfSections;
    CGSize _sizeForSection;

    UIImageView *_leftShadow;
    UIImageView *_rightShadow;
}

- (id) initWithNumberOfSections:(NSInteger)sections;

@end
