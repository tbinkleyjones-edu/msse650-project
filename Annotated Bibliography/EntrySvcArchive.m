//
//  EntrySvcArchive.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/8/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "EntrySvcArchive.h"

@implementation EntrySvcArchive

NSString *filePath;
NSMutableArray *entries;

- (id)init {
    // find the document directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];

    // append file name
    filePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"Entries.archive"]];

    [self reachArchive];

    return self;
}

- (void)reachArchive {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:filePath]) {
        entries = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        entries = [NSMutableArray array];
    }
}

- (void)writeArchive {
    [NSKeyedArchiver archiveRootObject:entries toFile:filePath];

}

- (Entry *)createEntry:(Entry *)entry {
    [entries addObject:entry];
    [self writeArchive];
    return entry;
}

- (NSArray *)retrieveAllEntries {
    return entries;
}

- (Entry *)updateEntry:(Entry *)entry {
    [self writeArchive];
    return entry;
}

- (Entry *)deleteEntry:(Entry *)entry {
    [entries removeObject: entry];
    [self writeArchive];
    return entry;
}


@end
