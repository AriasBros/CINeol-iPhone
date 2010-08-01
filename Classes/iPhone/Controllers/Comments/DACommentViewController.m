//
//  DACommentViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 25/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACommentViewController.h"
#import "DAComment.h"
#import "DACommentView.h"

@interface DACommentViewController ()

@property (nonatomic, retain) DAComment     *comment;
@property (nonatomic, retain) DACommentView *commentView;

- (void) updateCommentView;

@end


@implementation DACommentViewController

@dynamic commentView;
@synthesize comment     = _comment;


- (id) initWithComment:(DAComment*)comment {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.comment = comment;
    }
    
    return self;
}

- (void) loadView {
    DACommentView *commentView = [[DACommentView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    commentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    self.view = commentView;
    [commentView release];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateCommentView];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [FlurryAPI logEvent:DAFlurryEventShowComment];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];    
}

- (void) updateItem:(id)item {
    self.comment = item;
}

- (void) setCommentView:(DACommentView *)view {
    self.view = view;
}

- (DACommentView*) commentView {
    return (DACommentView*)self.view;
}


#pragma mark -
#pragma mark Private Methods.
- (void) updateCommentView {
    self.commentView.userLabel.text = self.comment.user;
    self.commentView.dateLabel.text = [[DACalendar defaultCalendar] stringFromDate:self.comment.date
                                                                    withDateFormat:kCINeolDateCommentFormat];
    [self.commentView loadMessage:self.comment.message];
}


#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.commentView = nil;
}

- (void)dealloc {
    [_comment release];     _comment = nil;
    
    [super dealloc];
}


@end