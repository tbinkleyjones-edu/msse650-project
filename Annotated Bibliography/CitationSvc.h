//
//  CitationSvc.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"
#import "Citation.h"

@protocol CitationSvc <NSObject>

- (Author *) createAuthor;

- (Citation *) createCitation;
- (void) deleteCitation: (Citation *) citation;

- (void) commitChanges;

- (NSArray *) retrieveAllCitations;
- (NSArray *) retrieveAllCitationsMatchingTitle: (NSString *)title;
- (NSArray *) retrieveAllCitationsMatchingAuthor: (NSString *)author;

- (NSArray *) retrieveAllMediaTypes;

@end
