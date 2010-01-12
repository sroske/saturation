//
//  BGSSectionButton.h
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "FontLabel.h"
#import "FontsAndColors.h"

@interface BGSSectionButton : UIButton 
{
	FontLabel *label;
}

@property (nonatomic, retain) FontLabel *label;

@end
