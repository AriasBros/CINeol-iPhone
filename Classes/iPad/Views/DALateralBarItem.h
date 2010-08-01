//
//  DALateralBarItem.h
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DALateralBarItem : UIView {

    @protected
    UILabel *_titleLabel;
    UIView  *_separatorView;
}

@property (nonatomic, retain, readonly) UILabel *titleLabel;
@property (nonatomic, retain, readonly) UIView  *separatorView;

- (id) initWithFrame:(CGRect)frame title:(NSString*)title;

@end
