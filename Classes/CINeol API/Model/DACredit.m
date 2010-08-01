// 
//  DACredit.m
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import "DACredit.h"

#import "DAMovie.h"
#import "DAPerson.h"

@implementation DACredit 

@dynamic type;
@dynamic job;
@dynamic movie;
@dynamic person;


- (void) setType:(DACreditType)type {
    [super willChangeValueForKey: @"type"];
    [super setPrimitiveValue: [NSNumber numberWithInt: type] forKey: @"type"];
    [super didChangeValueForKey: @"type"];
}

- (DACreditType) type {
    [super willAccessValueForKey: @"type"];
    DACreditType type =[(NSNumber*)[super primitiveValueForKey: @"type"] intValue];
    [super didAccessValueForKey: @"type"];
    
    return type;
}

@end
