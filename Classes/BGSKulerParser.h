//
//  BGSKulerParser.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegexKitLite.h"

@interface BGSKulerParser : NSObject 
{
	NSXMLParser *rssParser;
	NSMutableArray *stories;
	NSMutableDictionary *item;
	NSMutableString *currentElement;
	NSMutableString *currentTitle;
	NSMutableString *currentDate;
	NSMutableString *currentSummary;
	NSMutableString *currentLink;
}

@end
