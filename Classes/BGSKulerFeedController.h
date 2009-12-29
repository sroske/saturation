//
//  BGSKulerFeedController.h
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSKulerParser.h"

#define FEED_API_KEY		@"B90C327DD1FB1BDA94CEC6A1AF6D84D4"
#define FEED_BASE_URL		@"http://kuler-api.adobe.com/feeds/rss/get.cfm?listType=%@&key=%@"
#define FEED_TYPE_POPULAR	@"popular"
#define FEED_TYPE_RANDOM	@"random"
#define FEED_TYPE_NEWEST	@"recent"

@interface BGSKulerFeedController : NSObject 
{
	BGSKulerParser *parser;
	NSArray *newestEntries;
	NSArray *popularEntries;
	NSArray *randomEntries;
	NSArray *favoriteEntries;
}

@property (nonatomic, retain) BGSKulerParser *parser;
@property (nonatomic, retain) NSArray *newestEntries;
@property (nonatomic, retain) NSArray *popularEntries;
@property (nonatomic, retain) NSArray *randomEntries;
@property (nonatomic, retain) NSArray *favoriteEntries;

@end
