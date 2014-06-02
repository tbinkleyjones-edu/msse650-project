//
//  DetailViewController.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EntryOperationDelegate.h"

@interface DetailViewController : UITableViewController <UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak) id <EntryOperationDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *sourceTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *mediaTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorsTextField;
@property (weak, nonatomic) IBOutlet UITextView *abstractTextView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteEntry:(id)sender;
@end
