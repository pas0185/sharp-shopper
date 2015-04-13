//
//  SupermarketAPI.h
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/24/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SupermarketAPI : NSObject<NSXMLParserDelegate>

/*************************************************/
/********** Supermarket API Reference ************/
/*************************************************/
/* http://www.supermarketapi.com/Methods_v1.aspx */
/*************************************************/

#define SUPERMARKET_API_URL @"http://www.SupermarketAPI.com/api.asmx"


- (NSMutableArray *)searchByProductName:(NSString *)name;

- (NSMutableArray *)parseToGroceryArrayFromURL:(NSURL *)url;

+ (NSData *)GET:(NSURL *)url;
+ (NSURL *)getGroceryURL:(NSString *)searchText;


@end
