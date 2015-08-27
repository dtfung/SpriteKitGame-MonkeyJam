//
//  HighestScore.m
//  Void
//
//  Created by Donald Fung on 8/14/15.
//  Copyright © 2015 Donald Fung. All rights reserved.
//

#import "HighestScore.h"

@implementation HighestScore

-(instancetype)initWithName:(NSString*)topScore {
    self = [super init];
    if (self) {
        self.topScore = topScore;
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeObject:[self topScore] forKey:@"topScore"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self setTopScore:[decoder decodeObjectForKey:@"topScore"]];
    }
    return self;
}


@end
