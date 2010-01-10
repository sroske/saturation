//
//  SaturationAppDelegate.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import "SaturationAppDelegate.h"

@implementation SaturationAppDelegate

@synthesize window;
@synthesize navController;
@synthesize welcomeController;
@synthesize currentVisualization;

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
		UINavigationController *c = [[UINavigationController alloc] initWithRootViewController:self.welcomeController];
		[self setNavController:c];
		[c release];
	}
	return navController;
}

- (BGSWelcomeViewController *)welcomeController
{
	if (welcomeController == nil)
	{
		BGSKulerFeedController *feed = [[BGSKulerFeedController alloc] init];
		NSArray *entries = feed.popularEntries;
		NSDictionary *entry = [NSDictionary dictionary];
		if ([entries count] > 0)
		{
			int i = arc4random()%[entries count];
			entry = [entries objectAtIndex:i];
		}
		BGSWelcomeViewController *c = [[BGSWelcomeViewController alloc] initWithEntry:entry];
		[self setWelcomeController:c];
		[c release];
		[feed release];
	}
	return welcomeController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	self.currentVisualization = kQuadCircle;
	[self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
}

- (void)dealloc 
{
    [window release];
	[navController release];
	[welcomeController release];
    [super dealloc];
}

- (void)showListView
{
	BGSListViewController *controller = [[BGSListViewController alloc] init];
	[self.navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self.navController presentModalViewController:controller animated:YES];
	[controller release];	
}

- (void)showDetailFor:(NSDictionary *)entryData
{
	BGSDetailViewController *controller = [[BGSDetailViewController alloc] initWithEntry:entryData];
	[self.navController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self.navController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)changeEntry:(NSDictionary *)entryData
{
	BGSMainViewController *c = (BGSMainViewController *)[self.navController topViewController];
	[c switchToVisualization:self.currentVisualization withEntry:entryData];
	[self hideModalView];
}

- (void)hideModalView
{
	[self.navController dismissModalViewControllerAnimated:YES];
}

@end
