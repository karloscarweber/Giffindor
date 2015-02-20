//
//  GifTableViewCell.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/20/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifTableViewCell.h"
#import "FLAnimatedImageView.h"

@implementation GifTableViewCell

@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://media4.giphy.com/media/DFiwMapItOTh6/200.gif"]]];
//    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//    _imageView.animatedImage = image;
    _imageView.frame = CGRectMake(0.0, 0.0, 302.0, 200.0);
    [self addSubview:_imageView];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setGif:(FLAnimatedImage *)animateImage {
    _imageView.animatedImage = animateImage;
}

@end
