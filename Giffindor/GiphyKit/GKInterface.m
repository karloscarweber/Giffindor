//
//  GKConnectionObject.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GKInterface.h"
#import "GKStart.h"
#import "GKDefines.h"
#import "GKGif.h"
#import "AppDelegate.h"

@implementation GKInterface

#pragma mark - Settings
- (NSString *)getSetting:(NSString *)settingName {
    FMDatabase *sharedDatabase = [GKStart sharedDatabase];
    [sharedDatabase open];
    FMResultSet *results = [sharedDatabase executeQuery:@"SELECT * FROM settings WHERE title= ?", [NSString stringWithFormat:@"%@",settingName]];
    
    NSMutableString *returnSetting = [[NSMutableString alloc] init];
    
    while([results next]) {
        //NSLog(@"%@", [results stringForColumn:@"value"]);
        returnSetting.string = [NSString stringWithFormat:@"%@", [results stringForColumn:@"value"]];
    }
    [sharedDatabase close];
    return [NSString stringWithFormat:@"%@", returnSetting];
}

- (void)saveSetting:(NSString *)settingName withValue:(NSString *)settingValue {
    // get an instance of the database, and then save this sucker.
    FMDatabase *sharedDatabase = [GKStart sharedDatabase];
    [sharedDatabase open];
    
    // first check if the Setting is already set.
    // if it is then just update it, otherwise, insert a new one.
    NSString *key = [self getSetting:settingName];
    if(key.length > 0){
        [sharedDatabase executeUpdate:@"Update settings set value=? where title=?", [NSString stringWithFormat:@"%@", settingValue], settingName, nil ];
    } else {
        [sharedDatabase executeUpdate:@"INSERT INTO settings (title, value, id) VALUES (?,?,?)", settingName, [NSString stringWithFormat:@"%@", settingValue], nil ];
    }
    
    [sharedDatabase close];
}

- (void)searchForGifsUsingString:(NSString *)searchString withOffset:(int)offset {
//    NSLog(@"we're searching");
    // Setup the AFNetworking stuff.
    NSString *filteredSearchString = [self filterSearchString:searchString];
    NSString *string = [NSString
                        stringWithFormat:@"%@://%@%@?q=%@&api_key=%@&offset=%d",
                        GKAPIScheme,
                        GKAPIHost,
                        GKSearch,
                        filteredSearchString,
                        GKAPIKey,
                        offset];
    
//    NSLog(@"%@", [self filterSearchString:filteredSearchString]);
    
    // Setup the AFNetworking Request and Serializer
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Setup the AFNetworking operation success and failure blocks
    // Also Execute the block
    [operation setCompletionBlockWithSuccess:^(AFURLConnectionOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        // get the other stuff
        NSMutableDictionary *metaData = [dict objectForKey: @"meta"];
        NSString *status = [NSString stringWithFormat:@"%@", [metaData objectForKey: @"status"]];
        
        if ( [status isEqualToString:@"200"] ) {
            NSLog(@"The request was successful.");
        } else {
            NSLog(@"The request failed miserably.");
        }
        
        // save them gifs
        NSMutableDictionary *data = [dict objectForKey: @"data"];
        NSString *numberOfNewGifs = [NSString stringWithFormat:@"%d", [data count] ];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"GifsLoadedNotification" object:numberOfNewGifs];
        
        for(NSDictionary *gif in data){
        
            GKGif *gifToStore = [[GKGif alloc] init];
            
            NSDictionary *images = [gif objectForKey:@"images"];
            NSDictionary *fixed_height = [images objectForKey:@"fixed_height"];
            gifToStore.gid = [gif objectForKey:@"id"];
            gifToStore.url = [gif objectForKey:@"url"];
            gifToStore.fixed_height_url = [fixed_height objectForKey:@"url"];
            gifToStore.width = [[fixed_height objectForKey:@"width"] intValue];
            gifToStore.height = [[fixed_height objectForKey:@"height"] intValue];
            gifToStore.searchString = filteredSearchString;
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [self saveGif:gifToStore];
            });
        }
     
        // Tell everybody that you succeeded and load up some more gifs into the hopper.

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kRCKloadDataFailed object:nil];
        NSLog(@"we failed somehow");
    }];
    
    [operation start];
}

- (void)clearCache {
    FMDatabase *sharedDatabase = [GKStart sharedDatabase];
    [sharedDatabase open];
    FMResultSet *results = [sharedDatabase executeQuery:@"SELECT * FROM gifcache ORDER BY id ASC"];
    while([results next]) {
        NSLog(@"Deleted: %@", [results stringForColumn:@"id"]);
        [sharedDatabase executeUpdate:@"DELETE from gifcache WHERE id = ?", [results stringForColumn:@"id"]];
    }
    [sharedDatabase close];
}


// ok the idea is that we use the search string to get a huge list of our happy gifs,
// we then iterate over them to see if we haven't actually added any of these things to our
// tableView.
- (NSMutableArray *)loadGifUsingSearchString {

    NSString *searchString = [self getSetting:@"currentSearchString"];
//    NSLog(@"loadGifUsingSearchString called: %@", searchString);
    
    FMDatabase *sharedDatabase = [GKStart sharedDatabase];
    [sharedDatabase open];
    FMResultSet *results = [sharedDatabase executeQuery:@"SELECT * FROM gifcache WHERE searchString=?", [NSString stringWithFormat:@"%@", searchString]];
//    FMResultSet *results = [sharedDatabase executeQuery:@"SELECT * FROM gifcache", [NSString stringWithFormat:@"%@", searchString]];
    NSMutableArray *gifs = [[NSMutableArray alloc] init];
    
    while([results next]) {
        GKGif *returnGif = [[GKGif alloc] init];
        returnGif.gid = [results stringForColumn:@"id"];
        returnGif.url = [results stringForColumn:@"url"];
        returnGif.fixed_height_url = [results stringForColumn:@"fixed_height_url"];
        returnGif.width = [[results stringForColumn:@"width"] intValue];
        returnGif.height = [[results stringForColumn:@"height"] intValue];
        returnGif.searchString = [results stringForColumn:@"searchString"];
//        NSLog(@"a sample return gif id: %@", returnGif.gid);
        [gifs addObject:returnGif];
    }
    [sharedDatabase close];
    
//    NSLog(@"loadGifUsingSearchString results: %d", [gifs count]);
    return gifs;
}

#pragma mark - GifStuff
- (GKGif *)getGif:(NSString *)gifId {
    FMDatabase *sharedDatabase = [GKStart sharedDatabase];
    [sharedDatabase open];
    FMResultSet *results = [sharedDatabase executeQuery:@"SELECT * FROM gifcache WHERE id= ?", [NSString stringWithFormat:@"%@",gifId]];
    GKGif *returnGif = [[GKGif alloc] init];
    
    while([results next]) {
        returnGif.gid = [results stringForColumn:@"id"];
        returnGif.url = [results stringForColumn:@"url"];
        returnGif.fixed_height_url = [results stringForColumn:@"fixed_height_url"];
        returnGif.width = [[results stringForColumn:@"width"] intValue];
        returnGif.height = [[results stringForColumn:@"height"] intValue];
        returnGif.searchString = [results stringForColumn:@"searchString"];
    }
    [sharedDatabase close];
    return returnGif;
}

- (void)saveGif:(GKGif *)gif {

//        NSLog(@"save gif called.");
    
        FMDatabase *sharedDatabase = [GKStart sharedDatabase];
        [sharedDatabase open];
    
        GKGif *key = [self getGif:gif.gid];
        if([gif.gid isEqualToString:key.gid]){
            
//            NSLog(@"identical i think");
            
            [sharedDatabase executeUpdate:@"UPDATE gifcache SET id=?, url=?, fixed_height_url=?, width=?, height=?, searchString=? WHERE id=?",
             [NSString stringWithFormat:@"%@", gif.gid],
             [NSString stringWithFormat:@"%@", gif.url],
             [NSString stringWithFormat:@"%@", gif.fixed_height_url],
             [NSString stringWithFormat:@"%d", gif.width],
             [NSString stringWithFormat:@"%d", gif.height],
             [NSString stringWithFormat:@"%@", gif.searchString],
             [NSString stringWithFormat:@"%@", gif.gid],
             nil ];
        } else {
            
//            NSLog(@"so unique!");
            
            [sharedDatabase executeUpdate:@"INSERT INTO gifcache (id, url, fixed_height_url, width, height, searchString) VALUES (?,?,?,?,?,?)",
             [NSString stringWithFormat:@"%@", gif.gid],
             [NSString stringWithFormat:@"%@", gif.url],
             [NSString stringWithFormat:@"%@", gif.fixed_height_url],
             [NSString stringWithFormat:@"%d", gif.width],
             [NSString stringWithFormat:@"%d", gif.height],
             [NSString stringWithFormat:@"%@", gif.searchString],
             nil ];
        }
        [sharedDatabase close];
    
    NSDictionary* userInfo = @{@"gif": gif};
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:GKAddGif object:self userInfo:userInfo];
}

- (NSString *)filterSearchString:(NSString *)sample {
    return [sample stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (NSInteger)count {
    // here is where we get the total number of gifs.
    NSArray *gifs = [self loadGifUsingSearchString];
    return [gifs count];
}

- (GKGif *)getGifAtRow:(int)row {
//    GKGif *gif = [[GKGif alloc] init];
    NSArray *gifs = [self loadGifUsingSearchString];
    if ([gifs count] >= row) {
        return [gifs objectAtIndex:(row)];
    } else {
        return nil;
    }
}

@end
