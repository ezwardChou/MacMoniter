//
//  MacMonitor.m
//  MacMonitor
//
//  Created by Edward Chou on 2022/2/23.
//
#import "MacProcessManager.h"
#import "MacMonitor.h"

#import "Finder.h"
#import "Safari.h"


void appObserverCallback(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void * __nullable refcon) {
        
    pid_t pid = [MacProcessManager getFrontMostPid];
    
    NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    
    if (app == nil) {
        return;
    }
    
    NSString *processName = app.localizedName.lowercaseString;
    
    if ([processName containsString:@"safari"]) {
        SafariApplication *safari = [SBApplication applicationWithBundleIdentifier:@"com.apple.Safari"];
        
        for (SafariWindow *window in safari.windows) {
            if ([window visible]) {

                [MacMonitor shareMonitor].callback(app.bundleIdentifier ,window.currentTab.URL, window.currentTab.name, app.localizedName);
                break;
            }
        }

    }
    else {
        
    }
}

@interface MacMonitor ()
@property (nonatomic,strong) NSMutableDictionary *obDict;


@end

@implementation MacMonitor

+(instancetype)shareMonitor{
    static MacMonitor *obj = nil;
    
    if (obj == nil) {
        obj = MacMonitor.new;
        obj.obDict = NSMutableDictionary.new;

    }
    
    return obj;
}

-(void)addWindowObserverForApp:(pid_t)pid withAppName:(NSString *)appName{
    if (_obDict[@(pid)]) {
        return;
    }
    
    AXObserverRef observer;
    if (AXObserverCreate ( pid, (AXObserverCallback)appObserverCallback, &observer) == kAXErrorSuccess) {
        AXUIElementRef element = AXUIElementCreateApplication(pid);
                
        AXError returnValue;
        
        if ([appName.lowercaseString containsString:@"safari"]) {
            returnValue = AXObserverAddNotification( observer, element,kAXFocusedUIElementChangedNotification,  NULL);

        } else {
            returnValue = AXObserverAddNotification( observer, element,kAXTitleChangedNotification, NULL );

        }
        
        
        if (returnValue != kAXErrorSuccess) {
            NSLog(@"Failed to create observer for application");
        }
        NSLog(@"AXError = %d",returnValue);

        
        CFRunLoopAddSource(CFRunLoopGetMain(),
                           AXObserverGetRunLoopSource(observer), kCFRunLoopDefaultMode);
        CFRelease(element);
        
        [_obDict setObject:(__bridge id _Nonnull)(observer) forKey:@(pid)];
    } else {
        NSLog(@"Failed to create observer for application");
    }
    
}


@end
