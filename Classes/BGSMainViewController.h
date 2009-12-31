//
//  BGSMainViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSCircleView.h"
#import "BGSCircleScrollView.h"
#import "NSArray-Shuffle.h"

#define ROWS		2
#define COLS		3
#define PADDING		1

@interface BGSMainViewController : UIViewController <UIScrollViewDelegate>
{
	UIImageView *logo;
	UIImageView *kulerLogo;
	UIImageView *background;
	UIView *circleView;
	BGSCircleScrollView *scrollView;
	NSDictionary *entry;
	UIButton *settingsButton;
	UIButton *infoButton;
	BOOL hasAnimated;
	NSMutableArray *initialCircles;
}

@property (nonatomic, retain) UIImageView *logo;
@property (nonatomic, retain) UIImageView *kulerLogo;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIView *circleView;
@property (nonatomic, retain) BGSCircleScrollView *scrollView;
@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *infoButton;

- (id)initWithEntry:(NSDictionary *)entryData;

@end