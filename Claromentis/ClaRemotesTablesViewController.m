//
//  ClaRemotesTablesViewController.m
//  Claromentis
//
//  Created by Julian Cohen on 24/01/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaRemotesTablesViewController.h"
#import "ClaRemotesController.h"

@interface ClaRemotesTablesViewController ()

@property (strong, nonatomic) ClaRemotesController *remotesController;
@property (strong, nonatomic) NSMutableArray *remotes;

- (void)contextDidSave:(NSDictionary *)userData;

@end

@implementation ClaRemotesTablesViewController

@synthesize remotesController = _remotesController;
@synthesize remotes = _remotes;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.remotesController = [[ClaRemotesController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.remotesController.context];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called on successful save of the Managed Object Context
- (void)contextDidSave:(NSDictionary *)userData {
    // Reset the fetchResultsController to force reinitialization
    self.remotesController.fetchedResultsController = nil;
    // Reload the table data
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.remotesController.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"remoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Remote *remote = [self.remotesController remoteAtIndex:(int)indexPath.row];
    cell.textLabel.text = remote.name;

    // Colour in the active remote
    if([remote.objectID.URIRepresentation.absoluteString isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"activeRemote"]]) {
        cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1];
    } else {
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Remote *remote = (Remote *)[self.remotesController remoteAtIndex:(int)indexPath.row];
    ClaRemoteEditTableViewController *remoteEditTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RemoteEditTableViewController"];
    remoteEditTableViewController.delegate = self;
    remoteEditTableViewController.remote = remote;
    [self.navigationController pushViewController:remoteEditTableViewController animated:YES];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Remote *remote = (Remote *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    Remote *remote = [self.remotesController remoteAtIndex:(int)indexPath.row];
    [[NSUserDefaults standardUserDefaults] setValue:remote.objectID.URIRepresentation.absoluteString forKey:@"activeRemote"];
    [self.tableView reloadData];
}

- (IBAction)addPushed:(id)sender {
    ClaRemoteEditTableViewController *remoteEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RemoteEditTableViewController"];
    NSManagedObjectContext *context = self.remotesController.context;
    NSEntityDescription *entity = [[[self.remotesController fetchedResultsController] fetchRequest] entity];
    Remote *remote = (Remote *)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    remoteEditViewController.delegate = self;
    remoteEditViewController.remote = remote;
    
    [self.navigationController pushViewController:remoteEditViewController animated:YES];
}

#pragma mark RemoteEditDelegate methods
- (void)saveRemote:(Remote *)remote {
//    NSLog(@"Delegate save remote! Is updated: %@  \n\n %@", [remote isUpdated] ? @"yes" : @"no", remote);
    NSError *error;
    if([remote isUpdated]) {
        NSLog(@"Context: %@", self.remotesController.context);
        if(![self.remotesController.context save:&error]) {
            NSLog(@"An error occurred saving to the context! %@", error);
        }
    }
    [self hideModal];
}

- (void)remoteWasDeleted:(Remote *)remote {
    [self.navigationController popViewControllerAnimated:YES];
    [self.remotesController.context deleteObject:remote];
    NSError *error;
    if(![self.remotesController.context save:&error]) {
        NSLog(@"An error occurred when deleting the remote %@", error);
    }
    [self hideModal];
}

- (void)hideModal {
    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
