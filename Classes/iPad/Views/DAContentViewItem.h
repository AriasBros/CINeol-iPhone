//
//  DAContentViewItem.h
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAContentViewItem : UIView {

    @protected
    UIView      *_separatorView;
    DAGridView  *_gridView;
}

@property (nonatomic, retain, readonly) UIView      *separatorView;
@property (nonatomic, retain, readonly) DAGridView  *gridView;

@end
