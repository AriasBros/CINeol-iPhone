//
//  DALateralBarView.m
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DALateralBarView.h"
#import "DALateralBarItem.h"

@interface DALateralBarView ()

@property (nonatomic, retain, readwrite) NSArray *sectionTitles;

- (void) createSectionWithTitle:(NSString*)title atIndex:(NSInteger)index;

@end


@implementation DALateralBarView

@synthesize numberOfSections = _numberOfSections;
@synthesize sectionTitles = _sectionTitles;

- (id) initWithFrame:(CGRect)frame sectionTitles:(NSArray*)sections {
    if ((self = [super initWithFrame:frame])) {
        _numberOfSections = [sections count];
        
        _sizeForSection.width = frame.size.width;
        _sizeForSection.height = (frame.size.height - 15 * _numberOfSections) / _numberOfSections;
        
        int section = 0;
        for (NSString *title in sections)
            [self createSectionWithTitle:title atIndex:section++];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DALateralBarBackgroundPattern.png"]];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|
                                UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleTopMargin;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame sectionTitles:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -
#pragma mark Private Methods.
- (void) createSectionWithTitle:(NSString*)title atIndex:(NSInteger)index {
    CGRect rect = CGRectZero;
    rect.origin.y = _sizeForSection.height * index;
    rect.size = _sizeForSection;
    
    DALateralBarItem *section = [[DALateralBarItem alloc] initWithFrame:rect title:title];
    [self addSubview:section];
    
    //section.backgroundColor = [UIColor colorWithWhite:0.3 * index alpha:1.0];
}


#pragma mark -
#pragma mark Memory Management.
- (void)dealloc {
    [super dealloc];
}

@end