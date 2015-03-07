#import "../PS.h"

///// iOS 7+ API /////
@interface SBSetupManager : NSObject
+ (SBSetupManager *)sharedInstance;
- (BOOL)isInSetupMode;
- (void)_setInSetupMode:(BOOL)setup;
@end

@interface SBLockScreenViewController : NSObject
- (void)_addOrRemoveBuddyBackgroundIfNecessary;
- (void)_removeBuddyBackground;
@end

@interface SBLockScreenManager : NSObject
+ (SBLockScreenManager *)sharedInstance;
+ (SBLockScreenManager *)sharedInstanceIfExists;
- (SBLockScreenViewController *)lockScreenViewController;
@end
///// iOS 7+ API /////

BOOL overrideBuddy;

%group BlurryOS

%hook SBSetupManager

- (BOOL)isInSetupMode
{
	return overrideBuddy ? YES : %orig;
}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(NSInteger)source withOptions:(id)options
{
	%orig;
	overrideBuddy = YES;
	[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] _addOrRemoveBuddyBackgroundIfNecessary];
	overrideBuddy = NO;
}

%end

%end

%group OlderOS

// Currently don't know where to hook LOL.

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1
{
	%orig;
	if (isiOS7Up) {
		overrideBuddy = YES;
		[[[%c(SBLockScreenManager) sharedInstance] lockScreenViewController] _addOrRemoveBuddyBackgroundIfNecessary];
		overrideBuddy = NO;
	}
}

%end

%ctor
{
	if (isiOS7Up) {
		%init(BlurryOS);
	} else {
		%init(OlderOS);
	}
	%init;
}
