//
//  DAParseXMLOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 23/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACINeolOperation.h"

@interface DAParseXMLOperation : DACINeolOperation <NSXMLParserDelegate> {

    @protected
    //id<DAXMLParserDelegate> _delegate;
    NSXMLParser             *_parser;
    NSMutableString         *_elementText;
}

//@property (nonatomic, assign) id<DAXMLParserDelegate> delegate;
@property (nonatomic, retain, readonly) NSMutableString *elementText;

//- (id)initWithData:(NSData*)data delegate:(id<DAXMLParserDelegate>)delegate;

@end


@protocol DAParseXMLOperationDelegate <NSObject>

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