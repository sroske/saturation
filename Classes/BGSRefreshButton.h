//
//  BGSRefreshButton.h
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "FontsAndColors.h"

@interface BGSRefreshButton : UIButton 
{
	UIImageView *icon;
	FontLabel *label;
}

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) FontLabel *label;

@end
