//
//  ClaInnovateComment.m
//  Claromentis
//
//  Created by Julian Cohen on 07/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaInnovateComment.h"

@implementation ClaInnovateComment

@synthesize userName = _userName;
@synthesize commentText = _commentText;
@synthesize when = _when;
@synthesize likeCount = _likeCount;
@synthesize replyCount = _replyCount;
@synthesize userPhoto = _userPhoto;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.ID = [[dict objectForKey:@"id"] integerValue];
        self.userID = [[dict objectForKey:@"user_id"] integerValue];
        self.userName = [dict objectForKey:@"user_full_name"];
        self.commentText = [dict objectForKey:@"txt"];
        self.when = [dict objectForKey:@"when"];
        self.likeCount = [[[NSString alloc] initWithString:[dict objectForKey:@"like_count"]] intValue];
        self.replyCount = [[dict objectForKey:@"reply_count"] integerValue];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[Comment Model ID: %d] TXT: %@ (%d likes, %d replies)", (int)self.ID, self.commentText, (int)self.likeCount, (int)self.replyCount];
}

@end
