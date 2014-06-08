//
//  EntrySvcArchiveTests.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/8/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EntrySvcArchive.h"

@interface EntrySvcArchiveTests : XCTestCase

@end

@implementation EntrySvcArchiveTests

- (void)testAddUpdateAndRemoveEntry
{
    EntrySvcArchive *service = [[EntrySvcArchive alloc] init];
    NSInteger initialCount = [service retrieveAllEntries].count;

    Entry *entry = [[Entry alloc] init];
    entry.mediaTitle = @"Journal of Cool Stuff";

    [service createEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, initialCount + 1);

    entry.details = @"this is a cool paper";
    [entry.authors addObject: @"author 0"];
    NSLog(@"saving author: %@", [entry.authors objectAtIndex:0]);

    [service updateEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, initialCount + 1);

    NSInteger indexOfEntry = [[service retrieveAllEntries] indexOfObject:entry];
    Entry *updatedEntry = [[service retrieveAllEntries] objectAtIndex:indexOfEntry];
    XCTAssertEqual(updatedEntry.details, @"this is a cool paper");

    NSLog(@"found author: %@", [updatedEntry.authors objectAtIndex:0]);
    XCTAssertEqual([updatedEntry.authors objectAtIndex:0], @"author 0");

    [service deleteEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, initialCount);
}

@end
