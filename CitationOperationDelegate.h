//
//  CitationOperationDelegate.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Author.h"
#include "Citation.h"

@protocol CitationOperationDelegate <NSObject>

- (Author *) createAuthor;
- (void) updateCitation:(Citation *)citation;
- (void) deleteCitation:(Citation *)citation;

@end
