//
//  ClaInnovateComment.h
//  Claromentis
//
//  Created by Julian Cohen on 07/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClaInnovateObjectModel.h"

@interface ClaInnovateComment : ClaInnovateObjectModel

@property NSString *userName;
@property NSString *commentText;
@property NSString *when;
@property NSInteger likeCount;
@property NSInteger replyCount;

@property (nonatomic, strong) UIImage *userPhoto;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
