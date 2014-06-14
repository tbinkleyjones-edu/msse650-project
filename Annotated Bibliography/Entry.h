//
//  Entry.h
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 5/25/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject

/*
 The information tracked for each bibliographic source may include:
 •	The type of media (i.e. book, journal, article, web site)
 •	The title of the media (i.e. book title, journal title, magazine name)
 •	The title of the source (i.e. article title, paper title)
 •	One or more authors
 •	Details (i.e. page number, volume)
 •	Keywords
 •	Abstract
 •	Notes
 •	URL
 •	DOI
 */

@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *typeOfMedia;
@property (nonatomic, strong) NSString *mediaTitle;
@property (nonatomic, strong) NSString *sourceTitle;
@property (nonatomic, strong) NSMutableArray *authors;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *abstract;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *doi;

@end
