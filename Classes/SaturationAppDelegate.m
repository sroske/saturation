//
//  SaturationAppDelegate.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import "SaturationAppDelegate.h"

@interface SaturationAppDelegate (Private)

- (NSString *)bodyHTMLFor:(NSDictionary *)entryData;

@end


@implementation SaturationAppDelegate

@synthesize window;
@synthesize navController;
@synthesize welcomeController;
@synthesize visualizationType;
@synthesize bodyHTMLTemplate;
@synthesize swatchHTMLTemplate;

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

- (NSString *)bodyHTMLTemplate
{
	if (bodyHTMLTemplate == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"email.html"];
		NSString *t = [[NSString alloc] initWithContentsOfFile:p];
		[self setBodyHTMLTemplate:t];
		[t release];
	}
	return bodyHTMLTemplate;
}

- (NSString *)swatchHTMLTemplate
{
	if (swatchHTMLTemplate == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"swatch.html"];
		NSString *t = [[NSString alloc] initWithContentsOfFile:p];
		[self setSwatchHTMLTemplate:t];
		[t release];
	}
	return swatchHTMLTemplate;
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
	[defs setObject:[NSNumber numberWithInt:kKulerFeedTypeNewest] forKey:@"saturation.lastOpenedSection"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defs];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.visualizationType = [defaults integerForKey:@"saturation.visualizationType"];
	
	[[FontManager sharedManager] loadFont:CF_NORMAL];
	
	[self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
}

- (void)dealloc 
{
    [window release];
	[navController release];
	[welcomeController release];
	[swatchHTMLTemplate release];
	[bodyHTMLTemplate release];
    [super dealloc];
}

- (void)showListView
{
	BGSListViewController *controller = [[BGSListViewController alloc] init];
	[self.navController presentModalViewController:controller animated:YES];
	[controller release];	
}

- (void)showDetailFor:(NSDictionary *)entryData
{
	BGSDetailViewController *controller = [[BGSDetailViewController alloc] initWithEntry:entryData];
	[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self.navController presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)emailFor:(NSDictionary *)entryData
{
	if (![MFMailComposeViewController canSendMail])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Mail not configured." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[self hideModalView];
	[self performSelector:@selector(presentMailComposerFor:) withObject:entryData afterDelay:0.8];
}

- (void)presentMailComposerFor:(NSDictionary *)entryData
{
	MFMailComposeViewController *mailer = [MFMailComposeViewController new];
	[[mailer navigationBar] setTintColor:CC_BLACK];
	
	[mailer setSubject:[NSString stringWithFormat:@"[saturation] \"%@\" by %@", 
						[[entryData objectForKey:@"themeTitle"] lowercaseString], 
						[[entryData objectForKey:@"authorLabel"] lowercaseString], nil]];
	[mailer setMessageBody:[self bodyHTMLFor:entryData] isHTML:YES];
	[mailer setMailComposeDelegate:self];
	
	[self.navController presentModalViewController:mailer animated:YES];
	
	[mailer release];
}

- (NSString *)bodyHTMLFor:(NSDictionary *)entryData
{
	NSMutableString *body = [self.bodyHTMLTemplate mutableCopy];
	for (NSString *key in entryData)
	{
		NSString *formattedKey = [NSString stringWithFormat:@"{{%@}}", key];
		NSString *value = [entryData objectForKey:key];
		[body replaceOccurrencesOfString:formattedKey 
							  withString:value 
								 options:NSCaseInsensitiveSearch 
								   range:NSMakeRange(0, [body length])];
	}

	NSString *swatchHTML = @"";
	NSArray *swatches = [entryData objectForKey:@"swatches"];
	for (int i = 0; i < [swatches count]; i++)
	{
		NSDictionary *swatch = [swatches objectAtIndex:i];

		NSMutableString *swatchEntry = [self.swatchHTMLTemplate mutableCopy];
		
		[swatchEntry replaceOccurrencesOfString:@"{{colorNumber}}" 
									 withString:[NSString stringWithFormat:@"%i", i+1] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		[swatchEntry replaceOccurrencesOfString:@"{{swatchHexColor}}" 
									 withString:[swatch objectForKey:@"swatchHexColor"]
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		
		UIColor *color = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];
		const CGFloat *components = CGColorGetComponents(color.CGColor);
		int red = components[0]*255;
		int green = components[1]*255;
		int blue = components[1]*255;
		[swatchEntry replaceOccurrencesOfString:@"{{swatchRedValue}}" 
									 withString:[NSString stringWithFormat:@"%i", red] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		[swatchEntry replaceOccurrencesOfString:@"{{swatchGreenValue}}" 
									 withString:[NSString stringWithFormat:@"%i", green] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		[swatchEntry replaceOccurrencesOfString:@"{{swatchBlueValue}}" 
									 withString:[NSString stringWithFormat:@"%i", blue] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		
		swatchHTML = [swatchHTML stringByAppendingString:swatchEntry];
		
		[swatchEntry release];
	}
	
	[body replaceOccurrencesOfString:@"{{swatchHTML}}" 
						  withString:swatchHTML 
							 options:NSCaseInsensitiveSearch 
							   range:NSMakeRange(0, [body length])];
	
	return [body autorelease];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self hideModalView];
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
}

- (void)changeEntry:(NSDictionary *)entryData
{
	BGSMainViewController *c = (BGSMainViewController *)[self.navController topViewController];
	[c switchToVisualization:self.visualizationType withEntry:entryData];
	[self hideModalView];
}

- (void)hideModalView
{
	[self.navController dismissModalViewControllerAnimated:YES];
}

@end
