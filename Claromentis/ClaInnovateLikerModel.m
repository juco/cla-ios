//
//  ClaInnovateLikerModel.m
//  Claromentis
//
//  Created by Julian Cohen on 18/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaInnovateLikerModel.h"

@implementation ClaInnovateLikerModel

-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self) {
        self.userID = [[dict objectForKey:@"user_id"] integerValue];
        self.userName = [dict objectForKey:@"user_full_name"];
    }
    return self;
}

@end
