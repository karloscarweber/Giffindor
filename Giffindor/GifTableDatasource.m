//
//  GifTableDatasource.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifTableDatasource.h"
#import "GiphyKit.h"
#import "GKDefines.h"
#import "GKInterface.h"
#import "FLAnimatedImage.h"
#import "GifTableViewCell.h"

@implementation GifTableDatasource

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
    
    NSLog(@"the row: %ld", (long)indexPath.row);
    GifTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GifCell"];
    
    if(!cell) {
        cell = [[GifTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GifCell"];
        [[cell textLabel] setText:@"emptycell"];
        
//        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://media4.giphy.com/media/DFiwMapItOTh6/200.gif"]]];
//        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//        imageView.animatedImage = image;
//        [cell setGif:image];
//        cell.imageView.frame = CGRectMake(0.0, 0.0, 302.0, 200.0);
//        [cell addSubview:cell.imageView];
    }
    // check
    
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GKInterface *gifs = [[GKInterface alloc] init];
    return [gifs count];
}

- (void)reloadGifs {
    
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter getSetting:@"currentSearchString"];
//    if([currentSearchString isEqualToString:gif]) {
    
//    }
}

//- (void)addGif:(NSNotification *)notification {
- (void)addGif:(GKGif *)gifToAdd {
        NSLog(@"this is the passed gifid: %@", gifToAdd.gid);
//        [_gifs addObject:gifToAdd];
}

- (void)addGifs {

    
}

@end
