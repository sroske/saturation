//
//  SaturationAppDelegate.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BGSKulerFeedController.h"
#import "BGSWelcomeViewController.h"
#import "BGSMainViewController.h"
#import "BGSDetailViewController.h"
#import "BGSListViewController.h"

#define DEFAULT_VISUALIZER_TYPE kSimpleCircle

enum VisualizationTypes
{
	kQuadCircle = 10000, 
	kSimpleCircle,
	kQuadSquare,
	kSimpleSquare
};

@interface SaturationAppDelegate : NSObject <UIApplicationDelegate, MFMailComposeViewControllerDelegate> 
{
    UIWindow *window;
	UINavigationController *navController;
	BGSWelcomeViewController *welcomeController;
	int visualizationType;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) BGSWelcomeViewController *welcomeController;
@property (nonatomic, assign) int visualizationType;

- (void)showListView;
- (void)showDetailFor:(NSDictionary *)entryData;
- (void)changeEntry:(NSDictionary *)entryData;
- (void)emailFor:(NSDictionary *)entryData;
- (void)hideModalView;

@end

