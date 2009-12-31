//
//  BGSKulerFeedController.h
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGSKulerOperation.h"

#define FEED_API_KEY			@"B90C327DD1FB1BDA94CEC6A1AF6D84D4"
#define FEED_BASE_URL			@"http://kuler-api.adobe.com/feeds/rss/get.cfm?listType=%@&key=%@"

#define FEED_TYPE_POPULAR		@"popular"
#define FEED_TYPE_RANDOM		@"random"
#define FEED_TYPE_NEWEST		@"recent"
#define FEED_TYPE_FAVORITES		@"favorites"

#define FEED_SCOPE_FULL			@"full"
#define FEED_SCOPE_PARTIAL		@"partial"

#define FEED_MAX_OPERATIONS		2

@interface BGSKulerFeedController : NSObject 
{
	NSOperationQueue *queue;
	NSArray *newestEntries;
	NSArray *popularEntries;
	NSArray *randomEntries;
	NSArray *favoriteEntries;
}

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSArray *newestEntries;
@property (nonatomic, retain) NSArray *popularEntries;
@property (nonatomic, retain) NSArray *randomEntries;
@property (nonatomic, retain) NSArray *favoriteEntries;

- (void)refreshNewestEntries;
- (void)refreshPopularEntries;
- (void)refreshRandomEntries;

@end
