//
//  BGSQuadCircleGroupView.h
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSQuadCircleView.h"

#define QUAD_CIRCLE_GROUP_ROWS		2
#define QUAD_CIRCLE_GROUP_COLS		2
#define QUAD_CIRCLE_CUTOFF			5.0f
#define QUAD_CIRCLE_HIDE_PADDING	4.0f

@interface BGSQuadCircleGroupView : UIView 
{
	NSDictionary *entry;
	UIColor *primaryColor;
	BGSQuadCircleView *circle;
	BGSQuadCircleGroupView *parent;
	NSMutableArray *children;
	BOOL isAnimating;
	BOOL hasSplit;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, retain) BGSQuadCircleView *circle;
@property (nonatomic, assign) BGSQuadCircleGroupView *parent;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL hasSplit;

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData;
- (void)split;

@end
