#import "_Template_AppDelegate.h"
#import "BrandedUIFactory.h"
#import "_Template_Views.h"

@implementation _Template_AppDelegate

@synthesize window, rootController;

- (void) applicationDidFinishLaunching:(UIApplication *)application {
	// create a window for non-xib application setup
	if (!self.window) {
		self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[self.window release];
	}
	[BrandedUIFactory brandApplication:application];
	self.rootController = [_Template_Views create_Template_];
	[window makeKeyAndVisible];
}

- (void) setRootController:(UIViewController *) controller {
	if (rootController) {
		[rootController.view removeFromSuperview];
		[rootController release];
	}
	rootController = [controller retain];
	[self.window addSubview:rootController.view];
}

- (void) setRootController:(UIViewController *) controller animationTransition:(UIViewAnimationTransition)transition {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:transition forView:self.window cache:YES];
	self.rootController = controller;
	[UIView commitAnimations];
}

- (void) dealloc {
	self.rootController = nil;
	[window release];
	[super dealloc];
}

@end
