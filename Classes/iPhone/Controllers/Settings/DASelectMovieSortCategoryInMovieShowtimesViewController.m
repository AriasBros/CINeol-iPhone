//
//  DASelectMovieSortCategoryInMovieShowtimesViewController.m
//  CINeol
//
//  Created by David Arias Vazquez on 31/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DASelectMovieSortCategoryInMovieShowtimesViewController.h"
#import "DACINeolUserDefaults.h"

@implementation DASelectMovieSortCategoryInMovieShowtimesViewController

- (id) initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.title = @"Ordenar películas por";
        self.dataSource = [NSArray arrayWithObjects:
                           @"Fecha de Estreno", 
                           @"Título", 
                           @"Duración",
                           @"Puntuación",
                           //@"Género",
                           nil];
        
        _movieSortCategory = [DACINeolUserDefaults movieSortCategoryInMovieShowtimesSection];
        self.currentSelection = [NSIndexPath indexPathForRow:_movieSortCategory
                                                   inSection:0];
    }
    
    return self;
}

- (void)listOfOptions:(UITableView*)tableView didSelectValidRowAtIndexPath:(NSIndexPath*)indexPath
{
    _movieSortCategory = indexPath.row;
    [DACINeolUserDefaults setMovieSortCategoryInMovieShowtimesSection:_movieSortCategory];    
}

@end
