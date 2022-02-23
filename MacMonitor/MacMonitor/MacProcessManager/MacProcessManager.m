//
//  MacProcessManager.m
//  mac监控
//
//  Created by mac on 2021/7/3.
//
#import <AppKit/AppKit.h>
#import "MacProcessManager.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation MacProcessManager

+(pid_t)getFrontMostPid{
    NSRunningApplication *app = [[NSWorkspace sharedWorkspace] frontmostApplication];
    
    return app.processIdentifier;
}

+(NSString *)getProcessNameWithPid:(pid_t)pid{
    NSRunningApplication *app = [[NSWorkspace sharedWorkspace] frontmostApplication];
    
    return app.localizedName;
}

+(NSString *)getBundleIDWithPid:(pid_t)pid{
    NSRunningApplication *app = [[NSWorkspace sharedWorkspace] frontmostApplication];
    
    return app.bundleIdentifier;
}

+(NSString *)getWindowTitleWithPid:(pid_t)pid{
    AXUIElementRef app = AXUIElementCreateApplication(pid);
    
    AXUIElementRef frontWindow = NULL;
    AXError err = AXUIElementCopyAttributeValue( (AXUIElementRef)app, (CFStringRef)kAXFocusedWindowAttribute, (CFTypeRef*)&frontWindow );
    CFTypeRef windowTitle;
    AXUIElementCopyAttributeValue((AXUIElementRef)frontWindow, kAXTitleAttribute, (CFTypeRef *)&windowTitle);
    
    if (err != kAXErrorSuccess) {
        return NULL;
    }
    
    if (windowTitle && CFGetTypeID(windowTitle) != CFStringGetTypeID()) { //
        //CFRelease(windowTitle);
        return NULL;
    }

    AXUIElementCopyAttributeValue((AXUIElementRef)app, kAXTitleAttribute, (CFTypeRef *)&windowTitle);
    
    return (__bridge NSString * _Nonnull)(windowTitle);
}

+(CGRect)getProcessFrameWithPid:(pid_t)pid{
    AXUIElementRef app = AXUIElementCreateApplication(pid);
    
    AXUIElementRef frontWindow = NULL;
    AXError err = AXUIElementCopyAttributeValue( (AXUIElementRef)app, (CFStringRef)kAXFocusedWindowAttribute, (CFTypeRef*)&frontWindow );
    
    CFTypeRef point;
    AXUIElementCopyAttributeValue((AXUIElementRef)frontWindow, kAXPositionAttribute, (CFTypeRef *)&point);
    
    CFTypeRef size;
    AXUIElementCopyAttributeValue((AXUIElementRef)frontWindow, kAXSizeAttribute, (CFTypeRef *)&size);
    
    AXValueRef pointValue = point;
    CGPoint p;
    AXValueGetValue(pointValue, kAXValueCGPointType, &p);
    
    AXValueRef sizeValue = size;
    CGSize s;
    AXValueGetValue(sizeValue, kAXValueCGSizeType, &s);
    
    return CGRectMake(p.x, p.y, s.width, s.height);

}


+(BOOL)getAppActiveWithPid:(pid_t)pid{
    NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    
    if (!app) {
        return NO;
    }
    return app.isActive;
}
@end
