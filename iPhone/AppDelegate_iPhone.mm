//
//  AppDelegate_iPhone.m
//  Pong
//
//  Created by H4CK3R on 20/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "SampleOFDelegate.h"

//#define COOL_BUTTON(_buttonID_) ((CustomButton*)_buttonID_)

//Private Interface (i.e other objects can't use).
@interface AppDelegate_iPhone ()

-(void)removeImage:(UIImageView*)imageView;
-(void)resetGameButtons;
-(void)resetButtons:(NSNotification *) notification;

@end
//Private Interface End


@implementation AppDelegate_iPhone

@synthesize window, sparrowView;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[self styleCustomViews];

	//Start Sparrow (sort of)
	CGRect sparrowFrame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
	sparrowView = [[SPView alloc] initWithFrame:sparrowFrame];
	[SPStage setSupportHighResolutions:YES];

	/**** || OpenFeint Setup Start || ****/
	// Override point for customization after application launch.
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInt:UIInterfaceOrientationPortrait], OpenFeintSettingDashboardOrientation,
							  [NSNumber numberWithBool:YES], OpenFeintSettingDisableUserGeneratedContent, nil];
	SampleOFDelegate *ofDelegate = [SampleOFDelegate new];
	OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:ofDelegate];
	[OpenFeint initializeWithProductKey:@"YOUR_PRODUCT_KEY"
							  andSecret:@"YOUR_SECRET_KEY"
						 andDisplayName:@"Pong"
							andSettings:settings    // see OpenFeintSettings.h
						   andDelegates:delegates]; // see OFDelegatesContainer.h
	/**** || OpenFeint Setup End || ****/


	[window makeKeyAndVisible];

	//Create an image view with the launch image in it.
	UIImageView *loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	[window addSubview:loadingImage]; //Add the UIImageView to the screen
	[self removeImage:loadingImage]; //Start the image fading out.

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetButtons:) name:@"ResetButtons" object:nil];
	slideRight = (playButton.frame.origin.x+window.frame.size.width);
	slideLeft = -slideRight;

	return YES;
}

-(void)removeImage:(UIImageView*)imageView{
	//statis means that every time this function is called it will still use the same boolean not a new one.
	static BOOL preRun = NO; // this sets have i been used before to NO.

	//If this is the first call made to this function, fade the ImageView out
	if (!preRun) {
		preRun = YES; //A call to this function has now been made.
		//Begin the Animtions
		[UIView beginAnimations:@"FadeOut" context:nil];
		[UIView setAnimationDuration:1.5];	//How long it lasts
		imageView.alpha = 0;				//What it'll actually do
		[UIView commitAnimations];			//Start the animation
		//Tell 'self': to do something later; when; and what object to send itself.
		[self performSelector:@selector(removeImage:) withObject:imageView afterDelay:1.5];
	}

	// If the fadeout stuff has already been run do this
	else if (preRun) {
		NSLog(@"Removing Image View");
		[imageView removeFromSuperview]; //Remove the imageView from screen
		[imageView release]; //Remove the imageView from memory as well
	}
}

-(void)styleCustomViews{
	//*** Custom Styling Settings ***//
	titleViewShadow.layer.masksToBounds = YES;
	titleViewShadow.layer.borderWidth = 2.0f;
	titleViewShadow.layer.cornerRadius = 15.0f;

	titleView.layer.masksToBounds = YES;
	titleView.layer.borderWidth = 2.0f;
	titleView.layer.cornerRadius = 15.0f;
	titleView.layer.borderColor = [UIColor blackColor].CGColor;

	//Activate Custom Styling on the buttons
	[playButton activate];
	[settingsButton activate];
	[aboutButton activate];
	[creditsButton activate];
}

-(IBAction)playPressed:(id)sender{
	[self zoomIntoGame];
}

-(IBAction)settingsPressed:(id)sender{
	[self zoomToSettings];
}

-(IBAction)aboutPressed:(id)sender{
	
}

-(IBAction)creditsPressed:(id)sender{
	UIAlertView *creditsAlert = [[[UIAlertView alloc] initWithTitle:@"Developer: Kyle Howells\nPowered By: Sparrow-Framework" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[creditsAlert show];
}

-(IBAction)LaunchOpenFeint{
	[OpenFeint launchDashboard];
}

-(void)zoomIntoGame{
	[UIView beginAnimations:@"Slide In" context:nil];
	[UIView setAnimationDuration:0.1];
	playButton.frame = CGRectOffset(playButton.frame, -10, 0);
	settingsButton.frame = CGRectOffset(settingsButton.frame, 10, 0);
	aboutButton.frame = CGRectOffset(aboutButton.frame, -10, 0);
	creditsButton.frame = CGRectOffset(creditsButton.frame, 10, 0);
	OpenFeintButton.alpha = 0;
	[UIView commitAnimations];


	[UIView beginAnimations:@"Slide Out" context:nil];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelay:0.1];
	//Slide Buttons
	playButton.frame = CGRectOffset(playButton.frame, slideRight, 0);
	settingsButton.frame = CGRectOffset(settingsButton.frame, slideLeft, 0);
	aboutButton.frame = CGRectOffset(aboutButton.frame, slideRight, 0);
	creditsButton.frame = CGRectOffset(creditsButton.frame, slideLeft, 0);
	//Fade out buttons
	playButton.alpha = 0;
	settingsButton.alpha = 0;
	aboutButton.alpha = 0;
	creditsButton.alpha = 0;
	[UIView commitAnimations];

	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelay:0.5];
	titleView.alpha = 0;
	titleViewShadow.alpha = 0;
	[UIView commitAnimations];

	[UIView beginAnimations:@"Zoom in" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelay:0.75];
	backgroundView.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(AddGameView)];
	[UIView commitAnimations];
}

-(void)AddGameView{
	SP_CREATE_POOL(pool);
    [SPAudioEngine start];

    game = [[Game alloc] initWithWidth:320 height:480];
    sparrowView.stage = game;
	game.delegate = self;
    [sparrowView start];
    SP_RELEASE_POOL(pool);

	sparrowView.alpha = 0;
	[window addSubview:sparrowView];

	[UIView beginAnimations:@"Fade_Out" context:nil];
	[UIView setAnimationDuration:0.5f];
	sparrowView.alpha = 1;
	[UIView commitAnimations];
}

-(void)removeGameView{
	[SPAudioEngine stop];
	[sparrowView stop];

	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5f];
	sparrowView.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(removeSparrowPart2)];
	[UIView commitAnimations];
}

-(void)removeSparrowPart2{
	sparrowView.stage = nil;
	[game release];
	game = nil;
	[sparrowView removeFromSuperview];
	sparrowView.alpha = 1;

	[self resetGameButtons];
}

-(void)resetGameButtons{
	//Reset Buttons
	[UIView beginAnimations:@"SlideOut" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelay:0.6];
	OpenFeintButton.alpha = 1;
	[UIView commitAnimations];


	[UIView beginAnimations:@"Slide_Out" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(resetGameButtons2)];
	playButton.frame = CGRectOffset(playButton.frame, slideLeft, 0);
	settingsButton.frame = CGRectOffset(settingsButton.frame, slideRight, 0);
	aboutButton.frame = CGRectOffset(aboutButton.frame, slideLeft, 0);
	creditsButton.frame = CGRectOffset(creditsButton.frame, slideRight, 0);
	//Fade out buttons
	playButton.alpha = 1;
	settingsButton.alpha = 1;
	aboutButton.alpha = 1;
	creditsButton.alpha = 1;
	[UIView commitAnimations];


	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelay:0];
	titleView.alpha = 1;
	titleViewShadow.alpha = 0.1;
	[UIView commitAnimations];


	[UIView beginAnimations:@"FadeIn" context:nil];
	[UIView setAnimationDuration:0.3];
	backgroundView.alpha = 1;
	[UIView commitAnimations];
}
-(void)resetGameButtons2{
	[UIView beginAnimations:@"SlideOver" context:nil];
	[UIView setAnimationDuration:0.1];
	playButton.frame = CGRectOffset(playButton.frame, 10, 0);
	settingsButton.frame = CGRectOffset(settingsButton.frame, -10, 0);
	aboutButton.frame = CGRectOffset(aboutButton.frame, 10, 0);
	creditsButton.frame = CGRectOffset(creditsButton.frame, -10, 0);
	[UIView commitAnimations];
}



-(void)zoomToSettings{
	[UIView beginAnimations:@"Slide Out" context:nil];
	[UIView setAnimationDuration:0.2];
	OpenFeintButton.alpha = 0;
	[UIView commitAnimations];

	[UIView beginAnimations:@"Slide Out" context:nil];
	[UIView setAnimationDuration:0.5];
	playButton.frame = CGRectOffset(playButton.frame, slideRight, 0);
	settingsButton.frame = CGRectOffset(settingsButton.frame, slideLeft, 0);
	aboutButton.frame = CGRectOffset(aboutButton.frame, slideRight, 0);
	creditsButton.frame = CGRectOffset(creditsButton.frame, slideLeft, 0);
	//Fade out buttons
	playButton.alpha = 0;
	settingsButton.alpha = 0;
	aboutButton.alpha = 0;
	creditsButton.alpha = 0;
	[UIView commitAnimations];

	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelay:0.3];
	titleView.alpha = 0;
	titleViewShadow.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(openSettings)];
	[UIView commitAnimations];
}


-(void)openSettings{
	SettingsView_iPhone *settingsView = [[SettingsView_iPhone alloc] initWithNibName:@"SettingsView_iPhone" bundle:nil];
	[window addSubview:settingsView.view];
	settingsView.view.alpha = 0;
	settingsView.view.frame = CGRectMake(10, window.frame.size.height, settingsView.view.frame.size.width, settingsView.view.frame.size.height);

	[UIView beginAnimations:@"Slide In" context:nil];
	[UIView setAnimationDuration:0.4];
	settingsView.view.frame = CGRectMake(10, 20, settingsView.view.frame.size.width, settingsView.view.frame.size.height);
	[UIView commitAnimations];

	[UIView beginAnimations:@"Fade In" context:nil];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelay:0.2];
	settingsView.view.alpha = 1;
	[UIView commitAnimations];
}


//Aplication Activity
- (void)applicationWillResignActive:(UIApplication *)application {
	[OpenFeint applicationWillResignActive];
	if (sparrowView.stage != nil){
		[sparrowView stop];
	}
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
	if (sparrowView.stage != nil){
		[sparrowView stop];
	}
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
	if (sparrowView.stage != nil){
		[sparrowView start];
	}
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
	if (sparrowView.stage != nil){
		[sparrowView start];
	}
	[OpenFeint applicationDidBecomeActive];
}
- (void)applicationWillTerminate:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] synchronize];
}



-(void)resetButtons:(NSNotification *) notification{
	[UIView beginAnimations:@"Slide Out" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelay:0.6];
	OpenFeintButton.alpha = 1;
	[UIView commitAnimations];

	[UIView beginAnimations:@"Slide Out" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:0.1];
	playButton.frame = CGRectOffset(playButton.frame, slideLeft, 0);
	settingsButton.frame = CGRectOffset(settingsButton.frame, slideRight, 0);
	aboutButton.frame = CGRectOffset(aboutButton.frame, slideLeft, 0);
	creditsButton.frame = CGRectOffset(creditsButton.frame, slideRight, 0);
	//Fade out buttons
	playButton.alpha = 1;
	settingsButton.alpha = 1;
	aboutButton.alpha = 1;
	creditsButton.alpha = 1;
	[UIView commitAnimations];

	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelay:0];
	titleView.alpha = 1;
	titleViewShadow.alpha = 0.1;
	[UIView commitAnimations];
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	/*
	 Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	*/
}


- (void)dealloc {
	[sparrowView release];
	[window release];
	[super dealloc];
}


@end
