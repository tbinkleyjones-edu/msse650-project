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

@property (weak, nonatomic) IBOutlet UILabel *sourceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UITextView *abstractTextView;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)deleteEntry:(id)sender;
@end
