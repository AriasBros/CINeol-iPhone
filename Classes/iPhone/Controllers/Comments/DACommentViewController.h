//
//  DACommentViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 25/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAComment;
@class DACommentView;

@interface DACommentViewController : DAPageViewController {

    @protected
    DAComment     *_comment;
}

- (id) initWithComment:(DAComment*)comment;

@end
