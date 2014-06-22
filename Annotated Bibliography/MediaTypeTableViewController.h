//
//  MediaTypeViewControllerTableViewController.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/22/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MediaType.h"

@interface MediaTypeTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *mediaTypes;
@property (nonatomic, strong) id selectedType;


@end
