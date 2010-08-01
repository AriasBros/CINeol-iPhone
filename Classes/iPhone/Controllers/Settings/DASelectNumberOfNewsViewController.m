//
//  DASelectNumberOfNewsViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DASelectNumberOfNewsViewController.h"
#import "DACINeolUserDefaults.h"

@implementation DASelectNumberOfNewsViewController


- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Número de noticias";
        self.dataSource = [NSArray arrayWithObjects:@"5", @"10", @"15", @"20", nil];
        _numberOfNews = [DACINeolUserDefaults numberOfNewsInNewsSection];
        self.currentSelection = [NSIndexPath indexPathForRow:_numberOfNews / 5 - 1
                                                   inSection:0];
    }
    
    return self;
}

- (void)listOfOptions:(UITableView*)tableView didSelectValidRowAtIndexPath:(NSIndexPath*)indexPath
{
    _numberOfNews = [[self.dataSource objectAtIndex:indexPath.row] intValue];
    [DACINeolUserDefaults setNumberOfNewsInNewsSection:_numberOfNews];   
}


@end
