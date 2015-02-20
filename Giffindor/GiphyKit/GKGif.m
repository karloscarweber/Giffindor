//
//  GKGif.m
//  Giffindor
//
//  Created by Karl Oscar Weber on 2/20/15.
//  Copyright (c) 2015 Prologue. All rights reserved.
//

#import "GKGif.h"

@implementation GKGif

@synthesize gid;
@synthesize url;
@synthesize fixed_height_url;
@synthesize image;
@synthesize width;
@synthesize height;

- (GKGif *)init {

    if(self = [super init]){
        gid = @"DFiwMapItOTh6";
        url = @"http://giphy.com/gifs/funny-cat-DFiwMapItOTh6";
        fixed_height_url = @"http://media4.giphy.com/media/DFiwMapItOTh6/200.gif";
        width = 302;
        height = 200;
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    
    // encode Placement variables
    [encoder encodeObject:gid forKey:@"gid"];
    [encoder encodeObject:url forKey:@"url"];
    [encoder encodeObject:fixed_height_url forKey:@"fixed_height_url"];
    [encoder encodeInt:width forKey:@"width"];
    [encoder encodeInt:height forKey:@"height"];
    
}

-initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        // encode type:
        gid = [decoder decodeObjectForKey:@"gid"];
        url = [decoder decodeObjectForKey:@"url"];
        fixed_height_url = [decoder decodeObjectForKey:@"fixed_height_url"];
        width = [decoder decodeIntForKey:@"width"];
        height = [decoder decodeIntForKey:@"height"];
    }
    return self;
}




@end
