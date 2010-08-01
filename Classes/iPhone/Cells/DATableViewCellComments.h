//
//  DATableViewCellComments.h
//  CINeol
//
//  Created by David Arias Vazquez on 15/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DATableViewCellComments : DATableViewCellSlide {

    @protected
    NSString  *_commentHTMLTemplate;
}

@property (nonatomic, retain, readonly) UIWebView *commentView;

- (void) loadComment:(NSString*)comment;

@end
