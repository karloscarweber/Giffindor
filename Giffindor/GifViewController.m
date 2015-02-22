//
//  ViewController.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifViewController.h"
#import "GifTableDelegate.h"
#import "GKInterface.h"
#import "GifTableViewCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "GKDefines.h"

@interface GifViewController ()

@end

@implementation GifViewController

//@synthesize gifTableView;
@synthesize gifTableDelegate;
@synthesize gifCache = _gifCache;
@synthesize gifDataCache = _gifDataCache;
@synthesize gifSafetyArray = _gifSafetyArray;
@synthesize refreshtimer = _refreshtimer;
@synthesize lastSearchOffset = _lastSearchOffset;
@synthesize lastRequestMaximum = _lastRequestMaximum;

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup table view
    [self buildTableView];

    self.gifCache = [[NSMutableDictionary alloc] init];
    self.gifDataCache = [[NSMutableArray alloc] init];
    self.gifSafetyArray = [[NSMutableArray alloc] init];

    // create autoupdate run loop
    self.refreshtimer = [NSTimer scheduledTimerWithTimeInterval:3.5f target:self selector:@selector(updateGifs) userInfo:nil repeats:YES];
    
    self.lastSearchOffset = 0;
    self.lastRequestMaximum = 0;
    
    // setup the low memory warning handler:
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSArray *gifKeys = [self.gifCache allKeys];
        for (NSString *gifKey in gifKeys) {
        
            BOOL deleteMe = YES;
            
            for (NSString *safeKey in self.gifSafetyArray) {
                if ([gifKey isEqualToString:safeKey]) {
                    deleteMe = NO;
                }
            }
            
            if (deleteMe == YES){
                [self.gifCache removeObjectForKey:gifKey];
            }
        }
        
        // our gifing is great
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGif:) name:GKAddGif object:nil];
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
    self.tableView.dataSource = self;
    
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 44)];
    bar.barStyle = UIBarStyleDefault;
    bar.placeholder = @"Search";
    bar.translucent = YES;
    bar.showsCancelButton = YES;
    bar.delegate = self;
    self.tableView.tableHeaderView = bar;
//    NSLog(@"%f", screenSize.width);
    self.tableView.frame = CGRectMake(0.0f, 0.0f, screenSize.width, screenSize.height);
    
    GKInterface *gifGetter = [[GKInterface alloc] init];
    bar.text = [gifGetter getSetting:@"currentSearchString"];
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"search tapped");
    [searchBar resignFirstResponder];
    
    [self clearTable];
    
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter saveSetting:@"currentSearchString" withValue:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [gifGetter searchForGifsUsingString:searchBar.text withOffset:0];
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"cancel tapped");
    [searchBar resignFirstResponder];
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter saveSetting:@"currentSearchString" withValue:@""];
}

- (void)clearTable {
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter clearCache];
    self.gifDataCache = [[NSMutableArray alloc] init];
    self.gifCache = [[NSMutableDictionary alloc] init];
    self.gifSafetyArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

- (void)updateGifs {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSArray *array = [[[GKInterface alloc] init] loadGifUsingSearchString];
        int numrows = [self.tableView numberOfRowsInSection:0];
        
//        NSLog(@"number of rows: %d ________________ (updategifs)", numrows);
//        NSLog(@"table height: %f", self.tableView.contentSize.height);
    //    NSLog(@"number of gifs: %d", [self.gifDataCache count]);
        
        if (numrows < [array count]){
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            
            while (numrows < [array count]) {
                if (numrows > 0) {
                    [paths addObject:[NSIndexPath indexPathForRow:numrows - 1 inSection:0]];
                }
                numrows = numrows + 1;
            }
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//                [self.tableView beginUpdates];

                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    // update the number of thingys in the other thingy too.
                    if ([self.gifDataCache count] < [array count]){
                        for (NSIndexPath *path in paths) {
//                            NSLog(@"the path that kills us: %d", path.row);
                            GKGif *newgif = [[[GKInterface alloc] init] getGifAtRow:path.row];
                            [self.gifDataCache addObject:newgif];
                        }
                    }
                    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
                });
//                [self.tableView endUpdates];
//                NSLog(@"updates triggered");
                
            });
        }
        
    });
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"the row: %ld", (long)indexPath.row);
    [self maybeLoadMoreByRow:indexPath.row];
    
    GifTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GifCell"];
    
    if(!cell) {
        cell = [[GifTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GifCell"];
        cell.imageView = [[FLAnimatedImageView alloc] init];
        cell.imageView.frame = CGRectMake(0.0, 0.0, 302.0, 200.0);
        [cell.imageView removeFromSuperview];
        [cell addSubview:cell.imageView];
    }
    
    GKGif *gif = [[[GKInterface alloc] init] getGifAtRow:indexPath.row];
    
//    NSLog(@"%@", gif.gid);
    
    FLAnimatedImage * __block animatedImage = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // check for object
        if([self.gifCache objectForKey:gif.gid] != nil){
            cell.imageView.animatedImage = [self.gifCache objectForKey:gif.gid];
            [cell.imageView removeFromSuperview];
            [cell addSubview:cell.imageView];
        } else {
        
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:gif.fixed_height_url]];
            animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
            
            // cache this thing:
            // add to safetyarray after popping
            if([self.gifSafetyArray count] > 74) {
                [self.gifSafetyArray removeObjectAtIndex:0];
            }
            [self.gifSafetyArray addObject:gif.gid];
            if(animatedImage != nil) {
                [self.gifCache setObject:animatedImage forKey:gif.gid];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.animatedImage = animatedImage;
                [cell.imageView removeFromSuperview];
                [cell addSubview:cell.imageView];
            });
        }
    });
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"number of rows: %d ________________ (numberOfRows)", [self.gifDataCache count]);
    return [self.gifDataCache count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)maybeLoadMoreByRow:(int)row {

    int numrows = [self.tableView numberOfRowsInSection:0];
    int difference = numrows - row;

    if(difference < 10 && self.lastRequestMaximum != numrows) {
        GKInterface *gifInterface = [[GKInterface alloc] init];
        self.lastSearchOffset = self.lastSearchOffset + 24;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [gifInterface searchForGifsUsingString:[gifInterface getSetting:@"currentSearchString"] withOffset:self.lastSearchOffset];
        });
        self.lastRequestMaximum = numrows;
    }
}

@end
