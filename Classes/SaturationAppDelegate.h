//
//  SaturationAppDelegate.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright Bitgun 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSMainViewController.h"

@interface SaturationAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	BGSMainViewController *controller;
}

@property (nonatomic, retain) UIWindow *window;

@end

