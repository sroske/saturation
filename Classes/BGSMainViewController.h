//
//  BGSMainViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSDetailViewController.h"
#import "BGSCircleView.h"

#define ROWS		2
#define COLS		3
#define PADDING		1

@interface BGSMainViewController : UIViewController 
{
	UIView *circleView;
	NSDictionary *entry;
	UIButton *infoButton;
}

@property (nonatomic, retain) UIView *circleView;
@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIButton *infoButton;

- (id)initWithEntry:(NSDictionary *)entryData;

@end