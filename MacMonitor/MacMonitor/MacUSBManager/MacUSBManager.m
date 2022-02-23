//
//  MacUSBManager.m
//  mac监控
//
//  Created by mac on 2021/7/9.
//
#import "MacUSBManager.h"

@implementation NSMutableArray (category)

-(BOOL)containsDisk:(FinderDisk *)disk {
    BOOL contains = NO;
    for (FinderDisk *_disk in self) {


        if ([_disk.URL isEqualToString:disk.URL]) {
            contains = YES;
            break;
        }
    }

    return contains;
}

-(void)removeDisk:(FinderDisk *)disk {
    NSInteger index = 0;
    for (FinderDisk *_disk in self) {
        if ([_disk.URL isEqualToString:disk.URL]) {

            break;
        }

        index++;
    }

    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

@end


@interface MacUSBManager ()
@property (nonatomic,copy) DiskChangedBlock callback;

@property (nonatomic,strong) NSMutableArray *externalDiskArray;

@end

@implementation MacUSBManager

#pragma mark Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _externalDiskArray = [NSMutableArray new];
        
    }
    return self;
}

#pragma mark Public Method
-(void)registerExternalDiskChanged:(void (^)(NSString * _Nonnull, long long, NSDate * _Nonnull, BOOL))callback {
    _callback = callback;
}

-(void)checkExternalDisk{
    FinderApplication *finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
    
    NSMutableArray *newArr = [NSMutableArray new];
    for (FinderDisk *f in finder.disks) {
        if (![f.group isEqualToString:@"root"]) {
            [newArr addObject:f];
        }
    }

    [newArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        FinderDisk *disk1 = obj1;
        FinderDisk *disk2 = obj2;

        return [disk1.name compare:disk2.name];

    }];


    NSMutableArray *newInsertArr = NSMutableArray.new;


    for (FinderDisk *disk in newArr) {
        if (![_externalDiskArray containsDisk:disk]) {
            [newInsertArr addObject:disk];
            _callback(disk.name, disk.capacity, NSDate.date, YES);

        }
    }

    NSMutableArray *removeArray = [NSMutableArray new];

    for (FinderDisk *disk in _externalDiskArray) {
        if (![newArr containsDisk:disk]) {
            [removeArray addObject:disk];
            _callback(disk.name, disk.capacity, NSDate.date, NO);
        }
    }

    _externalDiskArray = [NSMutableArray arrayWithArray:newArr];
}
#pragma mark Private Method

#pragma mark Action Method

#pragma mark Delegate
@end


