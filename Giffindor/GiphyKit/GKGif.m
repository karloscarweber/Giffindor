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
@synthesize width;
@synthesize height;
@synthesize searchString;

- (GKGif *)init {

    if(self = [super init]){
        gid = @"DFiwMapItOTh6";
        url = @"http://giphy.com/gifs/funny-cat-DFiwMapItOTh6";
        fixed_height_url = @"http://media4.giphy.com/media/DFiwMapItOTh6/200.gif";
        width = 302;
        height = 200;
        searchString = @"";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:gid forKey:@"gid"];
    [encoder encodeObject:url forKey:@"url"];
    [encoder encodeObject:fixed_height_url forKey:@"fixed_height_url"];
    [encoder encodeInt:width forKey:@"width"];
    [encoder encodeInt:height forKey:@"height"];
    [encoder encodeObject:searchString forKey:@"searchString"];
}

-initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        gid = [decoder decodeObjectForKey:@"gid"];
        url = [decoder decodeObjectForKey:@"url"];
        fixed_height_url = [decoder decodeObjectForKey:@"fixed_height_url"];
        width = [decoder decodeIntForKey:@"width"];
        height = [decoder decodeIntForKey:@"height"];
        searchString = [decoder decodeObjectForKey:@"searchString"];
    }
    return self;
}

@end
