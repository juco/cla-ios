//
//  ClaInnovateLikerModel.h
//  Claromentis
//
//  Created by Julian Cohen on 18/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaInnovateObjectModel.h"

@interface ClaInnovateLikerModel : ClaInnovateObjectModel

@property (strong, nonatomic) NSString *userName;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
