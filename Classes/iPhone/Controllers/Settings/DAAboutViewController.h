//
//  DACreditsViewController.h
//  Tickler
//
//  Created by David Arias Vazquez on 30/03/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAAboutViewController : UIViewController <DAOverlayViewDelegate> {

    @private
    IBOutlet DAOverlayView  *overlayView;
    IBOutlet UILabel        *copyrightLabel;
}

@property(retain, nonatomic, readonly) IBOutlet UILabel *copyrightLabel;

- (IBAction) goToLeafsoft:(id)sender;
- (IBAction) goToWebBeyer:(id)sender;
- (IBAction) goToCINeol:(id)sender;

@end