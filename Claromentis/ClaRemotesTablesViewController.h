//
//  ClaRemotesTablesViewController.h
//  Claromentis
//
//  Created by Julian Cohen on 24/01/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ClaAppDelegate.h"
#import "Remote.h"
#import "ClaRemoteEditTableViewController.h"

@interface ClaRemotesTablesViewController : UITableViewController <RemoteEditDelegate>

-(IBAction)addPushed:(id)sender;

@end
