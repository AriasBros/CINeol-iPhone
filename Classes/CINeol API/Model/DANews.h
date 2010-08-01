//
//  DANews.h
//  CINeol
//
//  Created by David Arias Vazquez on 10/04/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DACINeolObject.h"

NSString* const kCINeolDateNewsFormat;
NSString* const kCINeolTitleDateNewsFormat;

@interface DANews : DACINeolObject {
}

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, retain, readonly) NSString *dateString;


- (BOOL) needsDownloadContent;

@end
