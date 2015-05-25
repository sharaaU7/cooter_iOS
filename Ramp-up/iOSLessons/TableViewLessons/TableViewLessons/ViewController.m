//
//  ViewController.m
//  TableViewLessons
//
//  Created by Mate User on 5/25/15.
//  Copyright (c) 2015 Sharad Sharma. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup the NSArray
    items = [[NSArray alloc] initWithObjects:@"Recent", @"Dropbox", @"Google Drive", @"OneDrive", @"Camera Roll", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Step 1 - Check to see if we can reuse a cell from a row that has just rolled off the screen
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Step 2 - If there are no cells to reuse create a new one
    if(cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:
                 UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    // Step 3 - add a detail view accessory
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // Step 4 - set the cell text
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    // Step 5 - return the cell
    return cell;
}

@end
