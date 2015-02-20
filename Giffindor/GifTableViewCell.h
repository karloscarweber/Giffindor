//
//  GifTableViewCell.h
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/20/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"

@interface GifTableViewCell : UITableViewCell

@property (nonatomic, strong) FLAnimatedImageView *imageView;

- (void)setGif:(FLAnimatedImage *)animateImage;

@end
