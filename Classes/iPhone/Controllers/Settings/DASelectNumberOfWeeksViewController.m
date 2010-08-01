//
//  DASelectNumberOfWeeksViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 24/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DASelectNumberOfWeeksViewController.h"
#import "DACINeolUserDefaults.h"


@implementation DASelectNumberOfWeeksViewController

- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Número de semanas";
        self.dataSource = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
        _numberOfWeeks = [DACINeolUserDefaults numberOfWeeksInMoviesShowtimesSection];
        self.currentSelection = [NSIndexPath indexPathForRow:_numberOfWeeks
                                                   inSection:0];
    }
    
    return self;
}

- (void)listOfOptions:(UITableView*)tableView didSelectValidRowAtIndexPath:(NSIndexPath*)indexPath
{
    _numberOfWeeks = indexPath.row;
    [DACINeolUserDefaults setNumberOfWeeksInMoviesShowtimesSection:_numberOfWeeks];    
}


@end
