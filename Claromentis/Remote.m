//
//  Remote.m
//  Claromentis
//
//  Created by Julian Cohen on 25/01/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "Remote.h"


@implementation Remote

@dynamic hostname;
@dynamic port;
@dynamic username;
@dynamic password;
@dynamic name;

-(NSString *)description {
    return [NSString stringWithFormat:@"Remote Model: Hostname: %@ Username: %@", self.hostname, self.username];
}

@end
