//
//  AppDelegate.m
//  MacMonitor
//
//  Created by Edward Chou on 2022/2/23.
//
#import "MacMonitor.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString *safariBundleID = @"com.apple.Safari";
    
    pid_t safariPID;
    for (NSRunningApplication *currApp in [[NSWorkspace sharedWorkspace] runningApplications])
    {
        if ([currApp.bundleIdentifier isEqualToString:safariBundleID]) {
            safariPID = currApp.processIdentifier;
            break;
        }
        
    }
    
    if (safariPID == 0) {
        return;
    }
    
    [MacMonitor.shareMonitor addWindowObserverForApp:safariPID withAppName:@"Safari"];
    
    MacMonitor.shareMonitor.callback = ^(NSString * _Nonnull bundleId, NSString * _Nonnull url, NSString * _Nonnull webTitle, NSString * _Nonnull appName) {
        NSLog(@"bundleId = %@, url = %@, webTitle = %@", bundleId, url, webTitle);
    };
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
