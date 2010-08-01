//
//  CEGenericOptionsViewController.m
//  Cineol
//
//  Created by David Arias Vazquez on 06/10/09.
//  Copyright 2009 LeafSoftware. All rights reserved.
//

#import "DAListOfOptionsViewController.h"


@interface DAListOfOptionsViewController ()

@end


@implementation DAListOfOptionsViewController

@synthesize dataSource          = _dataSource;
@synthesize currentSelection    = _currentSelection;
@synthesize titleHeader         = _titleHeader;
@synthesize titleFooter         = _titleFooter;


- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    if (self.currentSelection.row == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isValidSelection = [self rowAtIndexPathIsValidSelection:indexPath];
    
    if (isValidSelection)
        [self listOfOptions:tableView didSelectValidRowAtIndexPath:indexPath];
}

- (void)listOfOptions:(UITableView*)tableView didSelectValidRowAtIndexPath:(NSIndexPath*)indexPath
{
}

- (BOOL)rowAtIndexPathIsValidSelection:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.currentSelection == indexPath)
        return NO;
        
    [self.tableView cellForRowAtIndexPath:self.currentSelection].accessoryType = UITableViewCellAccessoryNone;    
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

    self.currentSelection = indexPath;
    
    return YES;
}



#pragma mark -
#pragma mark Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {
}


- (void)dealloc {
    [_dataSource release];
    [_currentSelection release];
    [_titleFooter release];
    [_titleHeader release];
    
    [super dealloc];
}

@end