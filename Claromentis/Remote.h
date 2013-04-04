//
//  Remote.h
//  Claromentis
//
//  Created by Julian Cohen on 25/01/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Remote : NSManagedObject

@property (nonatomic, retain) NSString * hostname;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * name;

@end
