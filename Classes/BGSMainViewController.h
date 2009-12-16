//
//  BGSMainViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGSCircleView.h"
#import "BGSKulerParser.h"

#define ROWS		3
#define COLS		2
#define PADDING		1

@interface BGSMainViewController : UIViewController 
{
	NSArray *colors;
}

@property (nonatomic, retain) NSArray *colors;

@end