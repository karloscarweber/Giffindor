//
//  GifTableDatasource.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifTableDatasource.h"
#import "GiphyKit.h"
#import "GKInterface.h"
#import "FLAnimatedImage.h"

@implementation GifTableDatasource

@synthesize gifs;

- init {
    if(self = [super init]){
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadGifs)
                                                     name:GKDidRetrieveGifs
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addGif)
                                                     name:GKAddGif
                                                   object:nil];
        
        
        
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GifCell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GifCell"];
        
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://media4.giphy.com/media/DFiwMapItOTh6/200.gif"]]];
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.animatedImage = image;
        imageView.frame = CGRectMake(0.0, 0.0, 302.0, 200.0);
        [cell addSubview:imageView];
    }
    // check
//    cell.imageView.image = [UIImage imageNamed:@"giphy.gif"];
    
    [[cell textLabel] setText:@"emptycell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gifs count];
}

- (void)reloadGifs {
    
    GKInterface *gifGetter = [[GKInterface alloc] init];
    [gifGetter getSetting:@"currentSearchString"];
//    if([currentSearchString isEqualToString:gif]) {
//    
//    }
}

- (void)addGif:(NSNotification *)notification {

    if ([notification.name isEqualToString:@"GKAddGif"])
    {
        NSDictionary* userInfo = notification.userInfo;
        GKGif* gif = userInfo[@"gif"];
        [gifs addObject:gif];
        
    }
}


@end
