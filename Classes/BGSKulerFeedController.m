//
//  BGSKulerFeedController.m
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSKulerFeedController.h"

@interface BGSKulerFeedController (Private)

- (NSURL *)urlForFeedType:(int)feedType atStartIndex:(int)startIndex;
- (NSString *)pathForFeedType:(int)feedType;

-(void)fetchStarted:(NSNotification *)notice;
-(void)fetchCompleted:(NSNotification *)notice;

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

- (id)init
{
	if (self = [super init])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(fetchStarted:) 
													 name:@"kuler.fetch.started" 
												   object:nil];
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

-(void)fetchStarted:(NSNotification *)notice
{
	// pass it along the chain
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.feed.update.started" 
														object:self
													  userInfo:[notice userInfo]];
}

-(void)fetchCompleted:(NSNotification *)notice
{
	NSDictionary *data = [notice userInfo];
	int scope = [[data objectForKey:@"scope"] intValue];
	if (scope == kKulerFeedScopeFull)
	{
		int feedType = [[data objectForKey:@"feedType"] intValue];
		switch (feedType) {
			case kKulerFeedTypeNewest:
				[self setNewestEntries:[data objectForKey:@"entries"]];
				break;
			case kKulerFeedTypePopular:
				[self setPopularEntries:[data objectForKey:@"entries"]];
				break;
			case kKulerFeedTypeRandom:
				[self setRandomEntries:[data objectForKey:@"entries"]];
				break;
		}
	}
	else
	{
		int feedType = [[data objectForKey:@"feedType"] intValue];
		switch (feedType) {
			case kKulerFeedTypeNewest:
				[self setNewestEntries:[self.newestEntries arrayByAddingObjectsFromArray:[data objectForKey:@"entries"]]];
				break;
			case kKulerFeedTypePopular:
				[self setPopularEntries:[self.popularEntries arrayByAddingObjectsFromArray:[data objectForKey:@"entries"]]];
				break;
			case kKulerFeedTypeRandom:
				[self setRandomEntries:[self.randomEntries arrayByAddingObjectsFromArray:[data objectForKey:@"entries"]]];
				break;
		}
	}
	// pass it along the chain
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.feed.update.completed" 
														object:self
													  userInfo:[notice userInfo]];
}

- (NSURL *)urlForFeedType:(int)feedType atStartIndex:(int)startIndex
{
	NSString *typeString = @"";
	switch (feedType) {
		case kKulerFeedTypeNewest:
			typeString = @"recent";
			break;
		case kKulerFeedTypePopular:
			typeString = @"popular";
			break;
		case kKulerFeedTypeRandom:
			typeString = @"random";
			break;
		default:
			typeString = @"recent";
			break;
	}
	return [NSURL URLWithString:[NSString stringWithFormat:FEED_BASE_URL, 
								 typeString, 
								 FEED_PER_PAGE, 
								 startIndex, 
								 FEED_API_KEY, nil]];
}

- (NSString *)pathForFeedType:(int)feedType
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *filename = @"";
	switch (feedType) {
		case kKulerFeedTypeNewest:
			filename = @"newest.plist";
			break;
		case kKulerFeedTypePopular:
			filename = @"popular.plist";
			break;
		case kKulerFeedTypeRandom:
			filename = @"random.plist";
			break;
		case kKulerFeedTypeFavorites:
			filename = @"favorites.plist";
			break;
		default:
			filename = @"default.plist";
			break;
	}
	return [documentsPath stringByAppendingPathComponent:filename];
}

#pragma mark -
#pragma mark Newest

- (NSArray *)newestEntries
{
	if (newestEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypeNewest]];
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
	[newestEntries writeToFile:[self pathForFeedType:kKulerFeedTypeNewest] atomically:YES];
}

- (void)refreshNewestEntries
{	
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForFeedType:kKulerFeedTypeNewest atStartIndex:0] 
															 scope:kKulerFeedScopeFull
													   andFeedType:kKulerFeedTypeNewest];
	[self.queue addOperation:op];
	[op release];
}

- (void)pageNewestEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForFeedType:kKulerFeedTypeNewest atStartIndex:[self.newestEntries count]] 
															 scope:kKulerFeedScopePartial
													   andFeedType:kKulerFeedTypeNewest];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark -
#pragma mark Popular

- (NSArray *)popularEntries
{
	if (popularEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypePopular]];
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
	[popularEntries writeToFile:[self pathForFeedType:kKulerFeedTypePopular] atomically:YES];
}

- (void)refreshPopularEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForFeedType:kKulerFeedTypePopular atStartIndex:0] 
															 scope:kKulerFeedScopeFull
													   andFeedType:kKulerFeedTypePopular];
	[self.queue addOperation:op];
	[op release];
}

- (void)pagePopularEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForFeedType:kKulerFeedTypePopular atStartIndex:[self.popularEntries count]] 
															 scope:kKulerFeedScopePartial
													   andFeedType:kKulerFeedTypePopular];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark -
#pragma mark Random

- (NSArray *)randomEntries
{
	if (randomEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypeRandom]];
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
	[randomEntries writeToFile:[self pathForFeedType:kKulerFeedTypeRandom] atomically:YES];
}

- (void)refreshRandomEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForFeedType:kKulerFeedTypeRandom atStartIndex:0] 
															 scope:kKulerFeedScopeFull
													   andFeedType:kKulerFeedTypeRandom];
	[self.queue addOperation:op];
	[op release];
}

- (void)pageRandomEntries
{
	[self.queue cancelAllOperations];
	BGSKulerOperation *op = [[BGSKulerOperation alloc] initWithURL:[self urlForFeedType:kKulerFeedTypeRandom atStartIndex:[self.randomEntries count]] 
															 scope:kKulerFeedScopePartial
													   andFeedType:kKulerFeedTypeRandom];
	[self.queue addOperation:op];
	[op release];
}

#pragma mark -
#pragma mark Favorite

- (NSArray *)favoriteEntries
{
	if (favoriteEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypeFavorites]];
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
	[favoriteEntries writeToFile:[self pathForFeedType:kKulerFeedTypeFavorites] atomically:YES];
}


@end
