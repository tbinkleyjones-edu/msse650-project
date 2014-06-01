//
//  MasterViewController.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntrySvcCache.h"
#import "EntryOperationDelegate.h"


@interface MasterViewController : UITableViewController <EntryOperationDelegate>

@property (strong, nonatomic) EntrySvcCache *entries;

@end
