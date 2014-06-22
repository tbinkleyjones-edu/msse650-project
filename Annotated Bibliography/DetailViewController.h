//
//  DetailViewController.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CitationOperationDelegate.h"

@interface DetailViewController : UITableViewController <UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSArray *mediaTypes;
@property (weak) id <CitationOperationDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *staticTableView;

@property (weak, nonatomic) IBOutlet UITextField *sourceTitleTextField;

@property (weak, nonatomic) IBOutlet UITableViewCell *readOnlyMediaTitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeOfMediaCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *editableMediaTitleCell;
@property (weak, nonatomic) IBOutlet UITextField *editableMediaTitleTextField;

@property (weak, nonatomic) IBOutlet UITextView *abstractTextView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet UITextField *keywordsTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *doiTextField;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteCitation:(id)sender;

- (IBAction)unwindToView:(UIStoryboardSegue *)segue;

@end
