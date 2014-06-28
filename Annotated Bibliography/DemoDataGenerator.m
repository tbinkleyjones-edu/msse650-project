//
//  DemoDataGenerator.m
//  Annotated Bibliography
//
//  Created by Tim Binkley-Jones on 6/28/14.
//  Copyright (c) 2014 msse650. All rights reserved.
//

#import "DemoDataGenerator.h"
#import "CitationSvcCoreData.h"
#import "MediaType.h"

@implementation DemoDataGenerator

+ (void) execute {

    // if a core data datbase file doesn't exist, create a service and fill it.
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];

    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"annotated-bibliography.sqlite"];

    // if the expected store doesn't exist, create the demo data
	if (![[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
        NSLog(@"generating demo database");

        CitationSvcCoreData *service = [[CitationSvcCoreData alloc] init];
        NSArray *mediaTypes = [service retrieveAllMediaTypes];

        Citation * citation;
        Author * author;

        // add journal entry
        citation = [service createCitation];
        citation.typeOfMedia = [mediaTypes objectAtIndex:2];
        citation.mediaTitle = @"Journal of Systems and Software";
        citation.sourceTitle = @"A survey study of critical success factors in agile software projects";
        citation.abstract = @"While software is so important for all facets of the modern world, software development itself is not a perfect process. Agile software engineering methods have recently emerged as a new and different way of developing software as compared to the traditional method- ologies. However, their success has mostly been anecdotal, and research in this subject is still scant in the academic circles. This research study was a survey study on the critical success factors of Agile software development projects using quantitative approach.";
        citation.details = @"Vol 81, Issue 6, Pages 961-971";
        citation.keywords = @"Software development; Agile methods; Critical success factors";
        citation.url = @"http://www.sciencedirect.com/science/article/pii/S0164121207002208";
        citation.doi = @"10.1016/j.jss.2007.08.020";

        author = [service createAuthor];
        author.name = @"T. Chow";
        [citation addAuthorsObject:author];

        author = [service createAuthor];
        author.name = @"D. Cao";
        [citation addAuthorsObject:author];

        [service commitChanges];


        // add book

        MediaType *book = [mediaTypes objectAtIndex:0];
        NSLog(@"Book type: %@", book.type);

        Citation *bookcitation = [service createCitation];
        bookcitation.typeOfMedia = [mediaTypes objectAtIndex:1];
        bookcitation.typeOfMedia = book;
        bookcitation.mediaTitle = @"Windows Phone 8 in Action";
        bookcitation.sourceTitle = @"Windows Phone 8 in Action";
        bookcitation.details = @"Copyright 2014, Manning Publications Company";
        bookcitation.keywords = @"Software development, Phone, App store";
        bookcitation.url = @"http://manning.com/binkley";
        bookcitation.doi = @"";

        author = [service createAuthor];
        author.name = @"T. Binkley-Jones";
        [bookcitation addAuthorsObject:author];

        author = [service createAuthor];
        author.name = @"A. Benoit";
        [bookcitation addAuthorsObject:author];

        author = [service createAuthor];
        author.name = @"M. Perga";
        [bookcitation addAuthorsObject:author];

        author = [service createAuthor];
        author.name = @"M. Sync";
        [bookcitation addAuthorsObject:author];

        [service commitChanges];

        // add conference proceedings
        citation = [service createCitation];
        citation.typeOfMedia = [mediaTypes objectAtIndex:1];
        citation.mediaTitle = @"Proceedings of the 2010 ACM-IEEE International Symposium on Empirical Software Engineering and Measurement";
        citation.sourceTitle = @"An empirical study on the relationship between the use of agile practices and the success of Scrum projects";
        citation.details = @"ESEM 2010, 1 page";
        citation.abstract = @"In this article, factors considered critical for the success of projects managed using Scrum are correlated to the results of software projects in industry. Using a set of 25 factors compiled in by other researchers, a cross section survey was conducted to evaluate the presence or application of these factors in 11 software projects that used Scrum in 9 different software companies located in Recife-PE, Brazil. The questionnaire was applied to 65 developers and Scrum Masters, representing 75% (65/86) of the professionals that have participated in the projects. The result was correlated with the level of success achieved by the projects, measured by the subjective perception of the project participant, using Spearman's rank correlation coefficient.";
        citation.keywords = @"agile practices; empirical study; project success; scrum; survey";
        citation.url = @"http://portal.acm.org/citation.cfm?doid=1852786.1852835";
        citation.doi = @"10.1145/1852786.1852835";

        author = [service createAuthor];
        author.name = @"França, a. César C.";
        [citation addAuthorsObject:author];

        author = [service createAuthor];
        author.name = @"da Silva, Fabio Q. B.";
        [citation addAuthorsObject:author];

        author = [service createAuthor];
        author.name = @"de Sousa Mariz, Leila M. R.";
        [citation addAuthorsObject:author];

        [service commitChanges];

        // add magazine
        citation = [service createCitation];
        citation.typeOfMedia = [mediaTypes objectAtIndex:3];
        citation.mediaTitle = @"MIS Quarterly Executive";
        citation.sourceTitle = @"Service-Oriented Architecture: Myths, Realities and a Maturity ModelS";
        citation.details = @"2010, Vol. 9, Issue 1, Pages 37-48";
        citation.abstract = @"Service-Oriented Architecture (SOA) is espoused as the next structural innovation within the IT marketplace. Our findings, based on interviews with fifteen key individuals responsible for SOA deployment at ten organizations, suggest that there is a 'disconnect' between the in-print prescriptions regarding SOA and what is actually happening.";
        
        author = [service createAuthor];
        author.name = @"Hirschheim, Rudy";
        [citation addAuthorsObject:author];
        
        author = [service createAuthor];
        author.name = @"Welke, Richard";
        [citation addAuthorsObject:author];
        
        author = [service createAuthor];
        author.name = @"Schwarz, Andrew";
        [citation addAuthorsObject:author];
        
        [service commitChanges];

        bookcitation.typeOfMedia = book;
        [service commitChanges];
	}
}

@end
