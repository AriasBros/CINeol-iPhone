//
//  CEXMLParser.h
//  Cineol
//
//  Created by David Arias Vazquez on 03/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAXMLParserDelegate;

@interface DAXMLParser : NSOperation <NSXMLParserDelegate> {
    
    @protected
    id<DAXMLParserDelegate> _delegate;
    NSXMLParser             *_parser;
    NSMutableString         *_temp;
    NSManagedObjectContext  *_managedObjectContext;
}

@property (nonatomic, assign) id<DAXMLParserDelegate> delegate;
@property (nonatomic, retain, readonly) NSMutableString *temp;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;


- (id)initWithData:(NSData*)data delegate:(id<DAXMLParserDelegate>)delegate;
- (void) parse;


#pragma mark Subclassing Methods.
- (void)parserDidStartDocument:(NSXMLParser *)parser;
- (void)parserDidEndDocument:(NSXMLParser *)parser;

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict;

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName;

- (void) parser:(NSXMLParser *)parser
 foundAttribute:(NSString*)attributeName
      withValue:(id)value 
     forElement:(NSString *)elementName;

@end



@protocol DAXMLParserDelegate <NSObject>

@optional
- (void) parserDidStartDocument:(id)parser;
- (void) parserDidEndDocument:(id)parser;
- (void) parser:(id)parser didStartElement:(NSString *)elementName;
- (void) parser:(id)parser didEndElement:(NSString *)elementName;
- (void) parser:(id)parser 
 foundAttribute:(NSString*)attributeName
      withValue:(id)value 
     forElement:(NSString *)elementName;

@end