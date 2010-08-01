//
//  DALateralBarView.h
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DALateralBarView : UIView {

    @protected
    NSArray *_sectionTitles;
    NSInteger _numberOfSections;
    CGSize _sizeForSection;
}

@property (nonatomic, assign, readonly) NSInteger numberOfSections;
@property (nonatomic, retain, readonly) NSArray *sectionTitles;

- (id) initWithFrame:(CGRect)frame sectionTitles:(NSArray*)sections;

@end
