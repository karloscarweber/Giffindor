//
//  GKDefines.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef GKDEFINES
#define GKDEFINES

#pragma mark - API

extern NSString *const GKAPIScheme;
extern NSString *const GKAPIHost;
extern NSString *const GKSearch;
extern NSString *const GKGetGifById;
extern NSString *const GKGetGifsById;

#pragma mark - User Defaults Keys

extern NSString *const GKAPIKey;

#pragma mark - Notifications

extern NSString *const GKDidRetrieveGifs;
extern NSString *const GKAddGif;
extern NSString *const GKDidDeleteGifs;

#endif