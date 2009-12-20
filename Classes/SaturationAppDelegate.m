//
//  SaturationAppDelegate.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import "SaturationAppDelegate.h"

@interface SaturationAppDelegate (Private)

- (NSDictionary *)randomEntry;

@end


@implementation SaturationAppDelegate

@synthesize path;
@synthesize entries;
@synthesize window;
@synthesize navController;
@synthesize welcomeController;

#define FEED_URL @"http://kuler-api.adobe.com/feeds/rss/get.cfm?timeSpan=30&listType=rating"

- (NSString *)path
{
	if (path == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsPath = [paths objectAtIndex:0];
		NSString *p = [documentsPath stringByAppendingPathComponent:@"entries.plist"];
		[self setPath:p];
	}
	return path;
}

- (NSArray *)entries
{
	if (entries == nil)
	{
		NSArray *saved = [[NSArray alloc] initWithContentsOfFile:self.path];
		if (saved != nil)
			[self setEntries:saved];
		else 
			[self fetchNewEntries];
		[saved release];
	}
	return entries;
}

- (UIWindow *)window
{
	if (window == nil)
	{
		UIWindow *w = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[self setWindow:w];
		[w release];
	}
	return window;
}

- (UINavigationController *)navController
{
	if (navController == nil)
	{
		UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.welcomeController];
		[self setNavController:nc];
		[nc release];
	}
	return navController;
}

- (BGSWelcomeViewController *)welcomeController
{
	if (welcomeController == nil)
	{
		BGSWelcomeViewController *c = [[BGSWelcomeViewController alloc] init];
		[self setWelcomeController:c];
		[c release];
	}
	return welcomeController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
}

- (void)dealloc 
{
	[path release];
	[entries release];
    [window release];
	[navController release];
	[welcomeController release];
    [super dealloc];
}

- (void)fetchNewEntries
{
	BGSKulerParser *parser = [[BGSKulerParser alloc] init];
	NSArray *e = [parser fetchEntriesFromURL:FEED_URL];
	[self setEntries:e];
	[parser release];
	
	[self.entries writeToFile:self.path atomically:YES];
}

- (NSDictionary *)randomEntry
{
	int i = arc4random()%[self.entries count];
	return [self.entries objectAtIndex:i];
}

- (void)showDetailFor:(NSDictionary *)entryData
{
	// TODO
}

@end
