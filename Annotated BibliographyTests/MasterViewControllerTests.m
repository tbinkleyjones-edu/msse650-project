//
//  MasterViewControllerTests.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/28/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MasterViewController.h"
#import "DemoDataGenerator.h"

@interface MasterViewControllerTests : XCTestCase

@end

@implementation MasterViewControllerTests {
    MasterViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"annotated-bibliography.sqlite"];

    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

    [DemoDataGenerator execute];

    viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterViewControllerID"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController = nil;

    [super tearDown];
}

- (void)testViewControllerFillsCellWithData {
    UITableViewCell *cell = [viewController tableView:viewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    XCTAssertNotNil(cell);
    XCTAssertNotNil(cell.textLabel);
    XCTAssertNotNil(cell.detailTextLabel);
    NSLog(@"%@ and %@", cell.textLabel.text, cell.detailTextLabel.text);
    XCTAssertTrue([cell.textLabel.text isEqualToString:@"A survey study of critical success factors in agile software projects"], @"%@ does not match %@", cell.textLabel.text, @"A survey study of critical success factors in agile software projects");
    XCTAssertTrue([cell.detailTextLabel.text isEqualToString:@"T. Chow"], @"%@ does not match %@", cell.detailTextLabel.text, @"T. Chow");
}

@end
