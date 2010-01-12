//
//  BGSLoadingView.h
//  Saturation
//
//  Created by Shawn Roske on 12/30/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "FontsAndColors.h"

@interface BGSLoadingView : UIView 
{
	UIActivityIndicatorView *indicator;
	FontLabel *titleLabel;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) FontLabel *titleLabel;

@end
