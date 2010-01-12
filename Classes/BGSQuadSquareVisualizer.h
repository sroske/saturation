//
//  BGSQuadSquareVisualizer.h
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FontsAndColors.h"
#import "BGSVisualizer.h"
#import "NSArray+Shuffle.h"
#import "UIColor+ColorFromHex.h"

#define ROWS		2
#define COLS		3
#define CUTOFF		5

@interface BGSQuadSquareVisualizer : UIView <BGSVisualizer>
{
	NSDictionary *entry;
	BOOL isFadingIn;
	BOOL hasAnimated;
	int fadedInCount;
}

@property (nonatomic, retain) NSDictionary *entry;

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

@end
