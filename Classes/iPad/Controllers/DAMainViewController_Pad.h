//
//  DAMainViewController.h
//  Cineol
//
//  Created by David Arias Vazquez on 20/06/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DALateralBarView;
@class DAContentViewController;

@interface DAMainViewController_Pad : UIViewController {

    @protected
    DALateralBarView        *_lateralBarView;
    DAContentViewController *_contentViewController;    
}

@property (nonatomic, retain) DALateralBarView          *lateralBarView;
@property (nonatomic, retain) DAContentViewController   *contentViewController;

@end
