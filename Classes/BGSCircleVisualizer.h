//
//  BGSCircleVisualizer.h
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSVisualizer.h"
#import "BGSCircleView.h"
#import "NSArray+Shuffle.h"
#import "UIColor+ColorFromHex.h"

#define ROWS		2
#define COLS		3
#define CUTOFF		5

@interface BGSCircleVisualizer : UIView <BGSVisualizer>
{
	NSDictionary *entry;
	UIView *circleView;
	NSMutableArray *initialCircles;
	BOOL isFadingIn;
	BOOL hasAnimated;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIView *circleView;

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

@end
