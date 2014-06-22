//
//  CitationSvcCoreData.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "CitationSvcCoreData.h"

@implementation CitationSvcCoreData


NSManagedObjectModel *model = nil;
NSPersistentStoreCoordinator *psc = nil;
NSManagedObjectContext *moc = nil;

- (id) init {
    if (self = [super init]) {
        [self initializeCoreData];
        return self;
    }
    return nil;
}

-(void) initializeCoreData {
    // initialize (load) the schema model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    // initialize the persistent store coordinator with the model
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];

    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"annotated-bibliography.sqlite"];
    NSError *error = nil;
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // initialize the managed object context
        moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc setPersistentStoreCoordinator:psc];
    } else {
        NSLog(@"initializeCoreData FAILED with error: %@", error);
    }

    // populate default media types if they do not already exist in the context
    NSArray *mediaTypes = [self retrieveAllMediaTypes];
    if (mediaTypes.count == 0) {
        [[NSEntityDescription insertNewObjectForEntityForName:@"MediaType" inManagedObjectContext:moc] setType:@"Journal Article"];
        [[NSEntityDescription insertNewObjectForEntityForName:@"MediaType" inManagedObjectContext:moc] setType:@"Book"];
        [[NSEntityDescription insertNewObjectForEntityForName:@"MediaType" inManagedObjectContext:moc] setType:@"Conference Proceedings"];
        [[NSEntityDescription insertNewObjectForEntityForName:@"MediaType" inManagedObjectContext:moc] setType:@"Thesis"];
        [[NSEntityDescription insertNewObjectForEntityForName:@"MediaType" inManagedObjectContext:moc] setType:@"Magazine Article"];

        NSError *error;
        if (![moc save:&error]) {
            NSLog(@"initalize media types ERROR: %@", [error localizedDescription]);
        }
    }
}

- (Author *) createAuthor {
    Author *author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:moc];
    return author;
}

- (Citation *) createCitation {
    Citation *citation = [NSEntityDescription insertNewObjectForEntityForName:@"Citation" inManagedObjectContext:moc];
    // set a default media type
    citation.typeOfMedia = [[self retrieveAllMediaTypes] objectAtIndex:0];
    return citation;
}

- (void) deleteCitation: (Citation *) citation {
    [moc deleteObject:citation];
}

- (void) commitChanges {
    NSError *error;
    if (![moc save:&error]) {
        NSLog(@"commit ERROR: %@", [error localizedDescription]);
    }
}

- (NSArray *) retrieveAllCitations {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Citation" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sourceTitle" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSError *error;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (NSArray *) retrieveAllMediaTypes {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MediaType" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    NSError *error;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}


@end
