//
//  GKConnectionObject.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GKGifs.h"
#import "GKStart.h"
#import "GKDefines.h"

@implementation GKGifs


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
    NSString *string = [NSString
                        stringWithFormat:@"%@://%@%@?q=%@&api_key=%@",
                        GKAPIScheme,
                        GKAPIHost,
                        GKSearch,
                        [self filterSearchString:searchString],
                        GKAPIKey];
    
    // Setup the AFNetworking Request and Serializer
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Setup the AFNetworking operation success and failure blocks
    // Also Execute the block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
//        NSMutableArray *data = [dict objectForKey: @"data"];
//        for(NSDictionary *season in data){
        
            // MMTBSeasonItem *daSeason = [[MMTBSeasonItem alloc] init];
            // daSeason.localID = 0;
            // daSeason.remoteID = [[season objectForKey:@"id"] intValue];
            // daSeason.clientID = [[season objectForKey:@"client_id"] intValue];
            // daSeason.seasonName = [season objectForKey:@"name"];
            // daSeason.smallDescription = @"";
            // [self saveSeason:daSeason];
//        }
        
        // Tell everybody that you succeeded and load up some more gifs into the hopper.
//        [[NSNotificationCenter defaultCenter] postNotificationName:kGifsLoadedNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kRCKloadDataFailed object:nil];
        NSLog(@"we failed somehow");
    }];
    
    [operation start];
}

//- (NSDictionary*)getGifUsingId:(NSString *)idString {
//    
//}
//- (NSDictionary*)getGifsUsingId:(NSArray *)searchArray {
//    
//}

- (NSString *)filterSearchString:(NSString *)sample {
    return [sample stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

@end
