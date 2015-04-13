//
//  XMLParser.m
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/13/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import "XMLParser.h"

NSString* const urlToParse = @"http://www.forbes.com/entrepreneurs/feed/";

@interface XMLParser () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *author;
    NSMutableString *desc;
    NSString *element;
}
@end

@implementation XMLParser

- (NSMutableArray *)xmlParse {
    
    feeds = [[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlToParse]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];

    return feeds;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc]init];
        title = [[NSMutableString alloc]init];
        author = [[NSMutableString alloc]init];
        desc = [[NSMutableString alloc]init];
        link = [[NSMutableString alloc]init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    }
    if ([element isEqualToString:@"dc:creator"]) {
        [author appendString:string];
    }
    if ([element isEqualToString:@"description"]) {
        [desc appendString:string];
    }
    if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:author forKey:@"author"];
        [item setObject:desc forKey:@"desc"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parsing is ended");
}

@end
