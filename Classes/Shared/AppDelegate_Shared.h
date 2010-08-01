//
//  AppDelegate_Shared.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright Yo 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


#pragma mark -
#pragma mark Methods for subclassing.
- (void) initUserInterface;             // Initialice your UI (iphone version or ipad version);
- (UIView*) mainView;                   // Request of the main view for add to the window.

@end

