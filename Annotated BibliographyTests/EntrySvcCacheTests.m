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

//- (void)setUp
//{
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown
//{
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}

- (void)testAddUpdateAndRemoveEntry
{
    EntrySvcCache *service = [[EntrySvcCache alloc] init];
    XCTAssertEqual([service retrieveAllEntries].count, 0);

    Entry *entry = [[Entry alloc] init];
    entry.mediaTitle = @"Journal of Cool Stuff";

    [service createEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, 1);

    entry.details = @"this is a cool paper";
    [service updateEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, 1);
    Entry *updatedEntry = [[service retrieveAllEntries] objectAtIndex:0];
    XCTAssertEqual(updatedEntry.details, @"this is a cool paper");

    [service deleteEntry:entry];
    XCTAssertEqual([service retrieveAllEntries].count, 0);
}

@end
