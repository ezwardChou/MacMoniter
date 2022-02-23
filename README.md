# MacMonitor

MacMonitor can help you to monitor the Safari behavior and more than that.

---

### Usage

1. Import `ManMonitor.h` 

2. Get the process identifier and add the monitor

You can get more details from the project, there are a few points to pay special attention to:

1. Your macOS App must turn off SandBox mode

2. In Targets->Signing & Capabilities->Add Hardened Runtime, then click on `Apple Events`

3. Info.plist add key `Privacy - AppleEvents Sending Usage Description` or `NSAppleEventsUsageDescription`

4. Enable this application in System Preferences



### About Scripting Bridge

This project is based on `Scripting Bridge`, you can learn more usage in here:

[Introduction to Scripting Bridge Programming Guide for Cocoa](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ScriptingBridgeConcepts/Introduction/Introduction.html#//apple_ref/doc/uid/TP40006104)
