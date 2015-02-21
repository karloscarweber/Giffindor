//
//  AppDelegate.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/19/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GifViewController *gvc;

+ (AppDelegate *)sharedAppDelegate;

@end

