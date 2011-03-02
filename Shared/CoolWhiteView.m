//
//	CoolWhiteView.m
//	Pong
//
//	Created by H4CK3R on 03/02/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoolWhiteView.h"


@implementation CoolWhiteView


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		// Initialization code
	}
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorRef whiteColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 
											 blue:210.0/255.0 alpha:1.0].CGColor;
	CGColorRef lightGrayColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 
												 blue:150.0/255.0 alpha:1.0].CGColor;
	CGRect paperRect = self.bounds;
	drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
}


- (void)dealloc {
	[super dealloc];
}


@end
