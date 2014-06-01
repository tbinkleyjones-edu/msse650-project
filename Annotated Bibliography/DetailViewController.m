//
//  DetailViewController.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "DetailViewController.h"

#import "Entry.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        Entry *entry = self.detailItem;
        self.sourceTitleLabel.text = entry.sourceTitle;
        self.mediaTitleLabel.text = entry.mediaTitle;
        self.authorsLabel.text = entry.authors;
        self.abstractTextView.text = entry.abstract;
        self.notesTextView.text = entry.notes;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
        NSLog(@"Change to edit mode");
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        NSLog(@"Change to view mode");

        [self.delegate updateEntry:self.detailItem];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath:%ld-%ld",(long)[indexPath section], (long)[indexPath row]);

    // return a custom height for the abstract and note rows
    CGFloat result;
    switch ([indexPath section])
    {
        case 1:
        case 2: {
            result = 3 * tableView.rowHeight;
            break;
        }
        default: {
            result = tableView.rowHeight;
        }
    }
    return result;
}

- (IBAction)deleteEntry:(id)sender {
    // called when the delete button on the form is clicked. Display an action sheet
    // with cancel and delete options
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %@ button was tapped. (index %ld)", [actionSheet buttonTitleAtIndex:buttonIndex], (long)buttonIndex);

    // send a delete message to the delegate, and then navigate back
    if (buttonIndex == 0) {
        [self.delegate deleteEntry:self.detailItem];
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

@end
