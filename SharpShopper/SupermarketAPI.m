//
//  SupermarketAPI.m
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/24/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import "SupermarketAPI.h"

@implementation SupermarketAPI

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

@end
