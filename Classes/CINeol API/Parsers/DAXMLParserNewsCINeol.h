//
//  DAXMLParserNewsCINeol.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAXMLParser.h"

@class DANews;
@class DAPhoto;

@interface DAXMLParserNewsCINeol : DAXMLParser {

    @protected
    DANews  *_news; 
    DAPhoto *_photo;
}

@end
