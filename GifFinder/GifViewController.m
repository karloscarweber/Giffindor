//
//  ViewController.m
//  GifFinder
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifViewController.h"
#import "GifTableDelegate.h"
#import "GifTableDatasource.h"
#import "GKGifs.h"

@interface GifViewController ()

@end

@implementation GifViewController

//@synthesize gifTableView;
@synthesize gifTableDelegate;
@synthesize gifTableDatasource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup table view
    [self buildTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*  this method builds and sets up the table view
    I personally dislike lots of inline settings in the viewDidload
    method. It get's messy real quick.
*/
-(void)buildTableView {
    
    CGSize screenSize = self.view.bounds.size;
    
    // only inline references to the table view because this whole thing only
    // loads gifs, and we don't cache them very much.
    gifTableDelegate = [[GifTableDelegate alloc] init];
    self.tableView.delegate = gifTableDelegate;
    gifTableDatasource = [[GifTableDatasource alloc] init];
    self.tableView.dataSource = gifTableDatasource;
    
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)];
    bar.barStyle = UIBarStyleDefault;
    bar.placeholder = @"Search";
    bar.translucent = YES;
    bar.showsCancelButton = YES;
    bar.delegate = self;
    self.tableView.tableHeaderView = bar;
    NSLog(@"%f", screenSize.width);
    self.tableView.frame = CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search tapped");
    [searchBar resignFirstResponder];
    
    GKGifs *gifGetter = [[GKGifs alloc] init];
    [gifGetter saveSetting:@"currentSearchString" withValue:searchBar.text];
    [gifGetter searchForGifsUsingString:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel tapped");
    [searchBar resignFirstResponder];
    
    GKGifs *gifGetter = [[GKGifs alloc] init];
    [gifGetter saveSetting:@"currentSearchString" withValue:@""];
}

@end
