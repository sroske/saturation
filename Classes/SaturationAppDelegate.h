//
//  SaturationAppDelegate.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSKulerFeedController.h"
#import "BGSWelcomeViewController.h"
#import "BGSMainViewController.h"
#import "BGSDetailViewController.h"
#import "BGSListViewController.h"

@interface SaturationAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	UINavigationController *navController;
	BGSWelcomeViewController *welcomeController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) BGSWelcomeViewController *welcomeController;

- (void)showListView;
- (void)showDetailFor:(NSDictionary *)entryData;
- (void)hideModalView;

@end

