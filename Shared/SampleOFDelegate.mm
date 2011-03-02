#import "OpenFeint.h"
#import "SampleOFDelegate.h"

@implementation SampleOFDelegate

- (void)dashboardWillAppear{
}

- (void)dashboardDidAppear{
}

- (void)dashboardWillDisappear{
}

- (void)dashboardDidDisappear{
}

- (void)userLoggedIn:(NSString*)userId{
	OFLog(@"New user logged in! Hello %@", [OpenFeint lastLoggedInUserName]);
}

- (BOOL)showCustomOpenFeintApprovalScreen{
	return NO;
}

@end
