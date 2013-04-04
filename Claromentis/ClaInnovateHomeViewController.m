//
//  ClaInnovateHomeViewController.m
//  Claromentis
//
//  Created by Julian Cohen on 12/12/2012.
//  Copyright (c) 2012 Claromentis. All rights reserved.
//

#import "ClaInnovateHomeViewController.h"
#import "ClaInnovateMenuTableViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "ClaNetworkController.h"
#import "ClaInnovateComment.h"
#import "ClaInnovatePhotoDownloader.h"
#import "ClaInnovateCommentCell.h"
#import "ClaInnovateCommentDetailsViewController.h"
#import "DejalActivityView.h"
#import "NSString_stripHtml.h"
#import "ClaInnovateLikersTableViewController.h"

#define kUserPhotoTag 6
#define kLikersButtonTag 7

@interface ClaInnovateHomeViewController () <UITableViewDataSource, UITableViewDelegate, JTRevealSidebarV2Delegate, ClaNetworkDelegate, ClaInnovatePhotoDelegate>

@property (strong, nonatomic) ClaNetworkController *networkController;
@property (nonatomic, strong) UITableViewController *sidebarViewController;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableDictionary *photoDownloadsInProgress;
@property BOOL fetchingMore;

- (void)startPhotoDownload:(ClaInnovateComment *)comment forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ClaInnovateHomeViewController

@synthesize sidebarViewController = _sidebarViewController;
@synthesize comments = _comments;
@synthesize fetchingMore = _fetchingMore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    // Add the right button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"foo" style:UIBarButtonItemStyleBordered target:self action:@selector(menuButtonClicked)];
    
    // Initialize the comments array
    self.comments = [NSMutableArray new];
    
    // Show the full screen loader
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading posts"].showNetworkActivityIndicator = YES;
    
    // Set outself up as the delegate for the Reveal Slider
    self.navigationItem.revealSidebarDelegate = self;
    
    // Initialize fetchingMode
    self.fetchingMore = NO;
    
    // Instantiate the ClaNetworkController
    self.networkController = [[ClaNetworkController alloc] initWithPath:@"/intranet/rest/innovate/channel/corporate/1/comments"];
    self.networkController.delegate = self;
    
    // Initialize the photoDownloadsInProgress
    self.photoDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ClaInnovateCommentDetailsViewController *viewController = segue.destinationViewController;
    viewController.comment = [self.comments objectAtIndex:[self.tableView indexPathForSelectedRow].row];
}

#pragma mark -
#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Grab a cell specific to the index path
    ClaInnovateCommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    // Grab the comment to associate with this cell
    ClaInnovateComment *comment = (ClaInnovateComment *)[self.comments objectAtIndex:indexPath.row];

    // Draw the table cell using our custom UITableViewCell class
    [cell drawWithComment:comment forTableView:tableView];
    
    // User photo
    UIImageView *photoView = (UIImageView *)[cell viewWithTag:kUserPhotoTag];
    if(!comment.userPhoto) {
        [self startPhotoDownload:comment forIndexPath:indexPath];
        photoView.image = [UIImage imageNamed:@"no_photo.jpg"];
    } else {
        photoView.image = comment.userPhoto;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClaInnovateComment *comment = (ClaInnovateComment *)[self.comments objectAtIndex:indexPath.row];

    UILabel *commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 32.0)];
    commentTextLabel.font = [UIFont systemFontOfSize:14.0];
    commentTextLabel.text = [comment.commentText stripHtml];
    commentTextLabel.numberOfLines = 0;
    commentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [commentTextLabel sizeToFit];

    return commentTextLabel.frame.size.height + 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == ([self.comments count] - 2) && self.fetchingMore == NO) {
        ClaInnovateComment *lastComment = [self.comments lastObject];
        self.networkController = [[ClaNetworkController alloc] initWithPath:[NSString stringWithFormat:@"/intranet/rest/innovate/channel/corportate/1/comment?%d", lastComment.ID]];
    }
}

#pragma mark -
#pragma mark ClaNetworkDelegate methods
- (void)receivedObject:(NSDictionary *)data {
    NSArray *results;
    if((results = [data objectForKey:@"results"])) {
        for(id commentDict in results) {
            ClaInnovateComment *comment = [[ClaInnovateComment alloc] initWithDictionary:commentDict];
            [self.comments addObject:comment];
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
    [self.tableView reloadData];
}

- (void)receivedArray:(NSArray *)array {
    NSLog(@"Innovate controller received array");
}

- (void)networkControllerDidFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"An Error occurred" message:@"Failed to access the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [DejalBezelActivityView removeViewAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma ClInnovatePhotoDownloader stuff
- (void)startPhotoDownload:(ClaInnovateComment *)comment forIndexPath:(NSIndexPath *)indexPath {
    ClaInnovatePhotoDownloader *photoDownloader = [self.photoDownloadsInProgress objectForKey:indexPath];
    if(photoDownloader == nil) {
        photoDownloader = [[ClaInnovatePhotoDownloader alloc] init];
        photoDownloader.model = comment;
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
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:kUserPhotoTag];
        imageView.image = image;
    }
    [self.photoDownloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark -
#pragma mark JTRevealSlider stuff
- (void)menuButtonClicked {
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

- (UIView *)viewForRightSidebar {
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    
    if(!self.sidebarViewController) {
        self.sidebarViewController = (ClaInnovateMenuTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"InnovateMenuTableViewController"];
        self.sidebarViewController.title = @"Menu";
    }
    self.sidebarViewController.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    self.sidebarViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    return self.sidebarViewController.view;
}

#pragma mark -
#pragma mark Events
- (void)likersButtonPressed:(UIButton *)button forIndexPath:(NSIndexPath *)indexPath {
    ClaInnovateLikersTableViewController *likeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InnovateLikersTableViewController"];
    likeViewController.comment = [self.comments objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    [self presentViewController:likeViewController animated:YES completion:nil];
}

- (IBAction)likersButtonPushed:(id)sender {
    ClaInnovateLikersTableViewController *likeViewController = (ClaInnovateLikersTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"InnovateLikersTableViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:likeViewController];
    UIButton *button = (UIButton *)sender;
    UITableViewCell *selectedCell = (UITableViewCell *)button.superview.superview;
    ClaInnovateComment *comment = [self.comments objectAtIndex:[self.tableView indexPathForCell:selectedCell].row];
    likeViewController.comment = comment;
    [self presentViewController:navController animated:YES completion:nil];
}
@end