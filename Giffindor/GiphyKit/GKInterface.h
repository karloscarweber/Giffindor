//
//  GKInterface.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKGif.h"

// Vendor imports
#import "sqlite3.h"
#import "FMDatabase.h"
#import "AFNetworking.h"

@interface GKInterface : NSObject

// Generic Settings code for whatever we want
- (NSString *)getSetting:(NSString *)settingName;
- (void)saveSetting:(NSString *)settingName withValue:(NSString *)settingValue;


- (void)searchForGifsUsingString:(NSString *)searchString;
- (NSMutableDictionary *)getGifUsingId:(NSString *)idString;
- (NSMutableDictionary *)getGifsUsingId:(NSArray *)searchArray;

- (GKGif *)getGif:(NSString *)gifId;

// Utility stuff



@end
