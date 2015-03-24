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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    
    // Fetch the response from the server in JSON format
    NSHTTPURLResponse   *response;
    NSError     *error;
    NSData      *GETReply = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response
                                                              error:&error];
    NSString    *stringReply = [[NSString alloc] initWithBytes:[GETReply bytes]
                                                        length:[GETReply length]
                                                      encoding:NSASCIIStringEncoding];
    if ([response statusCode] == 200)
    {
        return GETReply;
    }
    NSLog(@"URL: %@", url);
    NSLog(@"%@", stringReply);
    return nil;
}

+ (NSData *)getGroceries:(NSString *)searchText
{
    NSString *API_KEY = [self getAPIKey];
    
    NSURL *url = [[NSURL alloc] initWithString:
                  [NSString stringWithFormat:@"%@/GetGroceries?APIKEY=%@&SearchText=%@",
                   SUPERMARKET_API_URL, API_KEY, searchText]];
    
    return [self GET:url];
    
    
//http://www.SupermarketAPI.com/api.asmx/GetGroceries?APIKEY=APIKEY&SearchText=Apple

}

+ (NSString *)getAPIKey
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"]];
    return [dictionary objectForKey:@"SUPERMARKET_API_KEY"];

}

@end
