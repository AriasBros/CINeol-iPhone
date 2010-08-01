//
//  DACommentView.h
//  CINeol
//
//  Created by David Arias Vazquez on 28/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DACommentView : UIView <UIWebViewDelegate> {

    @protected
    UILabel     *_userLabel;
    UILabel     *_dateLabel;
    UIWebView   *_messageView;
    
    NSString    *_messageHTMLTemplate;
}

@property (nonatomic, retain, readonly) UILabel     *userLabel;
@property (nonatomic, retain, readonly) UILabel     *dateLabel;
//@property (nonatomic, retain, readonly) UIWebView   *messageView;

- (void) loadMessage:(NSString*)message;

@end
