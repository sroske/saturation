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

#define CCC3_FROM_UICOLOR(uicolor) ccc3(CGColorGetComponents(uicolor.CGColor)[0]*255, \
	CGColorGetComponents(uicolor.CGColor)[1]*255, \
	CGColorGetComponents(uicolor.CGColor)[2]*255)


#define CC_BLACK				CC_FROM_RGB(0x000000)
#define CC_WHITE				CC_FROM_RGB(0xffffff)
#define CC_SECTION_BUTTON		CC_FROM_RGB(0x878686)
#define CC_BACKGROUND			CC_FROM_RGB(0x070c0c)
#define CC_LIST_SEPERATOR		CC_FROM_RGB(0xb9bbbd)
#define CC_LIST_BACKGROUND		CC_FROM_RGB(0x303535)
#define CC_LOADING				CC_FROM_RGB(0x797979)
#define	CC_REFRESH				CC_FROM_RGB(0xffffff)
#define CC_CLEAR				[UIColor clearColor]


#define CF_NORMAL				@"HelveticaNeueLTStd-Lt.otf"
