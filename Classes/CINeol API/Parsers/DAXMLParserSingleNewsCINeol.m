//
//  DAXMLParserSingleNewsCINeol.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolKeys.h"
#import "DAXMLParserSingleNewsCINeol.h"
#import "DANews.h"
#import "DACINeolFacade.h"


#define kBaseForumCINeolURL @"http://www.cineol.net/forum/viewtopic.php?t=%d"

@interface DAXMLParserSingleNewsCINeol ()

@property (retain, nonatomic) NSManagedObjectID *managedObjectID;
@property (retain, nonatomic) DANews            *news;

@end

@implementation DAXMLParserSingleNewsCINeol

@synthesize managedObjectID = _managedObjectID;
@synthesize news            = _news;


- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate 
              news:(DANews*)news;
{
    if (self = [super initWithData:data delegate:delegate]) {
        self.managedObjectID = [news objectID];
    }
    
    return self;
}

- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate 
  newsWithCINeolID:(NSUInteger)CINeolID
{
    if (self = [super initWithData:data delegate:delegate]) {
        _CINeolID = CINeolID;
        self.managedObjectID = nil;
    }
    
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {  
    
    if (self.managedObjectID == nil)
        self.managedObjectID = [[DACINeolFacade newsWithCINeolID:_CINeolID] objectID];
    
    self.news = (DANews*)[self.managedObjectContext objectWithID:_managedObjectID];   
    
    [super parserDidStartDocument:parser];
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:kForumCINeolIDKey]) {   
        self.news.forumCINeolURL = [NSString stringWithFormat:kBaseForumCINeolURL, 
                                    [self.temp integerValue]];
    }
    else if ([elementName isEqualToString:kVisitsKey]) {
        self.news.numberOfVisits = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kAuthorKey]) {
        self.news.author = self.temp; 
    }
    else if ([elementName isEqualToString:kDateKey]) {    
        self.news.date = [[DACalendar defaultCalendar] dateFromString:self.temp
                                                       withDateFormat:kCINeolDateNewsFormat];        
    }
    else if ([elementName isEqualToString:kContentKey]) {
        self.news.body = self.temp;         
    }
    else if ([elementName isEqualToString:kCommentsNewsKey]) {
        self.news.numberOfComments = [self.temp intValue];
    }
    else if ([elementName isEqualToString:kNewsKey]) {
        [self.managedObjectContext save:NULL];  //TODO - Manejar error como es debido...
    }


    [super parser:parser
    didEndElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName];
}

#pragma mark -
#pragma mark Memory Management
- (void) dealloc {
    [_news release];            _news = nil;
    [_managedObjectID release]; _managedObjectID = nil;
    
    [super dealloc];
}

@end
