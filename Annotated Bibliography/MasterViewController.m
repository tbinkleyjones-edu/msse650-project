//
//  MasterViewController.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "EntrySvcArchive.h"

@interface MasterViewController()

@property (strong, nonatomic) EntrySvcArchive *entries;

@end

@implementation MasterViewController

EntrySvcArchive *entries;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.entries = [[EntrySvcArchive alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"MasterController viewDidLoad");
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entries retrieveAllEntries].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];

    Entry *object = [[self.entries retrieveAllEntries] objectAtIndex:indexPath.row];
    cell.textLabel.text = [object sourceTitle];
    cell.detailTextLabel.text = [[object authors] objectAtIndex:0];

    //NSString *path = [[NSBundle mainBundle] pathForResource:@"image-1" ofType:@"png"];
    UIImage *theImage = [UIImage imageNamed:@"image-1"];

    cell.imageView.image = theImage;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Entry *object = [[self.entries retrieveAllEntries] objectAtIndex:indexPath.row];
        [self.entries deleteEntry:object];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSeque %@", [segue identifier]);

    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Entry *object = [[self.entries retrieveAllEntries] objectAtIndex:indexPath.row];
        NSLog(@"Editing Entry %@", object);
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setDelegate:self];

    } else if ([[segue identifier] isEqualToString:@"addEntry"]) {
        NSLog(@"Adding new entry");
        Entry *object = [[Entry alloc] init];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setEditing:YES animated:NO];
    }
}

- (void) updateEntry:(Entry *)entry {
    NSLog(@"updating entry %@", entry);
    if ([[self.entries retrieveAllEntries] containsObject:entry]) {
        [self.entries updateEntry:entry];
    } else {
        [self.entries createEntry:entry];
    }
    [self.tableView reloadData];
}

- (void) deleteEntry:(Entry *)entry {
    NSLog(@"deleting entry %@", entry);
    [self.entries deleteEntry:entry];
    [self.tableView reloadData];
}

@end
