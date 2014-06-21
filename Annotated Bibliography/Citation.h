//
//  Citation.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author, MediaType;

@interface Citation : NSManagedObject

@property (nonatomic, retain) NSString * mediaTitle;
@property (nonatomic, retain) NSString * sourceTitle;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * doi;
@property (nonatomic, retain) MediaType *typeOfMedia;
@property (nonatomic, retain) NSOrderedSet *authors;
@end

@interface Citation (CoreDataGeneratedAccessors)

- (void)insertObject:(Author *)value inAuthorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAuthorsAtIndex:(NSUInteger)idx;
- (void)insertAuthors:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAuthorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAuthorsAtIndex:(NSUInteger)idx withObject:(Author *)value;
- (void)replaceAuthorsAtIndexes:(NSIndexSet *)indexes withAuthors:(NSArray *)values;
- (void)addAuthorsObject:(Author *)value;
- (void)removeAuthorsObject:(Author *)value;
- (void)addAuthors:(NSOrderedSet *)values;
- (void)removeAuthors:(NSOrderedSet *)values;
@end
