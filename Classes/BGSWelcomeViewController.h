//
//  BGSWelcomeViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSMainViewController.h"
#import "FontsAndColors.h"

@interface BGSWelcomeViewController : UIViewController 
{
	UIImageView *shadow;
	UIImageView *logo;
	UIImageView *kulerLogo;
	UIImageView *light;
}

@property (nonatomic, retain) UIImageView *shadow;
@property (nonatomic, retain) UIImageView *logo;
@property (nonatomic, retain) UIImageView *kulerLogo;
@property (nonatomic, retain) UIImageView *light;

@end
