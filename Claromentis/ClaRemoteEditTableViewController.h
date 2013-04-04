//
//  ClaRemoteEditTableViewController.h
//  Claromentis
//
//  Created by Julian Cohen on 28/01/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Remote.h"

@protocol RemoteEditDelegate;

@class Remote;

@interface ClaRemoteEditTableViewController : UITableViewController

@property (nonatomic, weak) id <RemoteEditDelegate> delegate;
@property (nonatomic, weak) Remote *remote;
- (IBAction)deleteButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *hostnameField;
@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@protocol RemoteEditDelegate <NSObject>

@required

- (void)saveRemote:(Remote *)remote;
- (void)remoteWasDeleted:(Remote *)remote;

@end