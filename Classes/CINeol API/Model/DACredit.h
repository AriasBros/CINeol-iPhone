//
//  DACredit.h
//  CINeol
//
//  Created by David Arias Vazquez on 11/07/10.
//  Copyright 2010 Yo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DAMovie;
@class DAPerson;

typedef enum {
    DACreditTypePerformer,
    DACreditTypeDirector,
    DACreditTypeProducer,
    DACreditTypeScriptwriter,
    DACreditTypePhotographer,
    DACreditTypeMusician,    
} DACreditType;

@interface DACredit :  NSManagedObject  
{
}

@property (nonatomic, assign) DACreditType  type;
@property (nonatomic, copy) NSString      *job;
@property (nonatomic, retain) DAMovie       *movie;
@property (nonatomic, retain) DAPerson      *person;

@end



