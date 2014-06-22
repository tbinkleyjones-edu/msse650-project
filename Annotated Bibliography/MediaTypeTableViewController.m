//
//  MediaTypeViewControllerTableViewController.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/22/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "MediaTypeTableViewController.h"

@interface MediaTypeTableViewController ()

@end

@implementation MediaTypeTableViewController

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection: %ld", self.mediaTypes.count);
    // Return the number of rows in the section.
    return self.mediaTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaTypeCell" forIndexPath:indexPath];
    

    MediaType *mediaType = [self.mediaTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = mediaType.type;

    //NSString *path = [[NSBundle mainBundle] pathForResource:@"image-1" ofType:@"png"];
    UIImage *theImage = [UIImage imageNamed:@"image-1"];

    cell.imageView.image = theImage;

    if (mediaType == self.selectedType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // If there was a previous selection, unset the accessory view for its cell.
	MediaType *currentType = self.selectedType;

    if (currentType != nil) {
		NSInteger index = [self.mediaTypes indexOfObject:currentType];
		NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
    }

    // Set the checkmark accessory for the selected row.
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];

    // Update the selected type 
    self.selectedType = [self.mediaTypes objectAtIndex:indexPath.row];

    // Deselect the row.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
