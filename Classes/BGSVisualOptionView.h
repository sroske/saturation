//
//  BGSVisualOptionView.h
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSVisualOptionView : UIView 
{
	UIImageView *background;
	UIImage *icon;
	UIImage *selectedIcon;
	UIButton *iconButton;
	BOOL isSelected;
	BOOL hasBackground;
	int visualizationType;
}


@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) UIImage *selectedIcon;
@property (nonatomic, retain) UIButton *iconButton;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL hasBackground;
@property (nonatomic, assign) int visualizationType;

- (id)initWithFrame:(CGRect)frame andType:(int)type;

@end
