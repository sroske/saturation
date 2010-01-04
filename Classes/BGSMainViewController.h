//
//  BGSMainViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSVisualizer.h"
#import "BGSCircleVisualizer.h"
#import "BGSQuadCircleVisualizer.h"

@interface BGSMainViewController : UIViewController
{
	NSDictionary *entry;
	UIImageView *logo;
	UIImageView *kulerLogo;
	UIImageView *background;
	UIButton *settingsButton;
	UIButton *infoButton;
	BOOL hasAnimated;
	BGSQuadCircleVisualizer *visualizer;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIImageView *logo;
@property (nonatomic, retain) UIImageView *kulerLogo;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) BGSQuadCircleVisualizer *visualizer;

- (id)initWithEntry:(NSDictionary *)entryData;

@end