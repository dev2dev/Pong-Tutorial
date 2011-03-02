//
//	SettingsView_iPhone.m
//	Pong
//
//	Created by H4CK3R on 06/02/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsView_iPhone.h"


@implementation SettingsView_iPhone

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	/***************** STYLING - START ******************/
	//Setup custom Styling Options for the view
	self.view.layer.borderWidth = 2.0f; //Give it a border
	self.view.layer.masksToBounds = YES; //Don't let it just ignore the border
	self.view.layer.cornerRadius = 26.0f; //Round the corners
	self.view.layer.borderColor = [UIColor blueColor].CGColor; //Give the border a nice color

	[closeButton activate]; //Activate the button's styling
	closeButton.layer.borderWidth = 1.0f; //And do some more styling like
	closeButton.layer.borderColor = [UIColor whiteColor].CGColor; //border color
	/***************** STYLING - END ******************/



	/***************** LOAD SETTINGS - START ******************/
	pointsPerGame.value = [Prefs sharedInstance].currentGameMax;
	[self updatePPGText];
	/***************** LOAD SETTINGS - START ******************/
}

-(IBAction)ppgSliderChanged:(id)sender{
	[self updatePPGText];
}

-(void)updatePPGText{
	ppgText.text = [NSString stringWithFormat:@"( %.0f )",pointsPerGame.value];
}

-(IBAction)closeAndSave{
	[Prefs sharedInstance].currentGameMax = pointsPerGame.value;

	//Close Animation
	[UIView beginAnimations:@"Fade Out" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	self.view.frame = CGRectMake(10, [self.view superview].frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
	self.view.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(quit)];
	[UIView commitAnimations];
}
-(void)quit{
	[self.view removeFromSuperview]; //Remove it from the screen
	[self release]; //Remove it from memory

	//Tell the MainMenu to start the animations again
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ResetButtons" object:nil];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}


@end
