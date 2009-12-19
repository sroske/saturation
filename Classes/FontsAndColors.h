/*
 *  FontsAndColors.h
 *  Saturation
 *
 *  Created by Shawn Roske on 12/18/09.
 *  Copyright 2009 Bitgun. All rights reserved.
 *
 */

#define UIColorFromRGB(rgbValue) [UIColor \
	colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
	green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
	blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define CC_BLACK				UIColorFromRGB(0x000000)
#define CC_WHITE				UIColorFromRGB(0xffffff)
#define CC_BACKGROUND			[UIColor colorWithRed:17.0f/255.0f green:23.0f/255.0f blue:23.0f/255.0f alpha:1.0f]


#define CF_DETAIL_TITLE			[UIFont fontWithName:@"HelveticaNeue" size:48.0f]
#define CF_DETAIL_AUTHOR		[UIFont fontWithName:@"HelveticaNeue" size:24.0f]
#define CF_DETAIL_COLOR_TYPE	[UIFont fontWithName:@"HelveticaNeue" size:24.0f]
#define CF_DETAIL_COLOR_DATA	[UIFont fontWithName:@"HelveticaNeue" size:14.0f]
#define CF_DETAIL_EMAIL			[UIFont fontWithName:@"HelveticaNeue" size:16.0f]
