//
//  CEGenericOptionsViewController.h
//  Cineol
//
//  Created by David Arias Vazquez on 06/10/09.
//  Copyright 2009 LeafSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAListOfOptionsViewController : DATableViewController {

    @protected
    NSMutableArray  *_dataSource;
    NSIndexPath     *_currentSelection;
    NSString        *_titleHeader;
    NSString        *_titleFooter;
}

@property (nonatomic, retain) NSMutableArray    *dataSource;
@property (nonatomic, retain) NSIndexPath       *currentSelection;
@property (nonatomic, copy) NSString            *titleHeader;
@property (nonatomic, copy) NSString            *titleFooter;

- (void)listOfOptions:(UITableView*)tableView didSelectValidRowAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL)rowAtIndexPathIsValidSelection:(NSIndexPath *)indexPath;

@end