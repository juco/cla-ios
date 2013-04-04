//
//  ClaRemotesController.h
//  Claromentis
//
//  Created by Julian Cohen on 19/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Remote;

@interface ClaRemotesController : NSObject

@property (weak) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController;

- (Remote *)remoteAtIndex:(int)index;
- (Remote *)activeRemote;

//- (void)saveRemote:(Remote *)remote;
//- (void)deleteRemote:(Remote *)remote;

@end
