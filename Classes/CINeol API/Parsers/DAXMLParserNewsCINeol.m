//
//  DAXMLParserNewsCINeol.m
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACINeolKeys.h"
#import "DAXMLParserNewsCINeol.h"
#import "DAXMLParserSingleNewsCINeol.h"
#import "DANews.h"
#import "DAPhoto.h"
#import "DACINeolFacade.h"

#import <DATouchKit/UIImageAdds.h>


@interface DAXMLParserNewsCINeol ()

@property (nonatomic, retain) DANews    *news;
@property (nonatomic, retain) DAPhoto   *photo;

@end

@implementation DAXMLParserNewsCINeol

@synthesize news  = _news;
@synthesize photo = _photo;

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:kCINeolIDNewsKey]) {   
        self.news  = [DACINeolFacade news];
        self.photo = [DACINeolFacade photo];
        
        self.news.CINeolID = [self.temp integerValue];
        self.photo.photoID  = self.news.CINeolID;        
    }
    else if ([elementName isEqualToString:kTitleNewsKey]) {
        self.news.title = self.temp;
    }
    else if ([elementName isEqualToString:kIntroductionKey]) {
        self.news.introduction = self.temp;
    }
    else if ([elementName isEqualToString:kImageURLKey]) {
        self.photo.photoURL = self.temp;
    }
    else if ([elementName isEqualToString:kCommentsNewsKey]) {
        self.news.numberOfComments = [self.temp intValue];        
    }
    else if ([elementName isEqualToString:kNewsKey]) {          
        DANews *news = [DACINeolFacade newsWithCINeolID:self.news.CINeolID];
                
        if (news == nil) {
            if (self.photo.photoURL != nil) {            
                NSURL *url = [[NSURL alloc] initWithString:self.photo.photoURL];
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
                NSData *data = [NSURLConnection sendSynchronousRequest:request 
                                                     returningResponse:NULL
                                                                 error:NULL];
                [url release];
                [request release];
                
                self.photo.photo = [UIImage imageWithData:data];
            }
            
            [self.managedObjectContext insertObject:self.photo];
            [self.managedObjectContext insertObject:self.news];
            
            self.news.photo = self.photo;
            
            [self.managedObjectContext save:NULL];  //TODO - Manejar apropiadamente el error.
        }
    }
    
    [super parser:parser
    didEndElement:elementName
     namespaceURI:namespaceURI
    qualifiedName:qualifiedName];
}

- (void) dealloc {
    [_news release];    _news = nil;
    [_photo release];   _photo = nil;
    [super dealloc];
}

@end