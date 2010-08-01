//
//  CEXMLParser.m
//  Cineol
//
//  Created by David Arias Vazquez on 03/09/09.
//  Copyright 2009 Yo. All rights reserved.
//

#import "DAXMLParser.h"
#import "DACoreDataManager.h"

@interface DAXMLParser ()

@property (nonatomic, retain) NSMutableString *temp;
@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


- (BOOL) isValidString: (NSString*) string;
- (void) _didStartDocument;
- (void) _didEndDocument;
- (void) _didStartElement:(NSString*)element;
- (void) _didEndElement:(NSString*)element;
- (void) _foundAttribute:(NSArray*)array;

@end


@implementation DAXMLParser

@synthesize delegate = _delegate;
@synthesize temp = _temp;
@synthesize parser = _parser;
@synthesize managedObjectContext = _managedObjectContext;


- (id)initWithData:(NSData*)data delegate:(id<DAXMLParserDelegate>)delegate {
    if (self = [super init]) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData: data];
        self.parser = parser;
        
        NSMutableString *string = [[NSMutableString alloc] initWithCapacity:50];
        self.temp = string;
        
        [self.parser setDelegate: self];
        [self.parser setShouldProcessNamespaces: YES];
        
        self.delegate = delegate;
        
        [string release];
        [parser release];
    }
    
    return self;    
}

- (void) mergeChanges:(NSNotification*)notification {   
    [[[DACoreDataManager sharedManager] managedObjectContext]
     performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                      withObject:notification
                   waitUntilDone:YES];
}


- (void) main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:
     [[DACoreDataManager sharedManager] persistentStoreCoordinator]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    
    [self.parser parse];
    
    [pool drain];
    [self.managedObjectContext reset];
}

- (void) parse {
    [self performSelectorInBackground:@selector(main) withObject:nil];
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    [self performSelectorOnMainThread:@selector(_didStartDocument)
                           withObject:nil
                        waitUntilDone:YES];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self performSelectorOnMainThread:@selector(_didEndDocument)
                           withObject:nil
                        waitUntilDone:YES];
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict
{
    NSRange range;
    range.location = 0;
    range.length = [_temp length];
    [_temp deleteCharactersInRange:range];
    
    [self performSelectorOnMainThread:@selector(_didStartElement:)
                           withObject:elementName
                        waitUntilDone:YES];
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qualifiedName
{
    [self performSelectorOnMainThread:@selector(_didEndElement:)
                           withObject:elementName
                        waitUntilDone:YES];
}

- (void) parser:(NSXMLParser*)parser 
 foundAttribute:(NSString*)attributeName
      withValue:(id)value 
     forElement:(NSString *)elementName
{
    [self performSelectorOnMainThread:@selector(_foundAttribute:)
                           withObject:[NSArray arrayWithObjects:attributeName, value, elementName, nil]
                        waitUntilDone:YES];    
}


- (BOOL) isValidString:(NSString*)string {
    if ([string length] == 1 && [string isEqualToString: @"\n"])
        return NO;
    else if ([string length] > 1 && [[string substringToIndex: 2] isEqualToString: @"\n "])
        return NO;
    
    return YES;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (![self isValidString:string])
        return;
    
    [self.temp appendString:string];
}


- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{}


#pragma mark -
#pragma mark Private Methods
- (void) _foundAttribute:(NSArray*)array {
    if ([self.delegate respondsToSelector:@selector(parser:foundAttribute:withValue:forElement:)])
        [self.delegate parser:self
               foundAttribute:[array objectAtIndex:0]
                    withValue:[array objectAtIndex:1]
                   forElement:[array objectAtIndex:2]];
}

- (void) _didStartDocument {
    if ([self.delegate respondsToSelector:@selector(parserDidStartDocument:)]) {
        [self.delegate parserDidStartDocument:self];
    }    
}

- (void) _didEndDocument {
    if ([self.delegate respondsToSelector:@selector(parserDidEndDocument:)]) {
        [self.delegate parserDidEndDocument:self];
    }    
}

- (void) _didStartElement:(NSString*)element {
    if ([self.delegate respondsToSelector:@selector(parser:didStartElement:)]) {
        [self.delegate parser:self didStartElement:element];
    }
}

- (void) _didEndElement:(NSString*)element {
    if ([self.delegate respondsToSelector:@selector(parser:didEndElement:)]) {
        [self.delegate parser:self didEndElement:element];
    }
}


#pragma mark -
#pragma mark Memory Management
- (void) dealloc {
    [_parser release];               _parser = nil;    
    [_temp release];                 _temp = nil;
    [_managedObjectContext release]; _managedObjectContext = nil;
    
    [super dealloc];
}

@end