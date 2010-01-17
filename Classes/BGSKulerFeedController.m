//
//  BGSKulerFeedController.m
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSKulerFeedController.h"

@interface BGSKulerFeedController (Private)

- (BOOL)copyDefaultFeedForType:(int)feedType;
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
@synthesize favoriteLookup;

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
	[favoriteLookup release];
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
	if ([[data objectForKey:@"entries"] count] > 0)
	{
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
	}

	// pass it along the chain
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.feed.update.completed" 
														object:self
													  userInfo:[notice userInfo]];
}

- (BOOL)copyDefaultFeedForType:(int)feedType
{
	BOOL success;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	
	NSString *destPath = [self pathForFeedType:feedType];
	success = [fm fileExistsAtPath:destPath];
	if (success) return YES;
	
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
		default:
			filename = @"default.plist";
			break;
	}
	
	NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
	NSLog(@"copying default feed from %@ to %@", p, destPath);
	success = [fm copyItemAtPath:p toPath:destPath error:&error];
	if (!success)
		NSAssert1(0, @"Failed to create a writeable copy of a feed: %@", [error localizedDescription]);
	
	return YES;
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
		if (saved == nil && [self copyDefaultFeedForType:kKulerFeedTypeNewest])
			saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypeNewest]];
		[self setNewestEntries:saved];
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
		if (saved == nil && [self copyDefaultFeedForType:kKulerFeedTypePopular])
			saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypePopular]];
		[self setPopularEntries:saved];
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
		if (saved == nil && [self copyDefaultFeedForType:kKulerFeedTypeRandom])
			saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypeRandom]];
		[self setRandomEntries:saved];
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

- (NSMutableArray *)favoriteLookup
{
	if (favoriteLookup == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setFavoriteLookup:a];
		[a release];
	}
	return favoriteLookup;
}

- (NSArray *)favoriteEntries
{
	if (favoriteEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFeedType:kKulerFeedTypeFavorites]];
		if (saved == nil)
			saved = [[NSArray alloc] init];
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
	
	self.favoriteLookup = nil;
	for (NSDictionary *entry in favoriteEntries)
		[self.favoriteLookup addObject:[entry objectForKey:@"themeID"]];
	
	[favoriteEntries writeToFile:[self pathForFeedType:kKulerFeedTypeFavorites] atomically:YES];
}

- (void)addToFavorites:(NSDictionary *)entry
{
	if ([self isFavorite:entry]) return;
	
	[self setFavoriteEntries:[self.favoriteEntries arrayByAddingObject:entry]];
}

- (void)removeFromFavorites:(NSDictionary *)entry
{
	NSMutableArray *a = [self.favoriteEntries mutableCopy];
	[a removeObject:entry];
	[self setFavoriteEntries:a];
}

- (BOOL)isFavorite:(NSDictionary *)entry
{
	BOOL found = NO;
	for (NSDictionary *favoriteEntry in self.favoriteEntries)
	{
		if ([[favoriteEntry objectForKey:@"themeID"] isEqualToString:[entry objectForKey:@"themeID"]])
			found = YES;
	}
	return found;
}


@end
