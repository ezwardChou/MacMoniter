//
//  MacProcessManager.h
//  mac监控
//
//  Created by mac on 2021/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MacProcessManager : NSObject
+(pid_t)getFrontMostPid;

+(NSString *)getProcessNameWithPid:(pid_t)pid;

+(CGRect)getProcessFrameWithPid:(pid_t)pid;

+(NSString *)getBundleIDWithPid:(pid_t)pid;

+(NSString *)getWindowTitleWithPid:(pid_t)pid;

+(BOOL)getAppActiveWithPid:(pid_t)pid;
@end

NS_ASSUME_NONNULL_END
