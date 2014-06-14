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

            NSString *createEntrySql =
            @"CREATE TABLE IF NOT EXISTS entry (id INTEGER PRIMARY KEY AUTOINCREMENT, typeOfMedia VARCHAR(30), mediaTitle VARCHAR(100), sourceTitle VARCHAR(100), details VARCHAR(100), keywords VARCHAR(100), abstract VARCHAR(1000), notes VARCHAR(1000), url VARCHAR(100), doi VARCHAR(100))";
            char *errMsg;
            if (sqlite3_exec(database, [createEntrySql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table %s", errMsg);
            }

            NSString *createAuthorSql = @"CREATE TABLE IF NOT EXISTS author (id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(30), entryId INTEGER, FOREIGN KEY(entryId) REFERENCES entry(id))";
            if (sqlite3_exec(database, [createAuthorSql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
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
    NSString *insertEntrySQL = [NSString stringWithFormat:
                           @"INSERT INTO entry (typeOfMedia, mediaTitle, sourceTitle, details, keywords, abstract, notes, url, doi) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                           entry.typeOfMedia, entry.mediaTitle, entry.sourceTitle, entry.details, entry.keywords, entry.abstract, entry.notes, entry.url, entry.doi];

    if (sqlite3_prepare_v2(database, [insertEntrySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
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
    NSString *selectEntrySQL = [NSString stringWithFormat:
                           @"SELECT * FROM entry ORDER BY sourceTitle"];

    if (sqlite3_prepare_v2(database, [selectEntrySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"*** Entries retrieved");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int id = sqlite3_column_int(statement, 0);
            char *typeOfMediaChars = (char *)sqlite3_column_text(statement, 1);
            char *mediaTitleChars = (char *)sqlite3_column_text(statement, 2);
            char *sourceTitleChars = (char *)sqlite3_column_text(statement, 3);
            char *detailsChars = (char *)sqlite3_column_text(statement, 4);
            char *keywordsChars = (char *)sqlite3_column_text(statement, 5);
            char *abstractChars = (char *)sqlite3_column_text(statement, 6);
            char *notesChars = (char *)sqlite3_column_text(statement, 7);
            char *urlChars = (char *)sqlite3_column_text(statement, 8);
            char *doiChars = (char *)sqlite3_column_text(statement, 9);

            Entry *entry = [[Entry alloc] init];
            entry.id = id;
            entry.typeOfMedia = [[NSString alloc] initWithUTF8String:typeOfMediaChars];
            entry.mediaTitle = [[NSString alloc] initWithUTF8String:mediaTitleChars];
            entry.sourceTitle = [[NSString alloc] initWithUTF8String:sourceTitleChars];
            entry.details = [[NSString alloc] initWithUTF8String:detailsChars];
            entry.keywords = [[NSString alloc] initWithUTF8String:keywordsChars];
            entry.abstract = [[NSString alloc] initWithUTF8String:abstractChars];
            entry.notes = [[NSString alloc] initWithUTF8String:notesChars];
            entry.url = [[NSString alloc] initWithUTF8String:urlChars];
            entry.doi = [[NSString alloc] initWithUTF8String:doiChars];

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
    NSString *updateEntrySQL = [NSString stringWithFormat:
                           @"UPDATE entry SET typeOfMedia=\"%@\", mediaTitle=\"%@\", sourceTitle=\"%@\", details=\"%@\", keywords=\"%@\", abstract=\"%@\", notes=\"%@\", url=\"%@\", doi=\"%@\" WHERE id=%li", entry.typeOfMedia, entry.mediaTitle, entry.sourceTitle, entry.details, entry.keywords, entry.abstract, entry.notes, entry.url, entry.doi, (long)entry.id];

    if (sqlite3_prepare_v2(database, [updateEntrySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
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

    NSString *deleteEntrySQL = [NSString stringWithFormat:
                           @"DELETE FROM entry WHERE id=%li",
                           (long)entry.id];

    if (sqlite3_prepare_v2(database, [deleteEntrySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
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
    NSString *selectSQL = [NSString stringWithFormat:
                           @"SELECT name FROM author WHERE entryId=%li ORDER BY name", (long)entry.id];

    if (sqlite3_prepare_v2(database, [selectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"*** Authors retrieved");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameChars = (char *)sqlite3_column_text(statement, 0);
            [entry.authors addObject:[[NSString alloc] initWithUTF8String:nameChars]];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Authors NOT retrieved");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
}

- (void) insertAuthors: (Entry *) entry {
    sqlite3_stmt *statement;

    // TODO: use params and reuse statement.
    for (NSString *name in entry.authors) {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO author (name, entryId) VALUES (\"%@\", \"%li\")",
                               name, (long)entry.id];

        if (sqlite3_prepare_v2(database, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                NSLog(@"*** Author added");
            } else {
                NSLog(@"*** Author NOT added");
                NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
        } else {
            NSLog(@"*** Author NOT added");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
    }
}

- (void) deleteAuthors: (Entry *) entry {
    sqlite3_stmt *statement;

    NSString *deleteSQL = [NSString stringWithFormat:
                                @"DELETE FROM author WHERE entryId=%li",
                                (long)entry.id];

    if (sqlite3_prepare_v2(database, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
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
