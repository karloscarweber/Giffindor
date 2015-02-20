//
//  GiphyKit.h
//  GifFinder
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

/*
    GiphyKit is an interface for the GiphyAPI: https://github.com/giphy/GiphyAPI
    It has some handy methods and features that let you fill up a tableView
    with api data without having to build your own datasource.
    We also do some lite cacheing, that can obviously be improved.
    I think it's pretty legit.
*/

#import <Foundation/Foundation.h>

#import "GKDefines.h"
#import "GKStart.h"
#import "GKGifs.h"

// Vendor
#import <AFNetworking/AFNetworking.h>
#import "sqlite3.h"
#import "FMDatabase.h"