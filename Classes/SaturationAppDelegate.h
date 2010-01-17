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
#import "FontManager.h"

#import "BGSKulerFeedController.h"

#import "BGSMainViewController.h"
#import "BGSWelcomeViewController.h"
#import "BGSDetailViewController.h"
#import "BGSListViewController.h"
#import "BGSMailController.h"

#import "BGSSimpleCircleScene.h"
#import "BGSSimpleSquareScene.h"
#import "BGSSimpleParticlesScene.h"

#define DEFAULT_VISUALIZER_TYPE kSimpleCircle

enum VisualizationTypes
{
	kSimpleCircle = 10000,
	kSimpleSquare,
	kSimpleParticles
};

@interface SaturationAppDelegate : NSObject <UIApplicationDelegate,  MFMailComposeViewControllerDelegate> 
{
	NSDictionary *entry;
    UIWindow *window;
	BGSMainViewController *mainController;
	BGSWelcomeViewController *welcomeController;
	int visualizationType;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) BGSMainViewController *mainController;
@property (nonatomic, retain) BGSWelcomeViewController *welcomeController;
@property (nonatomic, assign) int visualizationType;

- (void)showMainView;
- (void)showListView;
- (void)showDetailView;
- (void)changeEntry:(NSDictionary *)entryData;
- (void)emailView;
- (void)hideModalView;

@end

