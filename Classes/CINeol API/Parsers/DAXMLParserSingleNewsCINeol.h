//
//  DAXMLParserSingleNewsCINeol.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAXMLParser.h"

@class DANews;

@interface DAXMLParserSingleNewsCINeol : DAXMLParser {

    DANews              *_news;
    NSUInteger          _CINeolID;
    NSManagedObjectID   *_managedObjectID;
}

- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate 
            news:(DANews*)news;

- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate    
  newsWithCINeolID:(NSUInteger)CINeolID;

@end