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

@end


@implementation SaturationAppDelegate

@synthesize entry;
@synthesize window;
@synthesize listController;
@synthesize detailController;
@synthesize mainController;
@synthesize welcomeController;
@synthesize mailController;
@synthesize visualizationType;
@synthesize controllerState;

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

- (BGSListViewController *)listController
{
	if (listController == nil)
	{
		BGSListViewController *c = [[BGSListViewController alloc] init];
		[c.view setTag:kListViewController];
		[self setListController:c];
		[c release];
	}
	return listController;
}

- (BGSDetailViewController *)detailController
{
	if (detailController == nil)
	{
		BGSDetailViewController *c = [[BGSDetailViewController alloc] initWithEntry:self.entry];
		[c.view setTag:kDetailViewController];
		[self setDetailController:c];
		[c release];
	}
	return detailController;
}

- (BGSMailViewController *)mailController
{
	if (mailController == nil)
	{
		BGSMailViewController *c = [[BGSMailViewController alloc] initWithEntry:self.entry];
		[self setMailController:c];
		[c release];
	}
	return mailController;
}

- (BGSMainViewController *)mainController
{
	if (mainController == nil)
	{
		BGSMainViewController *c = [[BGSMainViewController alloc] init];
		[c.view setTag:kMainViewController];
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
	
	self.controllerState = kMainViewController;
	
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
	//[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:self.window];	
	[[[CCDirector sharedDirector] openGLView] addSubview:self.welcomeController.view];

	[self changeEntry:self.entry];
	
	[self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application 
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc 
{
	[[CCDirector sharedDirector] release];
	[entry release];
    [window release];
	[listController release];
	[detailController release];
	[mainController release];
	[welcomeController release];
	[mailController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Main View

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
		case kSimpleParticles:
			scene = [BGSSimpleParticlesScene node];
			break;
		default:
			scene = [BGSSimpleCircleScene node];
			break;
	}
	
	if ([[CCDirector sharedDirector] runningScene] == nil)
		[self performSelector:@selector(runScene:) withObject:scene afterDelay:1.0f];
	else
		[[CCDirector sharedDirector] replaceScene:scene];
	
	if (self.controllerState == kListViewController)
		[self performSelector:@selector(closeListView) withObject:nil afterDelay:0.2];
	else
		[self performSelector:@selector(closeDetailView) withObject:nil afterDelay:0.2];
}

- (void)runScene:(CCScene *)scene
{
	[[CCDirector sharedDirector] runWithScene:scene];
}

#pragma mark -
#pragma mark List View

- (void)showListView
{
	self.controllerState = kListViewController;
	
	[[CCDirector sharedDirector] pause];
	
	[self.window addSubview:self.listController.view];

	CGRect listFrame = CGRectMake(self.listController.view.frame.origin.x, 
								  0.0f, 
								  self.listController.view.frame.size.width, 
								  self.listController.view.frame.size.height);
	[self.listController.view setFrame:CGRectMake(listFrame.origin.x, 
												  -listFrame.size.height, 
												  listFrame.size.width, 
												  listFrame.size.height)];
	
	CGRect oglFrame = [[[CCDirector sharedDirector] openGLView] frame];
	CGRect oglDest = CGRectMake(oglFrame.origin.x, 
								oglFrame.size.height, 
								oglFrame.size.width, 
								oglFrame.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];

	[self.listController.view setFrame:listFrame];
	[[[CCDirector sharedDirector] openGLView] setFrame:oglDest];

	[UIView commitAnimations];
}

- (void)closeListView
{	
	CGRect listFrame = self.listController.view.frame;
	CGRect listDest = CGRectMake(listFrame.origin.x, 
								 -listFrame.size.height, 
								 listFrame.size.width, 
								 listFrame.size.height);
	
	CGRect oglFrame = [[[CCDirector sharedDirector] openGLView] frame];
	CGRect oglDest = CGRectMake(oglFrame.origin.x, 
								0.0f, 
								oglFrame.size.width, 
								oglFrame.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(listClosed:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	
	[self.listController.view setFrame:listDest];
	[[[CCDirector sharedDirector] openGLView] setFrame:oglDest];
	
	[UIView commitAnimations];
}

- (void)listClosed:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	self.controllerState = kMainViewController;
	
	[[CCDirector sharedDirector] resume];
	
	[self.listController.view removeFromSuperview];
}

#pragma mark -
#pragma mark Detail View

- (void)showDetailView
{
	self.detailController = nil;
	self.controllerState = kDetailViewController;
	
	[[CCDirector sharedDirector] pause];
	
	[self.window addSubview:self.detailController.view];
	
	CGRect detailFrame = CGRectMake(self.detailController.view.frame.origin.x, 
									0.0f, 
									self.detailController.view.frame.size.width, 
									self.detailController.view.frame.size.height);
	[self.detailController.view setFrame:CGRectMake(detailFrame.origin.x, 
													detailFrame.size.height, 
													detailFrame.size.width, 
													detailFrame.size.height)];
	
	CGRect oglFrame = [[[CCDirector sharedDirector] openGLView] frame];
	CGRect oglDest = CGRectMake(oglFrame.origin.x, 
								-oglFrame.size.height, 
								oglFrame.size.width, 
								oglFrame.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	
	[self.detailController.view setFrame:detailFrame];
	[[[CCDirector sharedDirector] openGLView] setFrame:oglDest];
	
	[UIView commitAnimations];
}

- (void)closeDetailView
{
	CGRect detailFrame = self.detailController.view.frame;
	CGRect detailDest = CGRectMake(detailFrame.origin.x, 
								   detailFrame.size.height, 
								   detailFrame.size.width, 
								   detailFrame.size.height);
	
	CGRect oglFrame = [[[CCDirector sharedDirector] openGLView] frame];
	CGRect oglDest = CGRectMake(oglFrame.origin.x, 
								0.0f, 
								oglFrame.size.width, 
								oglFrame.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(detailClosed:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	
	[self.detailController.view setFrame:detailDest];
	[[[CCDirector sharedDirector] openGLView] setFrame:oglDest];
	
	[UIView commitAnimations];
}

- (void)detailClosed:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	self.controllerState = kMainViewController;
	
	[[CCDirector sharedDirector] resume];
	
	[self.detailController.view removeFromSuperview];
}

#pragma mark -
#pragma mark Email View

- (void)showEmailView
{
	self.mailController = nil;
	
	if (![self.mailController canSendMail]) return;
	
	[self.window addSubview:self.mailController.view];
	
	CGRect mailFrame = CGRectMake(self.mailController.view.frame.origin.x, 
								  0.0f, 
								  self.mailController.view.frame.size.width, 
								  self.mailController.view.frame.size.height);
	[self.mailController.view setFrame:CGRectMake(mailFrame.origin.x, 
												  mailFrame.size.height, 
												  mailFrame.size.width, 
												  mailFrame.size.height)];
	
	CGRect detailFrame = self.detailController.view.frame;
	CGRect detailDest = CGRectMake(detailFrame.origin.x, 
								   -detailFrame.size.height, 
								   detailFrame.size.width, 
								   detailFrame.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	
	[self.mailController.view setFrame:mailFrame];
	[self.detailController.view setFrame:detailDest];
	
	[UIView commitAnimations];
}

- (void)closeEmailView
{
	CGRect mailFrame = self.mailController.view.frame;
	CGRect mailDest = CGRectMake(mailFrame.origin.x, 
								 mailFrame.size.height, 
								 mailFrame.size.width, 
								 mailFrame.size.height);
	
	CGRect detailFrame = self.detailController.view.frame;
	CGRect detailDest = CGRectMake(detailFrame.origin.x, 
								   0.0f, 
								   detailFrame.size.width, 
								   detailFrame.size.height);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(mailClosed:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.5];
	
	[self.mailController.view setFrame:mailDest];
	[self.detailController.view setFrame:detailDest];
	
	[UIView commitAnimations];
}

- (void)mailClosed:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{	
	[self.mailController.view removeFromSuperview];
}

@end
