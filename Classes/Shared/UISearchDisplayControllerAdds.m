//
//  UISearchDisplayControllerAdds.m
//  Cineol
//
//  Created by David Arias Vazquez on 15/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import "UISearchDisplayControllerAdds.h"

@implementation UISearchDisplayController (UISearchDisplayControllerAdds)

/*
- (void) setNoResultsLabelHidden: (BOOL) hidden {

    _noResultsLabel.hidden = hidden;
}
*/
- (void) setNoResultsLabelText: (NSString*) string {
   /*
    if (self->_noResultsMessage != string) {
        [self->_noResultsMessage release];
        self->_noResultsMessage = string;
        [self->_noResultsMessage retain];
        
        self->_noResultsLabel.text = self->_noResultsMessage;
    }
    */
    
    UITableView *tableView = self.searchResultsTableView;
    for( UIView *subview in tableView.subviews ) {
        if( [subview class] == [UILabel class] ) {
            UILabel *lbl = (UILabel*)subview;
            lbl.text = string;
            return;
        }
    }
}
/*

- (void) setDimmingViewHidden: (BOOL) hidden {
    _dimmingView.hidden = hidden;
}

- (UIView*) dimmingView {
    return _dimmingView;
}

- (void) showDimmingView: (BOOL) value {
 
    if (value)
        [self.searchContentsController.view addSubview: _dimmingView];
    else
        [_dimmingView removeFromSuperview];
}
*/

@end
