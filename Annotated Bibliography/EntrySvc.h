//
//  EntrySvc.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@protocol EntrySvc <NSObject>

- (Entry *) createEntry: (Entry *) entry;
- (NSArray *) retrieveAllEntries;
- (Entry *) updateEntry: (Entry *) entry;
- (Entry *) deleteEntry: (Entry *) entry;

@end
