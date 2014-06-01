//
//  EntryOperationDelegate.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/1/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@protocol EntryOperationDelegate <NSObject>

- (void) updateEntry:(Entry *)entry;
- (void) deleteEntry:(Entry *)entry;

@end
