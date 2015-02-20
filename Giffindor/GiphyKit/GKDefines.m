//
//  GKDefines.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GKDefines.h"

#pragma mark - API

NSString *const GKAPIScheme      = @"http";
NSString *const GKAPIHost        = @"api.giphy.com";
NSString *const GKSearch         = @"/v1/gifs/search";
NSString *const GKGetGifById     = @"/v1/gifs/";
NSString *const GKGetGifsById    = @"/v1/gifs";

#pragma mark - User Defaults Keys

// This is the public beta key.
// Change this if you want to go all production like.
NSString *const GKAPIKey = @"dc6zaTOxFJmzC";

#pragma mark - Notifications

NSString *const GKDidRetrieveGifs = @"GKDidRetrieveGifs";
NSString *const GKDidDeleteGifs   = @"GKDidDeleteGifs";
