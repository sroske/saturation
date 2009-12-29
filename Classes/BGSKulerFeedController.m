//
//  BGSKulerFeedController.m
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSKulerFeedController.h"

@interface BGSKulerFeedController (Private)

- (NSString *)urlForType:(NSString *)type;
- (NSString *)pathForFile:(NSString *)filename;

@end


@implementation BGSKulerFeedController

@synthesize parser;
@synthesize newestEntries;
@synthesize popularEntries;
@synthesize randomEntries;
@synthesize favoriteEntries;

- (BGSKulerParser *)parser
{
	if (parser == nil)
	{
		BGSKulerParser *p = [[BGSKulerParser alloc] init];
		[self setParser:p];
		[p release];
	}
	return parser;
}

- (NSArray *)newestEntries
{
	if (newestEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:@"newest.plist"]];
		if (saved != nil)
		{
			[self setNewestEntries:saved];
		}
		else
		{
			NSString *url = [self urlForType:FEED_TYPE_NEWEST];
			NSLog(@"newest not found, fetching from '%@'", url);
			[self setNewestEntries:[self.parser fetchEntriesFromURL:url]];
		}	
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
	[newestEntries writeToFile:[self pathForFile:@"newest.plist"] atomically:YES];
}

- (NSArray *)popularEntries
{
	if (popularEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:@"popular.plist"]];
		if (saved != nil)
		{
			[self setPopularEntries:saved];
		}
		else
		{
			NSString *url = [self urlForType:FEED_TYPE_POPULAR];
			NSLog(@"popular not found, fetching '%@'", url);
			[self setPopularEntries:[self.parser fetchEntriesFromURL:url]];
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
	[popularEntries writeToFile:[self pathForFile:@"popular.plist"] atomically:YES];
}

- (NSArray *)randomEntries
{
	if (randomEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:@"random.plist"]];
		if (saved != nil)
		{
			[self setRandomEntries:saved];
		}
		else
		{
			NSString *url = [self urlForType:FEED_TYPE_RANDOM];
			NSLog(@"random not found, fetching '%@'", url);
			[self setRandomEntries:[self.parser fetchEntriesFromURL:url]];
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
	[randomEntries writeToFile:[self pathForFile:@"random.plist"] atomically:YES];
}

- (NSArray *)favoriteEntries
{
	if (favoriteEntries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:[self pathForFile:@"favorites.plist"]];
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
	[favoriteEntries writeToFile:[self pathForFile:@"favorites.plist"] atomically:YES];
}

- (id)init
{
	if (self = [super init])
	{
		// nothing
	}
	return self;
}

- (void)dealloc
{
	[parser release];
	[newestEntries release];
	[popularEntries release];
	[randomEntries release];
	[favoriteEntries release];
	[super dealloc];
}

- (NSString *)urlForType:(NSString *)type
{
	return [NSString stringWithFormat:FEED_BASE_URL, type, FEED_API_KEY, nil];
}

- (NSString *)pathForFile:(NSString *)filename
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsPath = [paths objectAtIndex:0];
	return [documentsPath stringByAppendingPathComponent:filename];
}

@end
