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

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	controller = [[BGSMainViewController alloc] init];
	[window addSubview:controller.view];
	
    [window makeKeyAndVisible];
}


- (void)dealloc 
{
    [window release];
    [super dealloc];
}


@end
