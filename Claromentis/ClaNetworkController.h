//
//  ClaNetworkController.h
//  Claromentis
//
//  Created by Julian Cohen on 07/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;

@protocol ClaNetworkDelegate;

@class Remote;

@interface ClaNetworkController : NSObject

@property (strong) id<ClaNetworkDelegate> delegate;

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) SBJsonStreamParser *parser;
@property (strong, nonatomic) SBJsonStreamParserAdapter *adapter;

@property (strong, nonatomic) Remote *remote;

- (id)initWithPath:(NSString *)path;

@end

@protocol ClaNetworkDelegate <NSObject>
@required
- (void)networkControllerDidFailWithError:(NSError *)error;
- (void)receivedObject:(NSDictionary *)data;
- (void)receivedArray:(NSArray *)array;
@end