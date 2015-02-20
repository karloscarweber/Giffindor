//
//  GifTableDatasource.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifTableDatasource : NSObject <UITableViewDataSource>

@property int totalResults;
//@property int loadedResults; // count the Gifs array, where gifs are stored
@property (nonatomic, strong) NSMutableArray *gifs;
@property (nonatomic, strong) NSString *currentSearchString;

@end