//
//  DAParseCommentsOperation.m
//  CINeol
//
//  Created by David Arias Vazquez on 24/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DAParseCommentsOperation.h"
#import "DACINeolKeys.h"
#import "DACINeolFacade.h"
#import "DAMovie.h"
#import "DAComment.h"

NSString *const kCommentDateFormat = @"HH:mm - dd/MM/yyyy";


@interface DAParseCommentsOperation ()

@property (retain, nonatomic) DAMovie           *movie;
@property (retain, nonatomic) DAComment         *comment;

@property (retain, nonatomic) NSManagedObjectID *managedObjectID;

@end


@implementation DAParseCommentsOperation

@synthesize movie   = _movie;
@synthesize comment = _comment;

@synthesize managedObjectID = _managedObjectID;

- (id)initWithData:(NSData*)data delegate:(id<DAXMLParserDelegate>)delegate movie:(DAMovie*)movie
{
    if (self = [super initWithData:data delegate:delegate]) {
        self.managedObjectID = [movie objectID];
    }
    
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {    
    self.movie = (DAMovie*)[self.managedObjectContext objectWithID:self.managedObjectID];
    [super parserDidStartDocument:parser];
}


- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName 
     attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kCommentKey]) {
        self.comment = [DACINeolFacade comment];
    }
    
    [super parser:parser
  didStartElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName
       attributes:attributeDict];
}    


- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:kUserKey]) {
        self.comment.user = self.temp;        
    }
    else if ([elementName isEqualToString:kDateKey]) {
        self.comment.date = [[DACalendar defaultCalendar] dateFromString:self.temp
                                                          withDateFormat:kCommentDateFormat];
    }
    else if ([elementName isEqualToString:kMessageKey]) {
        self.comment.message = self.temp;
    }
    else if ([elementName isEqualToString:kCommentKey]) {
        if (self.comment != nil) {
            [self.managedObjectContext insertObject:self.comment];
            [self.movie addCommentsObject:self.comment];
            [self.managedObjectContext save:NULL];            
        }
    }
    
    [super parser:parser
    didEndElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName];
}

- (void) dealloc {
    [_movie release];           _movie = nil;
    [_comment release];         _comment = nil;
    [_managedObjectID release]; _managedObjectID = nil;
    [super dealloc];
}

@end
