//
//  GifTableDatasource.m
//  GifFinder
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifTableDatasource.h"
#import "GiphyKit.h"
#import "GKGifs.h"

@implementation GifTableDatasource

@synthesize currentSearchString;

- init {
    if(self = [super init]){
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadGifs)
                                                     name:GKDidRetrieveGifs
                                                   object:nil];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GifCell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GifCell"];
    }
    // check
//    cell.imageView.image = [UIImage imageNamed:@"image.png"];
    
    [[cell textLabel] setText:@"emptycell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (void)reloadGifs {
    
    GKGifs *gifGetter = [[GKGifs alloc] init];
    [gifGetter getSetting:@"currentSearchString"];
//    if([currentSearchString isEqualToString:gif]) {
//    
//    }
}

@end
