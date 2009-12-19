//
//  BGSKulerParser.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGSKulerParser : NSObject 
{
	NSXMLParser *xml;
	NSString *currentElement;
	
	NSMutableArray *entries;
	NSMutableDictionary *entry;
	
	NSMutableDictionary *swatch;
}

@property (nonatomic, retain) NSXMLParser *xml;
@property (nonatomic, copy) NSString *currentElement;

@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) NSMutableDictionary *entry;

@property (nonatomic, retain) NSMutableDictionary *swatch;


- (NSArray *)fetchEntriesFromURL:(NSString *)url;

@end
