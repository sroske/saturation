//
//  SaturationAppDelegate.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "cocos2d.h"
#import "FontsAndColors.h"
#import "FontManager.h"

#import "BGSKulerFeedController.h"

#import "BGSMainViewController.h"
#import "BGSWelcomeViewController.h"
#import "BGSDetailViewController.h"
#import "BGSListViewController.h"
#import "BGSMailController.h"

#import "BGSSimpleCircleScene.h"
#import "BGSSimpleParticlesScene.h"

#define DEFAULT_VISUALIZER_TYPE kSimpleCircle

enum VisualizationTypes
{
	kSimpleCircle = 10000,
	kSimpleParticles
};

enum ControllerTypes
{
	kListViewController = 20000,
	kDetailViewController,
	kMainViewController
};

@interface SaturationAppDelegate : NSObject <UIApplicationDelegate,  MFMailComposeViewControllerDelegate> 
{
	NSDictionary *entry;
    UIWindow *window;
	BGSListViewController *listController;
	BGSDetailViewController *detailController;
	BGSMainViewController *mainController;
	BGSWelcomeViewController *welcomeController;
	int visualizationType;
	int controllerState;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) BGSListViewController *listController;
@property (nonatomic, retain) BGSDetailViewController *detailController;
@property (nonatomic, retain) BGSMainViewController *mainController;
@property (nonatomic, retain) BGSWelcomeViewController *welcomeController;
@property (nonatomic, assign) int visualizationType;
@property (nonatomic, assign) int controllerState;

- (void)showMainView;
- (void)changeEntry:(NSDictionary *)entryData;

- (void)showListView;
- (void)closeListView;

- (void)showDetailView;
- (void)closeDetailView;

- (void)emailView;

@end

