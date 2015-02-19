//
//  ViewController.m
//  GifFinder
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    // only inline references to the table view because this whole thing only
    // loads gifs, and we don't cache them very much.
    
    UITableView *tableView = [[UITableView alloc] init];
    // setup datasource
    [self.view addSubview:tableView];
    
}

@end
