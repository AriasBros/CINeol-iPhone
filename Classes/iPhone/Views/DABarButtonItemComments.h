//
//  DABarButtonItemComments.h
//  CINeol
//
//  Created by David Arias Vazquez on 14/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DABarButtonItemComments : UIButton {

    @protected
    NSUInteger  _numberOfComments;
    UIButton    *_overlay;
    
    SEL _selector;
    id  _target;
}

@property (nonatomic, assign) NSUInteger numberOfComments;

@property (nonatomic, assign, readonly) SEL action;
@property (nonatomic, assign, readonly) id  target;

- (id) initWithNumberOfComments:(NSUInteger)comments;
- (id) initWithNumberOfComments:(NSUInteger)comments target:(id)target action:(SEL)selector;

@end
