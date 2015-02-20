//
//  GifViewController.h
//  GifFinder
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifTableDelegate.h"
#import "GifTableDatasource.h"

@interface GifViewController : UITableViewController <UISearchBarDelegate>

//@property (nonatomic, strong) UITableView *gifTableView;
@property (nonatomic, strong) GifTableDelegate *gifTableDelegate;
@property (nonatomic, strong) GifTableDatasource *gifTableDatasource;

- (void)searchUsingString:(NSString *)searchString;

@end