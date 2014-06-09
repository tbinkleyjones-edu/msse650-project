//
//  EntrySvcCacheTest.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EntrySvcCache.h"

@interface EntrySvcCacheTests : XCTestCase

@end

@implementation EntrySvcCacheTests

- (void)testAddUpdateAndRemoveEntry
{
    EntrySvcCache *service = [[EntrySvcCache alloc] init];
    XCTAssertEqual([service retrieveAllEntries].count, 0);

    Entry *entry = [[Entry alloc] init];
    entry.mediaTitle = @"Journal of Cool Stuff";

    [service createEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, 1);

    entry.details = @"this is a cool paper";
    [entry.authors addObject:@"author 0"];
    NSLog(@"saving author: %@", [entry.authors objectAtIndex:0]);

    [service updateEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, 1);

    Entry *updatedEntry = [[service retrieveAllEntries] objectAtIndex:0];
    XCTAssertEqual(updatedEntry.details, @"this is a cool paper");

    NSLog(@"found author: %@", [updatedEntry.authors objectAtIndex:0]);
    XCTAssertEqual([updatedEntry.authors objectAtIndex:0], @"author 0");

    [service deleteEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, 0);
}

@end
