//
//  ClaInnovateLikersTableViewController.m
//  Claromentis
//
//  Created by Julian Cohen on 16/03/2013.
//  Copyright (c) 2013 Claromentis. All rights reserved.
//

#import "ClaInnovateLikersTableViewController.h"
#import "ClaInnovateLikerModel.h"
#import "ClaNetworkController.h"
#import "ClaInnovateComment.h"
#import "ClaInnovatePhotoDownloader.h"

@interface ClaInnovateLikersTableViewController () <ClaNetworkDelegate, ClaInnovatePhotoDelegate>

@property (strong, nonatomic) ClaNetworkController *networkController;
@property (strong, nonatomic) NSMutableArray *likers;
@property (strong, nonatomic) ClaInnovatePhotoDownloader *photoDownloader;
@property (strong, nonatomic) NSMutableDictionary *photoDownloadsInProgress;

- (void)startPhotoDownloadForLiker:(ClaInnovateLikerModel *)liker forIndexPath:(NSIndexPath *)indexPath;
- (void)donePushed;

@end

@implementation ClaInnovateLikersTableViewController

@synthesize networkController = _networkController;
@synthesize comment = _comment;
@synthesize likers = _likers;
@synthesize photoDownloader = _photoDownloader;
@synthesize photoDownloadsInProgress = _photoDownloadsInProgress;

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

    // Configure the navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePushed)];
    self.navigationItem.title = @"People who like it";
    
    // Instantiate the likers array
    self.likers = [NSMutableArray array];
    
    // Initiailize the network controller
    NSString *path = [NSString stringWithFormat:@"/intranet/rest/innovate/like/comment/%d", self.comment.ID];
    self.networkController = [[ClaNetworkController alloc] initWithPath:path];
    self.networkController.delegate = self;
    
    // Initialize photo downloads
    self.photoDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.likers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LikerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ClaInnovateLikerModel *liker = [self.likers objectAtIndex:indexPath.row];
    cell.textLabel.text = liker.userName;
    
    if(liker.userPhoto == nil) {
        cell.imageView.image = [UIImage imageNamed:@"no_photo.jpg"];
        [self startPhotoDownloadForLiker:liker forIndexPath:indexPath];
    } else {
        cell.imageView.image = liker.userPhoto;
    }
    
    return cell;
}

#pragma mark -
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -
#pragma mark NetworkController delegate methods
- (void)receivedObject:(NSDictionary *)data {
    NSLog(@"Received object: %@", data);
}

- (void)receivedArray:(NSArray *)array {
    for(NSDictionary *dict in array) {
        ClaInnovateLikerModel *liker = [[ClaInnovateLikerModel alloc] initWithDictionary:dict];
        [self.likers addObject:liker];
    }
    [self.tableView reloadData];
}

- (void)networkControllerDidFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"An Error occurred" message:@"Failed to access the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self dismissViewControllerAnimated:YES completion:nil];    
}

#pragma mark -
#pragma mark UI events
- (void)donePushed {
    NSLog(@"Done pushed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startPhotoDownloadForLiker:(ClaInnovateLikerModel *)liker forIndexPath:(NSIndexPath *)indexPath {
    ClaInnovatePhotoDownloader *photoDownloader = [self.photoDownloadsInProgress objectForKey:indexPath];
    if(photoDownloader == nil) {
        photoDownloader = [[ClaInnovatePhotoDownloader alloc] init];
        photoDownloader.model = liker;
        photoDownloader.indexPath = indexPath;
        photoDownloader.delegate = self;
        [self.photoDownloadsInProgress setObject:photoDownloader forKey:indexPath];
        [photoDownloader startDownload];
    }
}

- (void)photoDidDownload:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath {
    ClaInnovatePhotoDownloader *photoDownloader = [self.photoDownloadsInProgress objectForKey:indexPath];
    if(photoDownloader != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = image;
    }
    [self.photoDownloadsInProgress removeObjectForKey:indexPath];
    
}

@end
