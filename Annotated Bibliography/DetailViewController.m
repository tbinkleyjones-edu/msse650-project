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
        self.sourceTitleTextField.text = entry.sourceTitle;
        self.mediaTitleTextField.text = entry.mediaTitle;
        if (entry.authors.count > 0) {
            self.authorsTextField.text = [entry.authors objectAtIndex:0];
        }
        self.abstractTextView.text = entry.abstract;
        self.notesTextView.text = entry.notes;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
        NSLog(@"Change to edit mode");
        self.deleteButton.hidden = NO;
        self.deleteButton.enabled = YES;

        self.sourceTitleTextField.enabled = YES;
        self.mediaTitleTextField.enabled = YES;
        self.authorsTextField.enabled = YES;
        self.abstractTextView.editable = YES;
        self.notesTextView.editable = YES;

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];

    }
    else {
        // Save the changes if needed and change the views to noneditable.
        NSLog(@"Change to view mode");

        self.navigationItem.leftBarButtonItem = nil;

        self.sourceTitleTextField.enabled = NO;
        self.mediaTitleTextField.enabled = NO;
        self.authorsTextField.enabled = NO;
        self.abstractTextView.editable = NO;
        self.notesTextView.editable = NO;

        Entry *entry = self.detailItem;
        entry.sourceTitle = self.sourceTitleTextField.text;
        entry.mediaTitle = self.mediaTitleTextField.text;
        if (entry.authors.count > 0) {
            [entry.authors replaceObjectAtIndex:0 withObject:self.authorsTextField.text];
        } else {
            [entry.authors addObject:self.authorsTextField.text];
        }
        entry.abstract = self.abstractTextView.text;
        entry.notes = self.notesTextView.text;

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

- (void)cancelEdit {
    // restore field values to what is already in the detail item
    [self configureView];
    // resume view mode
    [self setEditing:NO animated:YES];
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
