//
//  MacMonitor.h
//  MacMonitor
//
//  Created by Edward Chou on 2022/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MacMonitor : NSObject
@property (nonatomic,copy) void(^callback)(NSString *bundleId, NSString *url, NSString *webTitle, NSString *appName);


+(instancetype)shareMonitor;


/// Add the application monitor with pid and app name
/// @param pid process identifier
/// @param appName app name
-(void)addWindowObserverForApp:(pid_t)pid withAppName:(NSString *)appName;


@end

NS_ASSUME_NONNULL_END
