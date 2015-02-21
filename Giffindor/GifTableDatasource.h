//
//  GifTableDatasource.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKGif.h"

@interface GifTableDatasource : NSObject <UITableViewDataSource>

//@property int loadedResults; // count the Gifs array, where gifs are stored
@property (nonatomic, strong) NSString *currentSearchString;


- (void)addGif:(GKGif *)gifToAdd;
- (void)addGifs;

@end