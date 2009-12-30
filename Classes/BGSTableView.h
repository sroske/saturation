//
//  BGSTableView.h
//  Saturation
//
//  Created by Shawn Roske on 12/30/09.
//  Copyright 2009 Bitgun. All rights reserved.
//
//	Stolen from http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define SHADOW_HEIGHT 10.0
#define SHADOW_INVERSE_HEIGHT 5.0

@interface BGSTableView : UITableView 
{
	CAGradientLayer *originShadow;
	CAGradientLayer *topShadow;
	CAGradientLayer *bottomShadow;
}

@end
