//
//  ClaViewController.m
//  Claromentis
//
//  Created by Julian Cohen on 11/12/2012.
//  Copyright (c) 2012 Claromentis. All rights reserved.
//

#import "ClaViewController.h"
#import "ClaSettingsViewController.h"
#import "ClaInnovateHomeViewController.h"

@interface ClaViewController () <UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClaViewController

@synthesize  applications = _applications;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Predefine the list of applications
    self.applications = [NSMutableArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"innovate", @"key", @"Innovate", @"name", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"users", @"key", @"People", @"name", nil],
                         nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.applications count];
}

// Hide the seperators for empty table cells
- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

#define kApplicationLabel 1
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicationCell"];
    cell.tag = [[self.applications objectAtIndex:indexPath.row] objectForKey:@"key"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:kApplicationLabel];
    label.text = (NSString *)[[self.applications objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

# pragma marks UITableViewDelegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionaryItem = [self.applications objectAtIndex:indexPath.row];

    UIViewController *destinationController;
    
    if([[dictionaryItem objectForKey:@"key"] isEqualToString:@"innovate"]) {
        destinationController = (ClaInnovateHomeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"InnovateHomeViewController"];
    }
    
    destinationController.navigationItem.title = [dictionaryItem objectForKey:@"name"];
    [self.navigationController pushViewController:destinationController animated:YES];
}

@end
