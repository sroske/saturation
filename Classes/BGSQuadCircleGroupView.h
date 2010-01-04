//
//  BGSQuadCircleGroupView.h
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FontsAndColors.h"

#define QUAD_CIRCLE_GROUP_ROWS		2
#define QUAD_CIRCLE_GROUP_COLS		2
#define QUAD_CIRCLE_CUTOFF			5.0f
#define QUAD_CIRCLE_HIDE_PADDING	4.0f

@interface BGSQuadCircleGroupView : UIView 
{
	NSDictionary *entry;
	UIColor *primaryColor;
	BOOL isAnimating;
	BOOL hasSplit;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL hasSplit;

- (id)initWithFrame:(CGRect)frame andPrimaryColor:(UIColor *)color andEntry:(NSDictionary *)entryData;

- (void)split;
- (void)combine;

@end
