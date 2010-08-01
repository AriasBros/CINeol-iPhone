//
//  DANewsViewController.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACINeolObjectsViewController.h"
#import "DANewsViewController.h"


@interface DANewsListViewController : DACINeolObjectsViewController <DACINeolObjectsViewController,
                                                                     DAPageViewControllerDelegate,
                                                                     UIActionSheetDelegate,
                                                                     MFMailComposeViewControllerDelegate> 
{
    @private
    id _temp;   // Variable comodin. En este caso solo la utilizo para pasar la URL de la
                // noticia entre metodo y metodo.
    
    @protected
    DANewsViewController *_newsViewController;
    NSArray *_cellItems;
    
    struct {
        unsigned int currentSelectedNews:8;
    } _newsListViewController;
}

@end
