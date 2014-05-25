//
//  EntrySvcCach.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "EntrySvcCache.h"


@implementation EntrySvcCache : NSObject

NSMutableArray *entries = nil;

- (id) init {
    if (self = [super init]) {
        entries = [NSMutableArray array];
        return self;
    }
    return nil;
}

- (id) initWithSampleData {
    if (self = [super init]) {
        entries = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            Entry *entry = [[Entry alloc] init];
            entry.sourceTitle = [NSString stringWithFormat: @"paper %d", i];
            entry.authors = [NSString stringWithFormat: @"author %d", i];
            [entries addObject:entry];
        }
        return self;
    }
    return nil;
}

- (Entry *) createEntry: (Entry *) entry {
    [entries addObject:entry];
    return entry;
}

- (NSMutableArray *) retrieveAllEntries {
    return entries;
}

- (Entry *) updateEntry: (Entry *) entry {
    return entry;
}

- (Entry *) deleteEntry: (Entry *) entry {
    [entries removeObject:entry];
    return entry;
}


@end
