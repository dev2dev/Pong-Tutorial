//
//  SettingsView_iPhone.h
//  Pong
//
//  Created by H4CK3R on 06/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingsBackgroundView.h"
#import "CustomButton.h"
#import "Prefs.h"


@interface SettingsView_iPhone : UIViewController {
	IBOutlet UISlider *pointsPerGame;
	IBOutlet UISlider *volume;
	IBOutlet UILabel *ppgText;

	IBOutlet CustomButton *closeButton;
}

-(void)updatePPGText;


-(IBAction)ppgSliderChanged:(id)sender;
-(IBAction)closeAndSave;
//-(IBAction):(id)sender;


@end
