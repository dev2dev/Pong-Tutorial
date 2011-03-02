//
//  PauseScreen.m
//  Pong
//
//  Created by H4CK3R on 26/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SettingsBackgroundView.h"
#import "PauseScreen.h"
#import "Prefs.h"

#define SCALENUMBER(_number_) ((_number_/self.width)*self.width)

// --- private interface ---------------------------------------------------------------------------

@interface PauseScreen ()

-(void)closeAndContinue:(SPEvent*)event;
-(void)continueGame;
-(void)closeAndQuit:(SPEvent*)event;

-(UIImage*)pauseMenuBackgroundImage;
-(UIImage*)buttonTexure;
-(UIImage*)buttonPressedTexture;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation PauseScreen

@synthesize delegate;


- (id)initWithHeight:(int)h andWidth:(int)w{
    if (self = [super init]) {
		actualWidth = w;
		actualHeight = h;

        SPQuad *background = [SPQuad quadWithWidth:w height:h];
		background.color = 0x000000;
		background.alpha = 0.6;
		[self addChild:background];

		innerSprite = [[SPSprite alloc] init];
		[self addChild:innerSprite];

		SPTexture *backgroundTexture = [[SPTexture alloc] initWithContentsOfImage:[self pauseMenuBackgroundImage]];
		SPImage *innerBackground = [SPImage imageWithTexture:backgroundTexture];
		[innerSprite addChild:innerBackground];
		[backgroundTexture release];

		SPTextField *titleShadow = [SPTextField textFieldWithText:@"Paused"];
		titleShadow.fontSize = 40;
		titleShadow.hAlign = SPHAlignCenter;
		titleShadow.vAlign = SPVAlignTop;
		titleShadow.height = 85;
		titleShadow.width = (innerSprite.width-4);
		titleShadow.color = 0x4C4C4C;
		titleShadow.x = 4;
		titleShadow.y = 13;
		[innerSprite addChild:titleShadow];

		SPTextField *title = [SPTextField textFieldWithText:@"Paused"];
		title.fontSize = 40;
		title.hAlign = SPHAlignCenter;
		title.vAlign = SPVAlignTop;
		title.height = 85;
		title.width = innerSprite.width;
		title.color = 0xFFFFFF;
		title.y = 10;
		[innerSprite addChild:title];


		/******************** Buttons - Start *******************/
		SPTexture *buttonTexture = [[SPTexture alloc] initWithContentsOfImage:[self buttonTexure]];
		SPTexture *buttonPressedTexture = [[SPTexture alloc] initWithContentsOfImage:[self buttonPressedTexture]];

		SPButton *mainMenu = [SPButton buttonWithUpState:buttonTexture downState:buttonPressedTexture];
		mainMenu.x = (innerSprite.width*0.5)-(mainMenu.width*0.5);
		mainMenu.y = innerSprite.height-(mainMenu.height*1.5);
		mainMenu.fontSize = 34;
		mainMenu.fontName = @"Marker Felt";
		mainMenu.text = @"Quit";
		mainMenu.alpha = 0.9;
		[mainMenu addEventListener:@selector(closeAndQuit:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
		[innerSprite addChild:mainMenu];

		SPButton *continueButton = [SPButton buttonWithUpState:buttonTexture downState:buttonPressedTexture];
		continueButton.x = (innerSprite.width*0.5)-(continueButton.width*0.5);
		continueButton.y = innerSprite.height-(continueButton.height*3);
		continueButton.fontSize = 34;
		continueButton.fontName = @"Marker Felt";
		continueButton.text = @"Continue";
		continueButton.alpha = 0.9;
		[continueButton addEventListener:@selector(closeAndContinue:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
		[innerSprite addChild:continueButton];

		[buttonTexture release];
		[buttonPressedTexture release];
		/******************* Buttons - End *****************/

		//
		NSString *infoString = [NSString stringWithFormat:@"Current Stats\n\nPlayer1 Score: %d\nAI Score: %d\n", [[Prefs sharedInstance] currentPlayerScore],[[Prefs sharedInstance] currentAIScore]];
		//

		//
		SPTextField *infoText = [SPTextField textFieldWithWidth:(innerSprite.width-20)
														 height:((innerSprite.height)-(innerSprite.height-continueButton.y)-(title.y+title.textBounds.height+5))-10
														   text:infoString
													   fontName:SP_DEFAULT_FONT_NAME
													   fontSize:18
														  color:0xFFFFFF];
		infoText.vAlign = SPVAlignCenter;
		infoText.hAlign = SPHAlignCenter;
		infoText.y = title.y+title.textBounds.height+5;
		infoText.x = (innerSprite.width*0.5)-(infoText.width*0.5);
		infoText.border = YES;
		[innerSprite addChild:infoText];

		innerSprite.x = (self.width*0.5)-(innerBackground.width*0.5);
		innerSprite.y = (self.height*0.5)-(innerBackground.height*0.5);

		innerSprite.y += actualHeight;
		innerSprite.alpha = 0;
	}
	return self;
}

-(void)showAnimated:(BOOL)yesOrNo{
	if (yesOrNo) {
		SPTween *slideUp = [SPTween tweenWithTarget:innerSprite time:0.4];
		[slideUp animateProperty:@"y" targetValue:(innerSprite.y-actualHeight)];
		[slideUp animateProperty:@"alpha" targetValue:1.0];
		[self.stage.juggler addObject:slideUp];
	}
	else {
		innerSprite.y += -actualHeight;
		innerSprite.alpha = 1;
	}
}


-(void)closeAndContinue:(SPEvent*)event{
	self.touchable = NO;
	SPTween *fadeOut = [SPTween tweenWithTarget:innerSprite time:0.3];
	[fadeOut animateProperty:@"y" targetValue:self.height];
	[fadeOut animateProperty:@"alpha" targetValue:0];
	[self.stage.juggler addObject:fadeOut];
	[self performSelector:@selector(continueGame) withObject:nil afterDelay:0.4];
}
-(void)continueGame{
	[self removeFromParent];
	[delegate unPause];
}

-(void)closeAndQuit:(SPEvent*)event{
	[delegate quit];
}


/**********************************************************************************************/
/***************************** | Button Textures From UIViews | *******************************/
/**********************************************************************************************/
-(UIImage*)buttonTexure{
	CGRect frame;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		frame = CGRectMake(0, 0, innerSprite.width*0.65, innerSprite.height*0.15);
	}
	else {
		frame = CGRectMake(0, 0, innerSprite.width*0.75, innerSprite.height*0.1);
	}

	CoolWhiteView *view = [[CoolWhiteView alloc] initWithFrame:frame];
	view.layer.borderWidth = 1;
	view.layer.cornerRadius = 10;
	view.layer.masksToBounds = YES;
	view.layer.borderColor = [UIColor whiteColor].CGColor;

	CGRect rect = view.bounds;
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[view release];

	return img;
}

-(UIImage*)buttonPressedTexture{
	CGRect frame;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		frame = CGRectMake(0, 0, innerSprite.width*0.65, innerSprite.height*0.15);
	}
	else {
		frame = CGRectMake(0, 0, innerSprite.width*0.85, innerSprite.height*0.1);
	}

	CoolWhiteView *view = [[CoolWhiteView alloc] initWithFrame:frame];
	view.layer.borderWidth = 1;
	view.layer.cornerRadius = 10;
	view.layer.masksToBounds = YES;
	view.layer.borderColor = [UIColor whiteColor].CGColor;
//	view.transform = CGAffineTransformMakeScale(1,-1);

	CGRect rect = view.bounds;
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, view.frame.size.height);
	CGContextConcatCTM(context, flipVertical);
	[view.layer renderInContext:context];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[view release];
	return img;
}

-(UIImage*)pauseMenuBackgroundImage{
	CGRect viewRect;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		viewRect = CGRectMake(0, 0, self.width*0.75, self.height*0.5);
	}
	else {
		viewRect = CGRectMake(0, 0, self.width*0.75, self.height*0.75);
	}

	SettingsBackgroundView *view = [[SettingsBackgroundView alloc] initWithFrame:viewRect];
	view.layer.borderWidth = 3;
	view.layer.cornerRadius = 30;
	view.layer.masksToBounds = YES;
	view.layer.borderColor = [UIColor blueColor].CGColor;

	CGRect rect = view.bounds;
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[view release];
	return img;
}
/**********************************************************************************************/
/***************************** | Button Textures From UIViews | *******************************/
/**********************************************************************************************/



- (void)dealloc {
	NSLog(@"pause screen released");
	[innerSprite release];
    [super dealloc];
}


@end
