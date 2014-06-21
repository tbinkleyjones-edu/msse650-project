//
//  MediaType.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/21/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Citation;

@interface MediaType : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Citation *citations;

@end
