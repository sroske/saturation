//
//  BGSLoadingView.h
//  Saturation
//
//  Created by Shawn Roske on 12/30/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSLoadingView : UIView 
{
	UIActivityIndicatorView *indicator;
	UILabel *titleLabel;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *titleLabel;

@end
