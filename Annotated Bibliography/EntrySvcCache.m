//
//  EntrySvcCach.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "EntrySvcCache.h"


@implementation EntrySvcCache : NSObject

NSMutableArray *entries = nil;

- (id) init {
    if (self = [super init]) {
        entries = [NSMutableArray array];
        return self;
    }
    return nil;
}

- (id) initWithSampleData {
    if (self = [super init]) {
        entries = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            Entry *entry = [[Entry alloc] init];
            entry.sourceTitle = [NSString stringWithFormat: @"paper %d", i];
            entry.mediaTitle = @"Journal of Something Special";
            entry.authors = [NSString stringWithFormat: @"author %d", i];
            entry.abstract = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ligula purus, tempor ut eleifend quis, porta vitae lorem. Integer rutrum quam eu turpis pharetra, non vulputate ipsum aliquet. Vestibulum feugiat, erat et eleifend commodo, lorem diam iaculis sem, id consectetur dui purus nec libero. Suspendisse ac accumsan nunc. Duis vitae elit vel nibh semper dictum sed vel libero. Etiam gravida nec dui ac mollis. Nunc quis tellus vel felis sodales pretium nec a magna. Pellentesque sed eleifend augue, ac pellentesque augue. In hac habitasse platea dictumst. Nullam auctor viverra arcu quis faucibus. Proin a enim suscipit, fringilla nisi vitae, aliquam mauris. Vestibulum at erat arcu. Cras faucibus enim et nunc aliquet aliquam. Suspendisse potenti.";
            entry.notes = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ligula purus, tempor ut eleifend quis, porta vitae lorem. Integer rutrum quam eu turpis pharetra, non vulputate ipsum aliquet. Vestibulum feugiat, erat et eleifend commodo, lorem diam iaculis sem, id consectetur dui purus nec libero. Suspendisse ac accumsan nunc. Duis vitae elit vel nibh semper dictum sed vel libero. Etiam gravida nec dui ac mollis. Nunc quis tellus vel felis sodales pretium nec a magna. Pellentesque sed eleifend augue, ac pellentesque augue. In hac habitasse platea dictumst. Nullam auctor viverra arcu quis faucibus. Proin a enim suscipit, fringilla nisi vitae, aliquam mauris. Vestibulum at erat arcu. Cras faucibus enim et nunc aliquet aliquam. Suspendisse potenti.";
            [entries addObject:entry];
        }
        return self;
    }
    return nil;
}

- (Entry *) createEntry: (Entry *) entry {
    [entries addObject:entry];
    return entry;
}

- (NSMutableArray *) retrieveAllEntries {
    return entries;
}

- (Entry *) updateEntry: (Entry *) entry {
    return entry;
}

- (Entry *) deleteEntry: (Entry *) entry {
    [entries removeObject:entry];
    return entry;
}


@end
