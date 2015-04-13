//
//  SupermarketAPI.h
//  SharpShopper
//
//  Created by Patrick Sheehan on 3/24/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SupermarketAPI : NSObject

/*******************************/
/** Supermarket API Reference **/
/*******************************/
/* http://www.supermarketapi.com/Methods_v1.aspx */
/*******************************/

//#define CONTENT_TYPE    @"application/json;charset=UTF-8"
#define CONTENT_TYPE    @"application/x-www-form-urlencoded"
#define SUPERMARKET_API_URL @"http://www.SupermarketAPI.com/api.asmx"

+ (NSString *)GET:(NSURL *)url;
+ (NSString *)getGroceries:(NSString *)searchText;


@end
