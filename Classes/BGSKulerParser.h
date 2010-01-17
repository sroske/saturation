//
//  BGSKulerParser.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSKulerParser : NSObject 
{
	BOOL success;
	NSURL *url;
	NSXMLParser *xml;
	NSString *element;
	NSMutableArray *entries;
	NSMutableDictionary *entry;
	NSMutableDictionary *swatch;
}

@property (nonatomic, assign) BOOL success;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSXMLParser *xml;
@property (nonatomic, copy) NSString *element;
@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) NSMutableDictionary *entry;
@property (nonatomic, retain) NSMutableDictionary *swatch;

- (id)initWithURL:(NSURL *)u;
- (void)fetch;
- (BOOL)parse;

@end
