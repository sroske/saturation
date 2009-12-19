//
//  BGSMainViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSCircleView.h"

#define ROWS		3
#define COLS		2
#define PADDING		1

@interface BGSMainViewController : UIViewController 
{
	NSDictionary *entry;
}

@property (nonatomic, retain) NSDictionary *entry;

- (id)initWithEntry:(NSDictionary *)entryData;

@end