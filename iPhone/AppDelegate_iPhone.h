//
//  AppDelegate_iPhone.h
//  Pong
//
//  Created by H4CK3R on 20/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OpenFeint.h"
#import "Sparrow.h"
#import "Game.h"
#import "PatternView.h"
#import "CustomButton.h"
#import "CoolWhiteView.h"
#import "SettingsView_iPhone.h"


@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, SPGameDelegate> {
	UIWindow *window;
	SPView *sparrowView;
	Game *game;
	IBOutlet CoolWhiteView *backgroundView;

	IBOutlet PatternView *titleView;
	IBOutlet PatternView *titleViewShadow;

	IBOutlet CustomButton *playButton;
	IBOutlet CustomButton *settingsButton;
	IBOutlet CustomButton *aboutButton;
	IBOutlet CustomButton *creditsButton;
	IBOutlet UIButton *OpenFeintButton;

	int slideRight;
	int slideLeft;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SPView *sparrowView;

//Little Setup Functions
-(void)styleCustomViews;

//Buttons
-(IBAction)playPressed:(id)sender;
-(IBAction)settingsPressed:(id)sender;
-(IBAction)aboutPressed:(id)sender;
-(IBAction)creditsPressed:(id)sender;

-(IBAction)LaunchOpenFeint;

//Other Functions
-(void)zoomIntoGame;
-(void)zoomToSettings;


@end

