//
//  GKGif.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/20/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKGif : NSObject

@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *fixed_height_url;
@property (nonatomic, strong) UIImage *image;
@property int width;
@property int height;

@end
