//
//  GifTableViewCell.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/20/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GifTableViewCell.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
@implementation GifTableViewCell

@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
//    if(!self.imageView) {
//        self.imageView = [[FLAnimatedImageView alloc] init];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.imageView.clipsToBounds = YES;
//    }
    

    [self addSubview:self.imageView];
    self.imageView.frame = CGRectMake(0.0, 0.0, 302.0, 200.0);
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://raphaelschaad.com/static/nyan.gif"]]];
//    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:@"giphy.gif"]];
    self.imageView.animatedImage = image;
   
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
