//
//  GKStart.m
//  GifFinder
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

/*
    This object does 1 thing, Sets up the database incase it's not set up.
    You must call this object before you can start using GiphyKit
 */


#import "GKStart.h"

@implementation GKStart

// sets up the databas stuff.
+ (void)start {
    [GKStart setupSettingsTable];
    NSLog(@"Settings table is now set up.");
    [GKStart setupCachedGifsTable];
    NSLog(@"gifcache table is now set up.");
}

+ (FMDatabase *)sharedDatabase {
    // set up the database tables like a boss
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *dbPath =[documentDir stringByAppendingString:@"/GiphyKit.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    return database;
}

+(void)setupSettingsTable {
    /*
     settings
     id (INTEGER PRIMARY KEY)
     title (TEXT DEFAULT NULL)
     value (TEXT DEFAULT NULL)
     */
    // CREATE TABLE IF NOT EXISTS settings (id INTEGER PRIMARY KEY, title TEXT DEFAULT NULL, value TEXT DEFAULT NULL)
    FMDatabase *database = [GKStart sharedDatabase];
    [database open];
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS settings (id INTEGER PRIMARY KEY, title TEXT DEFAULT NULL, value TEXT DEFAULT NULL)"];
    [database close];
}

+(void)setupCachedGifsTable {
    /*
     gifcache
     id (TEXT PRIMARY KEY)
     url (TEXT DEFAULT NULL)
     fixed_height_url (TEXT DEFAULT NULL)
     width (INTEGER DEFAULT NULL)
     height (INTEGER DEFAULT NULL)
     */
    // CREATE TABLE IF NOT EXISTS gifcache (id TEXT PRIMARY KEY, url TEXT DEFAULT NULL, fixed_height_url TEXT DEFAULT NULL, width INTEGER DEFAULT NULL, height INTEGER DEFAULT NULL))
    FMDatabase *database = [GKStart sharedDatabase];
    [database open];
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS gifcache (id TEXT PRIMARY KEY, url TEXT DEFAULT NULL, fixed_height_url TEXT DEFAULT NULL, width INTEGER DEFAULT NULL, height INTEGER DEFAULT NULL)"];
    [database close];
}

@end
