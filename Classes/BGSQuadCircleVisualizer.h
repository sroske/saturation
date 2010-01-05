//
//  BGSQuadCircleVisualizer.h
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSVisualizer.h"
#import "BGSQuadCircleGroupView.h"
#import "NSArray+Shuffle.h"

#define QUAD_CIRCLE_ROWS		2
#define QUAD_CIRCLE_COLS		3

@interface BGSQuadCircleVisualizer : UIView <BGSVisualizer>
{
	NSDictionary *entry;
	NSArray *circles;
	BOOL isFadingIn;
	BOOL hasAnimated;
	NSTimer *timer;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) NSArray *circles;
@property (nonatomic, retain) NSTimer *timer;

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

@end
