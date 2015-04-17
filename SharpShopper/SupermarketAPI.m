//
//  SupermarketAPI.m
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/24/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import "SupermarketAPI.h"
#import "SharpShopper-Swift.h"

@interface SupermarketAPI() {
    
    NSManagedObjectContext *managedObjectContext;
    
    NSXMLParser *parser;
    NSMutableArray *groceries;
    
    NSString *element;

    /* Below from SupermarketAPI fields */
    NSMutableDictionary *product;
    
    NSMutableString *itemName;
    NSMutableString *itemDescription;
    NSMutableString *itemCategory;
    NSMutableString *itemImage;
    NSMutableString *itemID;
}

@end

@implementation SupermarketAPI


- (id)init{
    self = [super init];
    if (self) {
        
        managedObjectContext = ((AppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    }
    
    return self;
}

- (NSMutableArray *)searchByProductName:(NSString *)name {
    
    NSString *API_KEY = [SupermarketAPI getAPIKey];
    
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/SearchByProductName?APIKEY=%@&ItemName=%@",
                   SUPERMARKET_API_URL, API_KEY, name]];
    
    return [self parseToGroceryArrayFromURL:url];
}

- (NSMutableArray *)parseToGroceryArrayFromURL:(NSURL *)url {
    
    groceries = [[NSMutableArray alloc] init];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    return groceries;
}

+ (NSData *)GET:(NSURL *)url
{   // Gets the data from the provided URL
    
    NSLog(@"Fetching from URL: %@", url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if ([responseCode statusCode] != 200) {
        
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return nil;
    }
    
    return responseData;
}

+ (NSURL *)getGroceryURL:(NSString *)searchText
{
    NSString *API_KEY = [self getAPIKey];
    
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/GetGroceries?APIKEY=%@&SearchText=%@",
                   SUPERMARKET_API_URL, API_KEY, searchText]];
    
    return url;
    //    return [self GET:url];
    
    //http://www.SupermarketAPI.com/api.asmx/GetGroceries?APIKEY=APIKEY&SearchText=Apple
    
}

+ (NSString *)getAPIKey
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"]];
    return [dictionary objectForKey:@"SUPERMARKET_API_KEY"];
    
}

#pragma mark - NSXMLParserDelegate Methods


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"ArrayOfString"]) {
        NSLog(@"started parsing string array");
    }
    
    if ([element isEqualToString:@"Product"]) {
        
        product = [NSMutableDictionary new];
        
        itemName = [NSMutableString new];
        itemDescription = [NSMutableString new];
        itemCategory = [NSMutableString new];
        itemImage = [NSMutableString new];
        itemID = [NSMutableString new];
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
    
    if ([element isEqualToString:@"ItemName"]) {
        [itemName appendString:string];
    }
    if ([element isEqualToString:@"ItemDescription"]) {
        [itemDescription appendString:string];
    }
    if ([element isEqualToString:@"ItemCategory"]) {
        [itemCategory appendString:string];
    }
    if ([element isEqualToString:@"ItemImage"]) {
        [itemImage appendString:string];
    }
    if ([element isEqualToString:@"ItemID"]) {
        [itemID appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"ArrayOfString"]) {
        NSLog(@"finished parsing string array");
    }
    
    if ([elementName isEqualToString:@"Product"]) {
        
        // TODO: make this grocery only a temporary copy; with the use of separate Core Data context
        
        // FOR NOW: make it and save like a normal one
//        Ivar grocery = (__bridge Ivar)([Grocery createInManagedObjectContext:managedObjectContext itemID:itemID itemName:itemName itemDescription:itemDescription itemCategory:itemCategory itemImageURL:itemImage purchased:NO price:0]);
        
        NSDictionary *groceryProperties = [[NSMutableDictionary alloc] init];
        
        [groceryProperties setValue:itemName forKey:@"itemName"];
        [groceryProperties setValue:itemDescription forKey:@"itemDescription"];
        [groceryProperties setValue:itemCategory forKey:@"itemCategory"];
        [groceryProperties setValue:itemID forKey:@"itemID"];
        [groceryProperties setValue:itemImage forKey:@"itemImage"];
        
        GroceryParser 
        
        // ****************** //
        // **** BOOKMARK **** //
        // ****************** //
        
        // Parse this network data into a managed object
        Grocery *grocery = [Grocery new];
        grocery.itemName = itemName;
        grocery.itemDescription = itemDescription;
        grocery.itemCategory = itemCategory;
        grocery.itemID = itemID;
        grocery.itemImageURL = itemImage;
        
        [groceries addObject:(grocery)];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parsing is ended");
}

@end
