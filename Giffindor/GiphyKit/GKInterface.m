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

//- (void)searchForGifsUsingString:(NSString *)searchString {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
////    return dictionary;
//}

- (void)searchForGifsUsingString:(NSString *)searchString {
    NSLog(@"we're searching");
    // Setup the AFNetworking stuff.
    NSString *filteredSearchString = [self filterSearchString:searchString];
    NSString *string = [NSString
                        stringWithFormat:@"%@://%@%@?q=%@&api_key=%@",
                        GKAPIScheme,
                        GKAPIHost,
                        GKSearch,
                        filteredSearchString,
                        GKAPIKey];
    
    NSLog(@"%@", [self filterSearchString:filteredSearchString]);
    
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
        for(NSDictionary *gif in data){
        
            GKGif *gifToStore = [[GKGif alloc] init];
            
            NSDictionary *images = [gif objectForKey:@"images"];
            NSDictionary *fixed_height = [images objectForKey:@"fixed_height_downsampled"];
            
            gifToStore.gid = [gif objectForKey:@"id"];
            gifToStore.url = [gif objectForKey:@"url"];
            gifToStore.fixed_height_url = [fixed_height objectForKey:@"url"];
            gifToStore.width = [[fixed_height objectForKey:@"width"] intValue];
            gifToStore.height = [[fixed_height objectForKey:@"height"] intValue];
            gifToStore.searchString = filteredSearchString;
            [self saveGif:gifToStore];
            dispatch_sync(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [self cacheGif:gifToStore];
            });
        }
     
        // Tell everybody that you succeeded and load up some more gifs into the hopper.
//        [[NSNotificationCenter defaultCenter] postNotificationName:kGifsLoadedNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kRCKloadDataFailed object:nil];
        NSLog(@"we failed somehow");
    }];
    
    [operation start];
}


// ok the idea is that we use the search string to get a huge list of our happy gifs,
// we then iterate over them to see if we haven't actually added any of these things to our
// tableView.
- (NSMutableDictionary *)loadGifUsingSearchString {

    NSString *searchString = [self getSetting:@"currentSearchString"];
    NSLog(@"loadGifUsingSearchString called: %@", searchString);
    
    FMDatabase *sharedDatabase = [GKStart sharedDatabase];
    [sharedDatabase open];
    FMResultSet *results = [sharedDatabase executeQuery:@"SELECT * FROM gifcache WHERE searchString=?", [NSString stringWithFormat:@"%@", searchString]];
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
    
    while([results next]) {
        [returnDictionary setObject:[results stringForColumn:@"id"] forKey:[results stringForColumn:@"id"]];
    }
    [sharedDatabase close];
    
    NSLog(@"results: %d",[returnDictionary count]);
    
    return returnDictionary;
}

//- (NSDictionary*)getGifUsingId:(NSString *)idString {
//    
//}
//- (NSDictionary*)getGifsUsingIds:(NSArray *)searchArray {
//    
//}


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
        // get an instance of the database, and then save this sucker.
        FMDatabase *sharedDatabase = [GKStart sharedDatabase];
        [sharedDatabase open];
    
        NSLog(@"save gif called: %@", gif.searchString);
    
        // first check if the Setting is already set.
        // if it is then just update it, otherwise, insert a new one.
        GKGif *key = [self getGif:gif.gid];
//        NSLog(@"%@, key: %@", gif.gid, key.gid);
        if([key.gid isEqualToString:@"DFiwMapItOTh6"]){
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
}

- (void)cacheGif:(GKGif *)gifToCache {
    // caches the gif
    NSData *gif = [NSData dataWithContentsOfURL:[NSURL URLWithString:gifToCache.fixed_height_url]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    [gif writeToFile:[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", gifToCache.gid]] atomically:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[NSNotificationCenter defaultCenter] postNotificationName:GKDidRetrieveGifs object:nil];
    });
}

- (NSString *)filterSearchString:(NSString *)sample {
    return [sample stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (int)count {
    
    // here is where we get the total number of gifs.
    
    return 12;
}

@end
