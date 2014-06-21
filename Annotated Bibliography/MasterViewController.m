//
//  MasterViewController.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "CitationSvcCoreData.h"

@interface MasterViewController()

@property (strong, nonatomic) CitationSvcCoreData *citationService;

@end

@implementation MasterViewController

CitationSvcCoreData *citationService;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.citationService = [[CitationSvcCoreData alloc] init];
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
    return [self.citationService retrieveAllCitations].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CitationCell" forIndexPath:indexPath];

    Citation *object = [[self.citationService retrieveAllCitations] objectAtIndex:indexPath.row];
    cell.textLabel.text = [object sourceTitle];
    if (object.authors.count > 0) {
        //cell.detailTextLabel.text = [object.authors objectAtIndex:0];
    } else {
        cell.detailTextLabel.text = @"";
    }

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
        Citation *object = [[self.citationService retrieveAllCitations] objectAtIndex:indexPath.row];
        [self.citationService deleteCitation:object];
        [self.citationService commitChanges];
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
        Citation *object = [[self.citationService retrieveAllCitations] objectAtIndex:indexPath.row];
        NSLog(@"Editing Citation %@", object);
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setDelegate:self];

    } else if ([[segue identifier] isEqualToString:@"addCitation"]) {
        NSLog(@"Adding new citation");
        Citation *object = [self.citationService createCitation];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setEditing:YES animated:NO];
    }
}

- (Author *) createAuthor {
    return [self.citationService createAuthor];
}

- (void) updateCitation:(Citation *)citation {
    NSLog(@"commiting changes %@", citation);
    [self.citationService commitChanges];
    [self.tableView reloadData];
}

- (void) deleteCitation:(Citation *)citation {
    NSLog(@"deleting citation %@", citation);
    [self.citationService deleteCitation:citation];
    [self.citationService commitChanges];
    [self.tableView reloadData];
}

@end
