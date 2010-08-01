//
//  AppDelegate_Pad.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright Yo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

@class DAMainViewController;

@interface AppDelegate_Pad : AppDelegate_Shared {
    
    @protected
    DAMainViewController *_mainViewController;
}

@property (nonatomic, retain) DAMainViewController *mainViewController;

@end

