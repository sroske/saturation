//
//  BGSMainViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSMainViewController : UIViewController
{
	UIImageView *logo;
	UIImageView *kulerLogo;
	UIButton *settingsButton;
	UIButton *infoButton;
	BOOL hasAnimated;
}

@property (nonatomic, retain) UIImageView *logo;
@property (nonatomic, retain) UIImageView *kulerLogo;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *infoButton;


@end