//
//  DACommentView.m
//  CINeol
//
//  Created by David Arias Vazquez on 28/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACommentView.h"
#import "DACINeolManager.h"

#define DATE_LABEL_WIDTH 125

@interface DACommentView ()

@property (nonatomic, retain) UILabel     *userLabel;
@property (nonatomic, retain) UILabel     *dateLabel;
@property (nonatomic, retain) UIWebView   *messageView;

@property (nonatomic, copy)   NSString    *messageHTMLTemplate;

- (CGFloat) initHeaderView;

@end

@implementation DACommentView

@synthesize userLabel           = _userLabel;
@synthesize dateLabel           = _dateLabel;
@synthesize messageView         = _messageView;
@synthesize messageHTMLTemplate = _messageHTMLTemplate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        CGFloat h = [self initHeaderView];
        
        frame.origin.y = h;
        frame.origin.x = 0.0;
        frame.size.height -= h;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:webView];
        [webView release];
        
        self.messageView = webView;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"movie-comment-template"
                                                         ofType:@"html"];            
        self.messageHTMLTemplate = [NSString stringWithContentsOfFile:path 
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods.
- (void) loadMessage:(NSString*)message {
    NSURL *URL = [[NSURL alloc] initWithString:DACINeolURLBase];
    message = [NSString stringWithFormat:self.messageHTMLTemplate, message];

    [self.messageView loadHTMLString:message baseURL:URL];
    [URL release];
}


#pragma mark -
#pragma mark UIWebView Delegate Methods.
- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return (navigationType == UIWebViewNavigationTypeOther);
}



#pragma mark -
#pragma mark Private Methods.
- (CGFloat) initHeaderView {
    CGRect frame = self.bounds;
    frame.size.height = 30;
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerView.backgroundColor = [UIColor colorWithWhite:236.0/255 alpha:1.0];
    
    /** BORDERS **/
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 1, 
                                                                  frame.size.width, 1)];
    borderView.backgroundColor = [UIColor colorWithWhite:150.0/255 alpha:1.0];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:borderView];
    [borderView release];
    
    borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 2, 
                                                          frame.size.width, 1)];
    borderView.backgroundColor = [UIColor colorWithWhite:210.0/255 alpha:1.0];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:borderView];
    [borderView release];
    
    borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, 1.0)];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    borderView.backgroundColor = [UIColor colorWithRed:245.0/255 green:250.0/255 blue:246.0/255 alpha:1.0];
    [headerView addSubview:borderView];
    [borderView release];
    
    
    CGFloat n = DATE_LABEL_WIDTH + 8; // Ancho del dateLabel + 4 de margen entre las labels + 4 de margen derecho.
    
    /** UserLabel **/
    frame = headerView.bounds;
    frame.size.height = [UIFont boldSystemFontOfSize:16].leading;
    frame.size.width  -= (n + 4);
    frame.origin.x = 4;
    frame.origin.y = (headerView.frame.size.height - frame.size.height) / 2;
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:frame];

    userLabel.textAlignment = UITextAlignmentLeft;
    userLabel.font = [UIFont boldSystemFontOfSize:16];
    userLabel.minimumFontSize = 12;
    userLabel.adjustsFontSizeToFitWidth = YES;
    userLabel.backgroundColor = headerView.backgroundColor;
    userLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.0];
    userLabel.adjustsFontSizeToFitWidth = YES;
    userLabel.shadowColor = [UIColor whiteColor];
    userLabel.shadowOffset = CGSizeMake(1.0, 1.0);    
    userLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:userLabel];
    [userLabel release];
    
    
    /** DateLabel **/
    frame.origin.x += headerView.frame.size.width - n;
    frame.size.width = DATE_LABEL_WIDTH;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];

    dateLabel.font = [UIFont systemFontOfSize:13];
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.textColor = [UIColor colorWithWhite:136.0/255 alpha:1.0];
    dateLabel.minimumFontSize = 10;
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    dateLabel.shadowColor = [UIColor whiteColor];
    dateLabel.backgroundColor = headerView.backgroundColor;
    dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [headerView addSubview:dateLabel];
    [dateLabel release];
    
    
    self.userLabel = userLabel;
    self.dateLabel = dateLabel;
    
    
    [self addSubview:headerView];
    [headerView release];
    
    return headerView.frame.size.height;
}


#pragma mark -
#pragma mark Memory Management.
- (void)dealloc {
    [_userLabel release];   _userLabel = nil;
    [_dateLabel release];   _dateLabel = nil;
    [_messageView release]; _messageView = nil;
    [super dealloc];
}


@end
