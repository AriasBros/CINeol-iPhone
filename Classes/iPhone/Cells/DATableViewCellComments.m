//
//  DATableViewCellComments.m
//  CINeol
//
//  Created by David Arias Vazquez on 15/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DATableViewCellComments.h"

@interface DATableViewCellComments ()

@property (nonatomic, retain) UIWebView *commentView;
@property (nonatomic, copy)   NSString  *commentHTMLTemplate;

@end


@implementation DATableViewCellComments

@synthesize commentView         = _commentView;
@synthesize commentHTMLTemplate = _commentHTMLTemplate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.accessoryView = nil;
        [self.shadowView removeFromSuperview];
        
        self.commentView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.commentView.userInteractionEnabled = NO;
        self.commentView.opaque = YES;
        self.commentView.backgroundColor = [UIColor whiteColor];
        [self.frontView addSubview:self.commentView];
        [self.commentView release];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"movie-row-comment-template"
                                                         ofType:@"html"];            
        self.commentHTMLTemplate = [NSString stringWithContentsOfFile:path 
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
    }
    
    return self;
}

/*
- (void) prepareForReuse {
    [super prepareForReuse];
}
*/

- (void) loadComment:(NSString*)comment {
    comment = [NSString stringWithFormat:self.commentHTMLTemplate, comment];
    [self.commentView loadHTMLString:comment baseURL:[NSURL URLWithString:nil]];
}


- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.commentView.opaque = NO;
        self.commentView.backgroundColor = [UIColor clearColor];
        [self.commentView stringByEvaluatingJavaScriptFromString:@"setCommentHighlighted(true);"];
    }
    else {
        self.commentView.opaque = YES;
        self.commentView.backgroundColor = [UIColor whiteColor];
        [self.commentView stringByEvaluatingJavaScriptFromString:@"setCommentHighlighted(false);"];
    }
    
    [super setHighlighted:highlighted animated:animated];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.textLabel.frame;
    frame.origin.y = 6.0;
    self.textLabel.frame = frame;
    
    frame = self.detailTextLabel.frame;
    frame.origin.y = self.textLabel.frame.origin.y + 1;
    frame.size.height = self.textLabel.frame.size.height;
    self.detailTextLabel.frame = frame;
    
    frame = self.bounds;
    frame.origin.y = self.textLabel.frame.size.height + self.textLabel.frame.origin.y;
    frame.size.width -= 20;
    frame.size.height = frame.size.height - self.textLabel.frame.size.height - self.textLabel.frame.origin.y - 1;
    self.commentView.frame = frame;
}


- (void)dealloc {
    [super dealloc];
}


@end