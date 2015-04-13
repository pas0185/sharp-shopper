//
//  SupermarketAPIXMLParser.m
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/13/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import "SupermarketAPIXMLParser.h"

@interface SupermarketAPIXMLParser() {

    NSXMLParser *parser;
    NSMutableArray *groceries;
    
    NSString *element;

}
@end

@implementation SupermarketAPIXMLParser

- (NSMutableArray *)parseToGroceryArrayFromURL:(NSURL *)url {
    
    groceries = [[NSMutableArray alloc] init];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    return groceries;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"ArrayOfString"]) {
        NSLog(@"started parsing string array");
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"string"]) {
        
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimmedString.length > 0) {
            NSLog(@"Adding grocery string: %@", trimmedString);
            [groceries addObject:trimmedString];
        }
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"ArrayOfString"]) {
        NSLog(@"finished parsing string array");
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parsing is ended");
}

@end
