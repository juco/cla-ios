//
//  ClaAppDelegate.h
//  Claromentis
//
//  Created by Julian Cohen on 11/12/2012.
//  Copyright (c) 2012 Claromentis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
