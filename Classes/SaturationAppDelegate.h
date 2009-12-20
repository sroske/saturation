//
//  SaturationAppDelegate.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSKulerParser.h"
#import "BGSWelcomeViewController.h"

@interface SaturationAppDelegate : NSObject <UIApplicationDelegate> 
{
	NSString *path;
	NSArray *entries;
    UIWindow *window;
	UINavigationController *navController;
	BGSWelcomeViewController *welcomeController;
}

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) BGSWelcomeViewController *welcomeController;

- (void)fetchNewEntries;
- (NSDictionary *)randomEntry;
- (void)showDetailFor:(NSDictionary *)entryData;

@end

