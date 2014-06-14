//
//  EntrySvcSqliteTests.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/14/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EntrySvcSqlite.h"

@interface EntrySvcSqliteTests : XCTestCase

@end

@implementation EntrySvcSqliteTests
- (void)testAddUpdateAndRemoveEntry
{
    EntrySvcSqlite *service = [[EntrySvcSqlite alloc] init];
    NSInteger initialCount = [service retrieveAllEntries].count;

    Entry *entry = [[Entry alloc] init];
    entry.mediaTitle = @"Journal of Cool Stuff";
    [entry.authors addObject: @"author 0"];

    entry = [service createEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, initialCount + 1);
    NSLog(@"New entry id: %i", entry.id);
    XCTAssertNotEqual(entry.id, 0);

    entry.details = @"this is a cool paper";
    [entry.authors addObject: @"author 1"];
    NSLog(@"saving author: %@", [entry.authors objectAtIndex:0]);

    [service updateEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, initialCount + 1);

    // find the contact with the same id
    Entry *updatedEntry = nil;
    for (Entry *next in [service retrieveAllEntries]) {
        if (next.id == entry.id) {
            updatedEntry = next;
            break;
        }
    }

    XCTAssertTrue([updatedEntry.details isEqualToString:@"this is a cool paper"], "Update failed, details do not match");

    NSLog(@"found author: %@", [updatedEntry.authors objectAtIndex:1]);
    XCTAssertTrue([[updatedEntry.authors objectAtIndex:1] isEqualToString:@"author 1"], "Update failed, author names do not match");

    [service deleteEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, initialCount);
}

@end
