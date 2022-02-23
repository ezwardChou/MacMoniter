//
//  MacUSBManager.h
//  mac监控
//
//  Created by mac on 2021/7/9.
//
#import "Finder.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^DiskChangedBlock)(NSString *diskName, long long capacity, NSDate *date, BOOL isInsert);

@interface MacUSBManager : NSObject
-(void)registerExternalDiskChanged:(DiskChangedBlock)callback;

-(void)checkExternalDisk;
@end

NS_ASSUME_NONNULL_END
