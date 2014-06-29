//
//  CitationSvcCoreDataTests.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CitationSvcCoreData.h"
#import "DemoDataGenerator.h"

@interface CitationSvcCoreDataTests : XCTestCase

@end

@implementation CitationSvcCoreDataTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"annotated-bibliography.sqlite"];

    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
}


- (void)testServiceContainsDefaultMediaTypes {

    CitationSvcCoreData *service = [[CitationSvcCoreData alloc] init];
    NSArray *mediaTypes = [service retrieveAllMediaTypes];

    XCTAssertEqual(mediaTypes.count, 5);

}

- (void)testAddUpdateAndRemoveCitation {
    CitationSvcCoreData *service = [[CitationSvcCoreData alloc] init];
    XCTAssertEqual([service retrieveAllCitations].count, 0);

    Citation *citation = [service createCitation];
    XCTAssertEqual([service retrieveAllCitations].count, 1);
    citation.typeOfMedia = [[service retrieveAllMediaTypes] objectAtIndex:0];

    citation.mediaTitle = @"Journal of Cool Stuff";

    Author *author = [service createAuthor];
    author.name = @"author 0";
    [citation addAuthorsObject:author];
    XCTAssertEqual(citation.authors.count, 1);
    [service commitChanges];
    XCTAssertEqual([service retrieveAllCitations].count, 1);

    // create a new service to verify changes were comitted.
    citation = nil;
    service = [[CitationSvcCoreData alloc] init];
    XCTAssertEqual([service retrieveAllCitations].count, 1);

    citation = [[service retrieveAllCitations] objectAtIndex:0];
    XCTAssertTrue([citation.mediaTitle isEqualToString:@"Journal of Cool Stuff"], "commit failed, mediaTitles do not match");
    author = [citation.authors objectAtIndex:0];
    XCTAssertTrue([author.name isEqualToString:@"author 0"], "commit failed, author names do not match");

    // update some more information and commit
    citation.details = @"this is a cool paper";
    [citation removeObjectFromAuthorsAtIndex:0];
    XCTAssertEqual(citation.authors.count, 0);
    author = [service createAuthor];
    author.name = @"author 1";
    [citation addAuthorsObject:author];
    XCTAssertEqual(citation.authors.count, 1);

    [service commitChanges];

    // create a new service to verify changes were comitted.
    citation = nil;
    service = [[CitationSvcCoreData alloc] init];
    XCTAssertEqual([service retrieveAllCitations].count, 1);

    citation = [[service retrieveAllCitations] objectAtIndex:0];
    XCTAssertTrue([citation.details isEqualToString:@"this is a cool paper"], "commit failed, details do not match");

    NSLog(@"found author: %@", [citation.authors objectAtIndex:0]);
    author = [citation.authors objectAtIndex:0];
    XCTAssertTrue([author.name isEqualToString:@"author 1"], "commit failed, author names do not match");

    [service deleteCitation:citation];
    XCTAssertEqual([service retrieveAllCitations].count, 0);
    [service commitChanges];

    // create a new service to verify delete was comitted.
    citation = nil;
    service = [[CitationSvcCoreData alloc] init];
    XCTAssertEqual([service retrieveAllCitations].count, 0);
}

- (void)testMatchTitle {
    // add a few citations to enable searching.
    [DemoDataGenerator execute];

    CitationSvcCoreData *service = [[CitationSvcCoreData alloc] init];
    XCTAssertNotEqual([service retrieveAllCitations].count, 0);

    NSArray *results = [service retrieveAllCitationsMatchingTitle:@"Service"];

    XCTAssertEqual(results.count, 1);
}

- (void)testMatchAuthor {
    // add a few citations to enable searching.
    [DemoDataGenerator execute];

    CitationSvcCoreData *service = [[CitationSvcCoreData alloc] init];
    XCTAssertNotEqual([service retrieveAllCitations].count, 0);

    NSArray *results = [service retrieveAllCitationsMatchingAuthor:@"Binkley"];

    XCTAssertEqual(results.count, 1);
}

@end
