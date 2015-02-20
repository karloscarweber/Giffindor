//
//  ViewController.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifViewController.h"
#import "GifTableDelegate.h"
#import "GifTableDatasource.h"
#import "GKInterface.h"

@interface GifViewController ()

@end

@implementation GifViewController

//@synthesize gifTableView;
@synthesize gifTableDelegate;
@synthesize gifTableDatasource = _gifTableDatasource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup table view
    [self buildTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertNewRow)
                                                 name:@"insertNewRow"
                                               object:nil];
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
    self.tableView.dataSource = _gifTableDatasource;
    
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

- (void)insertNewRow:(NSNotification *)notification {

//    [self.tableView reloadData];
//    [self.tableView reloadRowsAtIndexPaths:]
    NSLog(@"we should be reloading.");
    
    if ([notification.name isEqualToString:@"insertNewRow"]) {

        int row = [_gifTableDatasource.gifs count];
        NSLog(@"row number: %d", row);

        if(row > 0) {
            NSLog(@"***** ***** .");
            NSIndexPath *path = [NSIndexPath indexPathForRow:(row - 1) inSection:0];
            NSArray *rows = [[NSArray alloc] initWithObjects: path, nil];
            [self.tableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];
        }
//        NSDictionary *moreUserInfo = @{@"row": @([gifs count])};
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"insertNewRow" object:self userInfo:moreUserInfo];
    }
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search tapped");
    [searchBar resignFirstResponder];
    
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter saveSetting:@"currentSearchString" withValue:searchBar.text];
        
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [gifGetter searchForGifsUsingString:searchBar.text];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel tapped");
    [searchBar resignFirstResponder];
    
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter saveSetting:@"currentSearchString" withValue:@""];
}

@end
