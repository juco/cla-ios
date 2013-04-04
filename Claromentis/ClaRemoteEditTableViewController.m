//
//  ClaRemoteEditTableViewController.m
//  Claromentis
//
//  Created by Julian Cohen on 28/01/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaRemoteEditTableViewController.h"

@interface ClaRemoteEditTableViewController ()

- (void)updateRemote;

@end

@implementation ClaRemoteEditTableViewController

@synthesize delegate = _delegate;
@synthesize remote = _remote;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if([self.remote.name length] > 0) {
        self.nameField.text = self.remote.name;
        self.hostnameField.text = self.remote.name;
        self.portField.text = [NSString stringWithFormat:@"%@", self.remote.port];
        self.usernameField.text = self.remote.username;
        self.passwordField.text = self.remote.password;
    } else {
        [self.deleteButton setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self updateRemote];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateRemote {
    if(self.remote == nil) {
        NSLog(@"Unexpected error! ClaRemoteEditTableViewController has no Remote model!");
        exit(1);
    }
    if(self.delegate == nil) {
        NSLog(@"Unexpected error! ClaRemoteEditTableViewController has no delegate");
        exit(1);
    }
    if([self.nameField.text length] > 0 &&
       [self.hostnameField.text length] > 0) {
        self.remote.name = self.nameField.text;
        self.remote.hostname = self.hostnameField.text;
        self.remote.port = [NSNumber numberWithInt:[self.portField.text integerValue]];
        self.remote.username = self.usernameField.text;
        self.remote.password = self.passwordField.text;
        
        [self.delegate saveRemote:self.remote];
    }    
}

- (IBAction)deleteButtonClicked:(id)sender {
    [self.delegate remoteWasDeleted:self.remote];
}
@end
