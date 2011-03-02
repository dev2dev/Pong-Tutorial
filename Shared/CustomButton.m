//
//  CustomButton.m
//  Pong
//
//  Created by H4CK3R on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomButton.h"
#import "Common.h"


@implementation CustomButton

@synthesize pressedDown = mPressedDown;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.pressedDown = NO;
    }
    return self;
}

-(void)activate{
	//Styling Settings
	self.layer.cornerRadius = 10;
	self.layer.masksToBounds = YES;

	/*** Buttons Styling when pressed ***/
	//Button Being Pressed
	[self addTarget:self action:@selector(pressedStart) forControlEvents:UIControlEventTouchDown];
	[self addTarget:self action:@selector(pressedStart) forControlEvents:UIControlEventTouchDownRepeat];
	[self addTarget:self action:@selector(pressedStart) forControlEvents:UIControlEventTouchDragEnter];
	[self addTarget:self action:@selector(pressedStart) forControlEvents:UIControlEventTouchDragInside];

	//Button Not Being Pressed
	[self addTarget:self action:@selector(pressedEnded) forControlEvents:UIControlEventTouchCancel];
	[self addTarget:self action:@selector(pressedEnded) forControlEvents:UIControlEventTouchDragExit];
	[self addTarget:self action:@selector(pressedEnded) forControlEvents:UIControlEventTouchDragOutside];
	[self addTarget:self action:@selector(pressedEnded) forControlEvents:UIControlEventTouchUpInside];
	[self addTarget:self action:@selector(pressedEnded) forControlEvents:UIControlEventTouchUpOutside];
}

-(void)pressedStart{
	if (!self.pressedDown) {
		self.pressedDown = YES;
	}
}
-(void)pressedEnded{
	if (self.pressedDown) {
		self.pressedDown = NO;
	}
}


-(void)setPressedDown:(BOOL)value{
	mPressedDown = value;
	[self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	//If the button is being pressed make make it look different to normal
	if (mPressedDown) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGColorRef whiteColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 
												 blue:60.0/255.0 alpha:1.0].CGColor;
		CGColorRef lightGrayColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 
													 blue:0.0/255.0 alpha:1.0].CGColor;
		CGRect paperRect = self.bounds;
		drawLinearGradient(context, paperRect, lightGrayColor, whiteColor);
		return; //Stop the rest of the function from being run
	}

	//If we haven't been stopped because it's being pressed then apply the default style
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorRef whiteColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 
											 blue:80.0/255.0 alpha:1.0].CGColor;
	CGColorRef lightGrayColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 
												 blue:0.0/255.0 alpha:1.0].CGColor;
	CGRect paperRect = self.bounds;
	drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
}


- (void)dealloc {
    [super dealloc];
}


@end
