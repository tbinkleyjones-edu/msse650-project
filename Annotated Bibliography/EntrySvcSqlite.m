//
//  EntrySvcSqlite.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/14/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "EntrySvcSqlite.h"
#import <sqlite3.h>

sqlite3 *database = nil;

NSString * const CREATE_ENTRY_TABLE_SQL = @"CREATE TABLE IF NOT EXISTS entry (id INTEGER PRIMARY KEY AUTOINCREMENT, typeOfMedia VARCHAR(30), mediaTitle VARCHAR(100), sourceTitle VARCHAR(100), details VARCHAR(100), keywords VARCHAR(100), abstract VARCHAR(1000), notes VARCHAR(1000), url VARCHAR(100), doi VARCHAR(100))";
NSString * const CREATE_AUTHOR_TABLE_SQL = @"CREATE TABLE IF NOT EXISTS author (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(30), entryId INTEGER, FOREIGN KEY(entryId) REFERENCES entry(id))";

NSString * const INSERT_ENTRY_SQL = @"INSERT INTO entry (typeOfMedia, mediaTitle, sourceTitle, details, keywords, abstract, notes, url, doi) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
NSString * const SELECT_ENTRY_SQL = @"SELECT * FROM entry ORDER BY sourceTitle";
NSString * const UPDATE_ENTRY_SQL = @"UPDATE entry SET typeOfMedia=?, mediaTitle=?, sourceTitle=?, details=?, keywords=?, abstract=?, notes=?, url=?, doi=? WHERE id=?";
NSString * const DELETE_ENTRY_SQL = @"DELETE FROM entry WHERE id=?";

NSString * const SELECT_AUTHOR_SQL = @"SELECT name FROM author WHERE entryId=? ORDER BY name";
NSString * const INSERT_AUTHOR_SQL = @"INSERT INTO author (name, entryId) VALUES (?, ?)";
NSString * const DELETE_AUTHOR_SQL = @"DELETE FROM author WHERE entryId=?";

@implementation EntrySvcSqlite

- (id) init {
    if (self = [super init]) {
        // find the document directory
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];

        // append file name
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"annotated-bibliography.sqlite3"]];

        // open the database (it will be created if it does not exist)
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            NSLog(@"database is open");
            NSLog(@"database file path: %@", databasePath);

            char *errMsg;
            if (sqlite3_exec(database, [CREATE_ENTRY_TABLE_SQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table %s", errMsg);
            }

            if (sqlite3_exec(database, [CREATE_AUTHOR_TABLE_SQL UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table %s", errMsg);
            }

        } else {
            NSLog(@"*** Failed to open database!");
            NSLog(@"*** SQL error: %ss\n", sqlite3_errmsg(database));
        }
    }
    return self;
}


- (Entry *) createEntry: (Entry *) entry {
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, [INSERT_ENTRY_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [entry.typeOfMedia UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [entry.mediaTitle UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [entry.sourceTitle UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [entry.details UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 5, [entry.keywords UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 6, [entry.abstract UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 7, [entry.notes UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 8, [entry.url UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 9, [entry.doi UTF8String], -1, NULL);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            entry.id = (int)sqlite3_last_insert_rowid(database);
            NSLog(@"*** Entry added");
        } else {
            NSLog(@"*** Entry NOT added");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Entry NOT added");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }

    [self insertAuthors:entry];
    return entry;
}

- (NSArray *) retrieveAllEntries {
    NSMutableArray *entries = [NSMutableArray array];

    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, [SELECT_ENTRY_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"*** Entries retrieved");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int id = sqlite3_column_int(statement, 0);
            char *typeOfMedia = (char *)sqlite3_column_text(statement, 1);
            char *mediaTitle = (char *)sqlite3_column_text(statement, 2);
            char *sourceTitle = (char *)sqlite3_column_text(statement, 3);
            char *details = (char *)sqlite3_column_text(statement, 4);
            char *keywords = (char *)sqlite3_column_text(statement, 5);
            char *abstract = (char *)sqlite3_column_text(statement, 6);
            char *notes = (char *)sqlite3_column_text(statement, 7);
            char *url = (char *)sqlite3_column_text(statement, 8);
            char *doi = (char *)sqlite3_column_text(statement, 9);

            Entry *entry = [[Entry alloc] init];
            entry.id = id;
            entry.typeOfMedia = typeOfMedia == NULL ? nil : [[NSString alloc] initWithUTF8String:typeOfMedia];
            entry.mediaTitle = mediaTitle == NULL ? nil : [[NSString alloc] initWithUTF8String:mediaTitle];
            entry.sourceTitle = sourceTitle == NULL ? nil : [[NSString alloc] initWithUTF8String:sourceTitle];
            entry.details = details == NULL ? nil : [[NSString alloc] initWithUTF8String:details];
            entry.keywords = keywords == NULL ? nil : [[NSString alloc] initWithUTF8String:keywords];
            entry.abstract = abstract == NULL ? nil : [[NSString alloc] initWithUTF8String:abstract];
            entry.notes = notes == NULL ? nil : [[NSString alloc] initWithUTF8String:notes];
            entry.url = url == NULL ? nil : [[NSString alloc] initWithUTF8String:url];
            entry.doi = doi == NULL ? nil : [[NSString alloc] initWithUTF8String:doi];

            [self retrieveAuthors:entry];

            [entries addObject:entry];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Entries NOT retrieved");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }

    return entries;
}

- (Entry *) updateEntry: (Entry *) entry {
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, [UPDATE_ENTRY_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {

        sqlite3_bind_text(statement, 1, [entry.typeOfMedia UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [entry.mediaTitle UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [entry.sourceTitle UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [entry.details UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 5, [entry.keywords UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 6, [entry.abstract UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 7, [entry.notes UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 8, [entry.url UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 9, [entry.doi UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 10, entry.id);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"*** Entry updated");
        } else {
            NSLog(@"*** Entry NOT updated");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Entry NOT updated");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }

    // authors are updated by deleted all, then reinserting them
    [self deleteAuthors:entry];
    [self insertAuthors:entry];

    return entry;
}

- (Entry *) deleteEntry: (Entry *) entry {
    sqlite3_stmt *statement;

    [self deleteAuthors:entry];

    if (sqlite3_prepare_v2(database, [DELETE_ENTRY_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, entry.id);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"*** Entry deleted");
        } else {
            NSLog(@"*** Entry NOT deleted");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Entry NOT deleted");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }

    return entry;
}

- (void) retrieveAuthors: (Entry *) entry {
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, [SELECT_AUTHOR_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"*** Authors retrieved");
        sqlite3_bind_int(statement, 1, entry.id);

        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 0);
            [entry.authors addObject:[[NSString alloc] initWithUTF8String:name]];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Authors NOT retrieved");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
}

- (void) insertAuthors: (Entry *) entry {
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, [INSERT_AUTHOR_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        for (NSString *name in entry.authors) {
            sqlite3_bind_text(statement, 1, [name UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 2, entry.id);

            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"*** Author added");
            } else {
                NSLog(@"*** Author NOT added");
                NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Author NOT added");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
}

- (void) deleteAuthors: (Entry *) entry {
    sqlite3_stmt *statement;

    if (sqlite3_prepare_v2(database, [DELETE_AUTHOR_SQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, entry.id);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"*** Authors deleted");
        } else {
            NSLog(@"*** Authors NOT deleted");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Authors NOT deleted");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
}

@end
