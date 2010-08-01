//
//  DAParseCommentsOperation.h
//  CINeol
//
//  Created by David Arias Vazquez on 24/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAXMLParser.h"

@class DAMovie;
@class DAComment;

@interface DAParseCommentsOperation : DAXMLParser {

    @protected
    DAMovie             *_movie;
    DAComment           *_comment;
    NSManagedObjectID   *_managedObjectID;
}

- (id)initWithData:(NSData*)data 
          delegate:(id<DAXMLParserDelegate>)delegate
             movie:(DAMovie*)movie;

@end
