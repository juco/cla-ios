//
//  ClaRemotesController.m
//  Claromentis
//
//  Created by Julian Cohen on 19/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaRemotesController.h"
#import "ClaAppDelegate.h"
#import "Remote.h"

@interface ClaRemotesController () <NSFetchedResultsControllerDelegate>

@end

@implementation ClaRemotesController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

//- (id)init {
//    self = [super init];
//    if(self) {
//        self.context = [(ClaAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    }
//    
//    return self;
//}

- (Remote *)remoteAtIndex:(int)index {
    return [[self.fetchedResultsController fetchedObjects] objectAtIndex:index];
}

- (Remote *)activeRemote {
    NSArray *remotes = [self.fetchedResultsController fetchedObjects];
    for (Remote *remote in remotes) {
        if([remote.objectID.URIRepresentation.absoluteString isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"activeRemote"]]) {
            return remote;
        }
    }
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSLog(@"Initializing fetchResultsController");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Remote" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hostname" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (NSManagedObjectContext *)context {
    if(_context == nil) {
        _context = [(ClaAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    return _context;
}
- (void)setContext:(NSManagedObjectContext *)context {
    _context = context;
}

@end
