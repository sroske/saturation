//
//  SaturationAppDelegate.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import "SaturationAppDelegate.h"

@interface SaturationAppDelegate (Private)

- (void)runScene:(CCScene *)scene;
- (void)presentMailComposer:(NSDictionary *)entryData;

@end


@implementation SaturationAppDelegate

@synthesize entry;
@synthesize window;
@synthesize mainController;
@synthesize welcomeController;
@synthesize visualizationType;

- (NSDictionary *)entry
{
	if (entry == nil)
	{
		BGSKulerFeedController *feed = [[BGSKulerFeedController alloc] init];
		NSArray *entries = feed.popularEntries;
		if ([entries count] > 0)
		{
			int i = arc4random()%[entries count];
			[self setEntry:[entries objectAtIndex:i]];
		}
		[feed release];
	}
	return entry;
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

- (BGSMainViewController *)mainController
{
	if (mainController == nil)
	{
		BGSMainViewController *c = [[BGSMainViewController alloc] init];
		[self setMainController:c];
		[c release];
	}
	return mainController;
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

- (void)setVisualizationType:(int)newType
{
	visualizationType = newType;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:visualizationType forKey:@"saturation.visualizationType"];
}

+ (void)initialize
{
	NSMutableDictionary *defs = [NSMutableDictionary dictionary];
	[defs setObject:[NSNumber numberWithInt:kSimpleCircle] forKey:@"saturation.visualizationType"];
	[defs setObject:[NSNumber numberWithInt:kKulerFeedTypePopular] forKey:@"saturation.lastOpenedSection"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defs];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.visualizationType = [defaults integerForKey:@"saturation.visualizationType"];
	
	[[FontManager sharedManager] loadFont:CF_NORMAL];
	
	// cocos2d will inherit these values
	[self.window setUserInteractionEnabled:YES];	
	[self.window setMultipleTouchEnabled:YES];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
	//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:self.window];	
	[[[CCDirector sharedDirector] openGLView] addSubview:self.welcomeController.view];

	[self changeEntry:self.entry];
	
	[self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc 
{
	[[CCDirector sharedDirector] release];
	[entry release];
    [window release];
	[mainController release];
	[welcomeController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Modal Views & App Navigation

- (void)showMainView
{
	[self.welcomeController.view removeFromSuperview];
	[[[CCDirector sharedDirector] openGLView] addSubview:self.mainController.view];
}

- (void)changeEntry:(NSDictionary *)entryData
{
	[self setEntry:entryData];
	
	CCScene *scene = nil;
	switch (self.visualizationType) 
	{
		case kSimpleCircle:
			scene = [BGSSimpleCircleScene node];
			break;
		case kSimpleSquare:
			scene = [BGSSimpleSquareScene node];
			break;
			// .... TODO
	}
	
	if ([[CCDirector sharedDirector] runningScene] == nil)
		[self performSelector:@selector(runScene:) withObject:scene afterDelay:1.0f];
	else
		[[CCDirector sharedDirector] replaceScene:scene];
	
	[self hideModalView];
}

- (void)runScene:(CCScene *)scene
{
	[[CCDirector sharedDirector] runWithScene:scene];
}

- (void)showListView
{
	[[CCDirector sharedDirector] pause];
	
	BGSListViewController *controller = [[BGSListViewController alloc] init];
	[self.mainController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)showDetailView
{
	[[CCDirector sharedDirector] pause];
	
	BGSDetailViewController *controller = [[BGSDetailViewController alloc] initWithEntry:self.entry];
	[self.mainController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)hideModalView
{
	[[CCDirector sharedDirector] resume];
	
	[self.mainController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Mail Composer

- (void)emailView
{
	[self hideModalView];
	[self performSelector:@selector(presentMailComposer:) withObject:self.entry afterDelay:0.8];
}

- (void)presentMailComposer:(NSDictionary *)entryData
{
	BGSMailController *controller = [[BGSMailController alloc] initWithEntry:entryData];
	[[controller mailer] setMailComposeDelegate:self];
	[self.mainController presentModalViewController:[controller mailer] animated:YES];
	[controller release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if (result == MFMailComposeResultFailed)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[self hideModalView];
}

@end
