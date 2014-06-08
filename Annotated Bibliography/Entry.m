//
//  Entry.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "Entry.h"

static NSString *const TYPE_OF_MEDIA = @"typeOfMedia";
static NSString *const MEDIA_TITLE = @"mediaTitle";
static NSString *const SOURCE_TITLE = @"sourceTitle";
static NSString *const AUTHORS = @"authors";
static NSString *const DETAILS = @"details";
static NSString *const KEYWORDS = @"keywords";
static NSString *const ABSTRACT = @"abstract";
static NSString *const NOTES = @"notes";
static NSString *const URL = @"url";
static NSString *const DOI = @"doi";


@implementation Entry

- (id) init {
    self = [super init];
    if (self) {
        self.authors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat: @"%@ %@ %@", _sourceTitle, _authors, _mediaTitle];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    // encode with property values
    [coder encodeObject:self.typeOfMedia forKey:TYPE_OF_MEDIA];
    [coder encodeObject:self.mediaTitle forKey:MEDIA_TITLE];
    [coder encodeObject:self.sourceTitle forKey:SOURCE_TITLE];
    [coder encodeObject:self.authors forKey:AUTHORS];
    [coder encodeObject:self.details forKey:DETAILS];
    [coder encodeObject:self.keywords forKey:KEYWORDS];
    [coder encodeObject:self.abstract forKey:ABSTRACT];
    [coder encodeObject:self.notes forKey:NOTES];
    [coder encodeObject:self.url forKey:URL];
    [coder encodeObject:self.doi forKey:DOI];
}

- (id)initWithCoder:(NSCoder *)coder {
    // decode the property values
    self = [super init];
    if (self) {
        _typeOfMedia = [coder decodeObjectForKey:TYPE_OF_MEDIA];
        _mediaTitle = [coder decodeObjectForKey:MEDIA_TITLE];
        _sourceTitle = [coder decodeObjectForKey:SOURCE_TITLE];
        _authors = [coder decodeObjectForKey:AUTHORS];
        _details = [coder decodeObjectForKey:DETAILS];
        _keywords = [coder decodeObjectForKey:KEYWORDS];
        _abstract = [coder decodeObjectForKey:ABSTRACT];
        _notes = [coder decodeObjectForKey:NOTES];
        _url = [coder decodeObjectForKey:URL];
        _doi = [coder decodeObjectForKey:DOI];
    }
    return self;
}


@end
