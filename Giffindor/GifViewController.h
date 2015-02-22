//
//  GifViewController.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifTableDelegate.h"

@interface GifViewController : UITableViewController <UISearchBarDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UITableView *gifTableView;
@property (nonatomic, strong) GifTableDelegate *gifTableDelegate;
// we store the gifs based on their id here
@property (nonatomic, strong) NSMutableDictionary *gifCache;
@property (nonatomic, strong) NSMutableArray *gifDataCache;
/*
    everytime we cache arrays we add their ids here
    when we need get rid of gifs we clear everything that's not in this array. from the gifCache
    we regularly push/pop gif ids to this array
*/
@property (nonatomic, strong) NSMutableArray *gifSafetyArray;
@property (nonatomic, strong) NSTimer *refreshtimer;

@property int lastSearchOffset;
@property int lastRequestMaximum;
@property int currentLoadedGifs;

@end