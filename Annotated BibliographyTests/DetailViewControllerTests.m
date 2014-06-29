//
//  DetailViewControllerTests.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/28/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DetailViewController.h"
#import "DemoDataGenerator.h"
#import "CitationSvcCoreData.h"

@interface DetailViewControllerTests : XCTestCase

@end

@implementation DetailViewControllerTests {
    DetailViewController *viewController;
    Citation *citation;
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"annotated-bibliography.sqlite"];

    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

    [DemoDataGenerator execute];

    CitationSvcCoreData *service = [[CitationSvcCoreData alloc] init];
    citation = [[service retrieveAllCitationsMatchingTitle:@"Windows"] objectAtIndex:0];

    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewControllerID"];
    viewController.detailItem = citation;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNumberOfAuthorInViewMode {
    NSInteger count = [viewController tableView:viewController.tableView  numberOfRowsInSection: 1];

    XCTAssertEqual(count, citation.authors.count);
}

- (void)testNumberOfAuthorInEditMode {
    [viewController setEditing:YES animated:NO];
    NSInteger count = [viewController tableView:viewController.tableView  numberOfRowsInSection: 1];

    XCTAssertEqual(count, citation.authors.count + 1);
}


@end
