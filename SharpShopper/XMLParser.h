//
//  XMLParser.h
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/13/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject<NSXMLParserDelegate>

- (NSMutableArray *)xmlParse;

@end
