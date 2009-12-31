//
//  BGSKulerFeedController.m
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSKulerFeedController.h"

@interface BGSKulerFeedController (Private)

- (NSURL *)urlForType:(NSString *)type;
- (NSString *)pathForFile:(NSString *)filename;

@end


@implementation BGSKulerFeedController

@synthesize queue;
@synthesize newestEntries;
@synthesize popularEntries;
@synthesize randomEntries;
@synthesize favoriteEntries;

- (NSOperationQueue *)queue
{
	if (queue == nil)
	{
		NSOperationQueue *q = [[NSOperationQueue alloc] init];
		[q setMaxConcurrentOperationCount:FEED_MAX_OPERATIONS];
		[self setQueue:q];
		[q release];
	}
	return queue;
}

- (NSArray *)newestEntries
{
	if (newestEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_NEWEST]]];
		if (saved != nil)
			[self setNewestEntries:saved];
		else
			[self refreshNewestEntries];
		[saved release];
	}
	return newestEntries;
}
- (void)setNewestEntries:(NSArray *)newNewestEntries
{
	if (newestEntries != newNewestEntries)
	{
		[newestEntries release];
		newestEntries = [newNewestEntries retain];
	}
	[newestEntries writeToFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_NEWEST]] atomically:YES];
}
- (void)refreshNewestEntries
{	
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForType:FEED_TYPE_NEWEST] 
															 scope:FEED_SCOPE_FULL
													   andFeedType:FEED_TYPE_NEWEST];
	[self.queue addOperation:op];
	[op release];
}

- (NSArray *)popularEntries
{
	if (popularEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_POPULAR]]];
		if (saved != nil)
		{
			[self setPopularEntries:saved];
		}
		else
		{
			[self refreshPopularEntries];
		}	
		[saved release];
	}
	return popularEntries;
}
- (void)setPopularEntries:(NSArray *)newPopularEntries
{
	if (popularEntries != newPopularEntries)
	{
		[popularEntries release];
		popularEntries = [newPopularEntries retain];
	}
	[popularEntries writeToFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_POPULAR]] atomically:YES];
}
- (void)refreshPopularEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForType:FEED_TYPE_POPULAR] 
															 scope:FEED_SCOPE_FULL
													   andFeedType:FEED_TYPE_POPULAR];
	[self.queue addOperation:op];
	[op release];
}

- (NSArray *)randomEntries
{
	if (randomEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_RANDOM]]];
		if (saved != nil)
		{
			[self setRandomEntries:saved];
		}
		else
		{
			[self refreshRandomEntries];
		}	
		[saved release];
	}
	return randomEntries;
}
- (void)setRandomEntries:(NSArray *)newRandomEntries
{
	if (randomEntries != newRandomEntries)
	{
		[randomEntries release];
		randomEntries = [newRandomEntries retain];
	}
	[randomEntries writeToFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_RANDOM]] atomically:YES];
}
- (void)refreshRandomEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForType:FEED_TYPE_RANDOM] 
															 scope:FEED_SCOPE_FULL
													   andFeedType:FEED_TYPE_RANDOM];
	[self.queue addOperation:op];
	[op release];
}

- (NSArray *)favoriteEntries
{
	if (favoriteEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_FAVORITES]]];
		[self setFavoriteEntries:saved];
		[saved release];
	}
	return favoriteEntries;
}
- (void)setFavoriteEntries:(NSArray *)newFavoriteEntries
{
	if (favoriteEntries != newFavoriteEntries)
	{
		[favoriteEntries release];
		favoriteEntries = [newFavoriteEntries retain];
	}
	[favoriteEntries writeToFile:[self pathForFile:[NSString stringWithFormat:@"%@.plist", FEED_TYPE_FAVORITES]] atomically:YES];
}

-(void)fetchCompleted:(NSNotification *)notice
{
	NSDictionary *data = [notice userInfo];
	if ([[data objectForKey:@"scope"] isEqualToString:FEED_SCOPE_FULL])
	{
		if ([[data objectForKey:@"feedType"] isEqualToString:FEED_TYPE_NEWEST])
		{
			[self setNewestEntries:[data objectForKey:@"entries"]];
		}
		else if ([[data objectForKey:@"feedType"] isEqualToString:FEED_TYPE_POPULAR])
		{
			[self setPopularEntries:[data objectForKey:@"entries"]];
		}
		else if ([[data objectForKey:@"feedType"] isEqualToString:FEED_TYPE_RANDOM])
		{
			[self setRandomEntries:[data objectForKey:@"entries"]];
		}
	}
}

- (id)init
{
	if (self = [super init])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(fetchCompleted:) 
													 name:@"kuler.fetch.completed" 
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[queue cancelAllOperations];
	[queue release];
	[newestEntries release];
	[popularEntries release];
	[randomEntries release];
	[favoriteEntries release];
	[super dealloc];
}

- (NSURL *)urlForType:(NSString *)type
{
	return [NSURL URLWithString:[NSString stringWithFormat:FEED_BASE_URL, type, FEED_API_KEY, nil]];
}

- (NSString *)pathForFile:(NSString *)filename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:filename];
}

@end
