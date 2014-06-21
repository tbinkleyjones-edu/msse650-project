//
//  Citation.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "Citation.h"
#import "Author.h"
#import "MediaType.h"


@implementation Citation

@dynamic mediaTitle;
@dynamic sourceTitle;
@dynamic details;
@dynamic keywords;
@dynamic abstract;
@dynamic notes;
@dynamic url;
@dynamic doi;
@dynamic typeOfMedia;
@dynamic authors;

// Note: there is a known bug with Core Data and ordered sets that requires an override of the generated accessors.

- (void)removeObjectFromAuthorsAtIndex:(NSUInteger)idx; {
    Author *author = [self.authors objectAtIndex:idx];
    [self removeAuthorsObject:author];
}


- (void)addAuthorsObject:(Author *)value;
{
    NSMutableOrderedSet* authors = [NSMutableOrderedSet orderedSetWithOrderedSet:self.authors];
    [authors addObject:value];
    self.authors = authors;
}

- (void)removeAuthorsObject:(Author *)value;
{
    NSMutableOrderedSet* authors = [NSMutableOrderedSet orderedSetWithOrderedSet:self.authors];
    [authors removeObject:value];
    self.authors = authors;
}

@end
