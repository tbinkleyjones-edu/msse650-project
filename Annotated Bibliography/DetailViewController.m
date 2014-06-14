//
//  DetailViewController.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "DetailViewController.h"

#import "Entry.h"

//static NSInteger const TITLES_SECTION = 0;
static NSInteger const AUTHORS_SECTION = 1;
static NSInteger const ABSTRACT_SECTION = 2;
static NSInteger const NOTES_SECTION = 3;

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
        self.abstractTextView.editable = YES;
        self.notesTextView.editable = YES;

        for (NSInteger i=0; i<[self.detailItem authors].count; i++) {
            UITableViewCell *cell = [self.staticTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:AUTHORS_SECTION]];

            [[cell.contentView.subviews objectAtIndex:0] setEnabled:YES];
        }

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];

        [self.staticTableView insertRowsAtIndexPaths: [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[self.detailItem authors].count inSection:AUTHORS_SECTION],nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        NSLog(@"Change to view mode");

        [self.staticTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[self.detailItem authors].count inSection:AUTHORS_SECTION],nil] withRowAnimation:UITableViewRowAnimationFade];

        self.navigationItem.leftBarButtonItem = nil;

        self.sourceTitleTextField.enabled = NO;
        self.mediaTitleTextField.enabled = NO;
        self.abstractTextView.editable = NO;
        self.notesTextView.editable = NO;

        Entry *entry = self.detailItem;
        entry.sourceTitle = self.sourceTitleTextField.text;
        entry.mediaTitle = self.mediaTitleTextField.text;

        for (NSInteger i=0; i<[self.detailItem authors].count; i++) {
            UITableViewCell *cell = [self.staticTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:AUTHORS_SECTION]];

            [[cell.contentView.subviews objectAtIndex:0] setEnabled:NO];
            [entry.authors replaceObjectAtIndex:i withObject:[[cell.contentView.subviews objectAtIndex:0] text]];
        }

        entry.abstract = self.abstractTextView.text;
        entry.notes = self.notesTextView.text;
        
        [self.delegate updateEntry:self.detailItem];
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.

    if (indexPath.section == AUTHORS_SECTION) {
        return YES;
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"heightForRowAtIndexPath:%ld-%ld",(long)indexPath.section, (long)indexPath.row);

    // return a custom height for the abstract and note rows
    CGFloat result;
    switch (indexPath.section)
    {
        case ABSTRACT_SECTION:
        case NOTES_SECTION: {
            result = 3 * tableView.rowHeight;
            break;
        }
        default: {
            result = tableView.rowHeight;
        }
    }
    return result;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AUTHORS_SECTION && tableView.isEditing) {
        // TODO: return insert type for last row.
        Entry *entry = self.detailItem;
        if (indexPath.row >= entry.authors.count) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"asking for indentation level %d-%d", indexPath.section, indexPath.row);

     if (indexPath.section == AUTHORS_SECTION) {
        return 0;
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == AUTHORS_SECTION ) {
        // return number of authors. if in edit mode, return number of authors + 1
        Entry *entry = self.detailItem;
        if (tableView.isEditing) {
            return entry.authors.count + 1;
        }
        return entry.authors.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *AuthorCellIdentifier = @"Author Cell";
    static NSString *AddCellIdentifier = @"Add Cell";

    if (indexPath.section == AUTHORS_SECTION) {
        NSLog(@"Asking for cell for author %d", indexPath.row);

        // return text field cell for each author
        // if in edit mode create a label cell for add author
        if (indexPath.row >= [self.detailItem authors].count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier];
            }
            cell.textLabel.text = @"add author";
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthorCellIdentifier];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AuthorCellIdentifier];
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(18, 5, 300, 30)];
                textField.enabled = tableView.isEditing;
                [cell.contentView addSubview:textField];
            }

            Entry *entry = self.detailItem;
            [[cell.contentView.subviews objectAtIndex:0] setText:[entry.authors objectAtIndex:indexPath.row]];
            return cell;
        }
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == AUTHORS_SECTION) {
        NSLog(@"committing style for row: %d", indexPath.row);
        Entry *entry = self.detailItem;
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // remove the specified author from the array.
            [entry.authors removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            [entry.authors addObject: @""];
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
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
