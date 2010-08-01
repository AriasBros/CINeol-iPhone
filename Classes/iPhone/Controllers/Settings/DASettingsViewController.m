//
//  DASettingsViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DASettingsViewController.h"
#import "DAAboutViewController.h"
#import "DASelectNumberOfNewsViewController.h"
#import "DASelectNumberOfWeeksViewController.h"
#import "DASelectMovieSortCategoryInMovieShowtimesViewController.h"

#import "DACINeolFacade.h"
#import "DACINeolUserDefaults.h"


#define NEWS_SECTION                0
#define MOVIE_SHOWTIMES_SECTION     1
#define ABOUT_SECTION               2


static NSString *kDATableViewCellStyleSubtitle  = @"DATableViewCellStyleSubtitle";
static NSString *kDATableViewCellStyleValue1    = @"DATableViewCellStyleValue1";


@interface DASettingsViewController ()

//- (UITableViewCell*) cellForRowAtNewsSectionAtIndex:(NSInteger)index;
//- (UITableViewCell*) cellForRowAtMovieShowtimesSectionAtIndex:(NSInteger)index;
- (UITableViewCell*) cellForRowAtAboutSectionAtIndex:(NSInteger)index;

@end


@implementation DASettingsViewController

- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Ajustes";
        self.tabBarItem.image = [UIImage imageNamed:@"DASettingsTabBarIcon.png"];
    }
    
    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];
}


#pragma mark -
#pragma mark UITableView DataSource Methods.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == MOVIE_SHOWTIMES_SECTION)
        return 2;
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NEWS_SECTION:
            return @"Noticias";
        
        case MOVIE_SHOWTIMES_SECTION:
            return @"Cartelera";

        case ABOUT_SECTION:
            return  @" ";
    }
    
    return @"";
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ABOUT_SECTION)
        return [self cellForRowAtAboutSectionAtIndex:indexPath.row];

        
    DATableViewCell *cell = (DATableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:kDATableViewCellStyleValue1];
    if (cell == nil) {
        cell = [[[DATableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier:kDATableViewCellStyleValue1] autorelease];
        cell.allowLongTouch = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.minimumFontSize = 10;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    
    if (indexPath.section == NEWS_SECTION) {
        cell.textLabel.text = @"Número máximo de noticias"; 
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", 
                                     [DACINeolUserDefaults numberOfNewsInNewsSection]];
    }
    else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Ordenar películas por"; 
            cell.detailTextLabel.text = [DACINeolFacade nameForMovieSortCategory:
                                         [DACINeolUserDefaults movieSortCategoryInMovieShowtimesSection]];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"Número de semanas"; 
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", 
                                         [DACINeolUserDefaults numberOfWeeksInMoviesShowtimesSection] + 1];
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableView Delegate Methods.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == ABOUT_SECTION)
        return 50;
    
    return 44;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == ABOUT_SECTION)
        return 50;
    
    return 44;    
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = nil;
    if (indexPath.section == ABOUT_SECTION) {
        controller = [[DAAboutViewController alloc] initWithNibName:@"DAAboutView"
                                                             bundle:nil];
    }
    else if (indexPath.section == NEWS_SECTION) {
        controller = [[DASelectNumberOfNewsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    else if (indexPath.section == MOVIE_SHOWTIMES_SECTION) {
        
        if (indexPath.row == 0) {
            controller = [[DASelectMovieSortCategoryInMovieShowtimesViewController alloc]
                          initWithStyle:UITableViewStyleGrouped];             
        }
        else if (indexPath.row == 1) {
            controller = [[DASelectNumberOfWeeksViewController alloc]
                          initWithStyle:UITableViewStyleGrouped];            
        }
    }
    
    if (controller != nil) {
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark -
#pragma mark Private Methods.
- (UITableViewCell*) cellForRowAtAboutSectionAtIndex:(NSInteger)index {
    
    DATableViewCell *cell = (DATableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:kDATableViewCellStyleSubtitle];
    if (cell == nil) {
        cell = [[[DATableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                        reuseIdentifier:kDATableViewCellStyleSubtitle] autorelease];
        cell.allowLongTouch = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
        cell.textLabel.textColor = [UIColor colorWithWhite:65.0/255 alpha:1.0];
    }
    
    cell.textLabel.text = @"Acerca de CINeol";
    cell.imageView.image = [UIImage imageNamed:@"DASettingsAboutIcon.png"];
    cell.detailTextLabel.text = [@"Versión " stringByAppendingString:[DACINeolUserDefaults applicationVersion]];

    return cell;
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end