/*
 *  FontsAndColors.h
 *  Saturation
 *
 *  Created by Shawn Roske on 12/18/09.
 *  Copyright 2009 Bitgun. All rights reserved.
 *
 */

#define CC_FROM_RGB(rgb) [UIColor \
	colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 \
	green:((float)((rgb & 0xFF00) >> 8))/255.0 \
	blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

#define CC_FROM_SWATCH(s) [UIColor \
	colorWithRed:[[s objectForKey:@"swatchChannel1"] floatValue] \
	green:[[s objectForKey:@"swatchChannel2"] floatValue] \
	blue:[[s objectForKey:@"swatchChannel3"] floatValue] \
	alpha:1.0f]

#define CF_FROM_NAME(n, s) [UIFont fontWithName:n size:s]


#define CC_BLACK				CC_FROM_RGB(0x000000)
#define CC_WHITE				CC_FROM_RGB(0xffffff)
#define CC_BACKGROUND			CC_FROM_RGB(0x070c0c)
#define CC_CLEAR				[UIColor clearColor]

#define CF_DETAIL_TITLE			CF_FROM_NAME(@"HelveticaNeue", 48.0f)
#define CF_DETAIL_AUTHOR		CF_FROM_NAME(@"HelveticaNeue", 24.0f)
#define CF_DETAIL_COLOR_TYPE	CF_FROM_NAME(@"HelveticaNeue", 24.0f)
#define CF_DETAIL_COLOR_DATA	CF_FROM_NAME(@"HelveticaNeue", 14.0f)
#define CF_DETAIL_EMAIL			CF_FROM_NAME(@"HelveticaNeue", 16.0f)
