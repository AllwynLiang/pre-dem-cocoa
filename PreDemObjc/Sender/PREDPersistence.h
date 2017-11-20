//
//  PREDPersistence.h
//  Pods
//
//  Created by 王思宇 on 14/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "PREDCrashMeta.h"
#import "PREDLagMeta.h"
#import "PREDLogMeta.h"
#import "PREDHTTPMonitorModel.h"
#import "PREDNetDiagResult.h"
#import "PREDAppInfo.h"
#import "PREDCustomEvent.h"
#import "PREDBreadcrumb.h"

@interface PREDPersistence : NSObject

- (void)persistAppInfo:(PREDAppInfo *)appInfo;
- (void)persistCrashMeta:(PREDCrashMeta *)crashMeta;
- (void)persistLagMeta:(PREDLagMeta *)lagMeta;
- (void)persistLogMeta:(PREDLogMeta *)logMeta;
- (void)persistHttpMonitor:(PREDHTTPMonitorModel *)httpMonitor;
- (void)persistNetDiagResult:(PREDNetDiagResult *)netDiagResult;
- (void)persistCustomEvent:(PREDCustomEvent *)event;
- (void)persistBreadcrumb:(PREDBreadcrumb *)breadcrumb;

- (NSString *)nextAppInfoPath;
- (NSString *)nextCrashMetaPath;
- (NSString *)nextLagMetaPath;
- (NSString *)nextLogMetaPath;
- (NSString *)nextHttpMonitorPath;
- (NSString *)nextNetDiagPath;
- (NSString *)nextArchivedCustomEventsPath;
- (NSString *)nextArchivedBreadcrumbPath;

- (NSMutableDictionary *)getLogMeta:(NSString *)filePath error:(NSError **)error;
- (NSMutableDictionary *)getStoredMeta:(NSString *)filePath error:(NSError **)error;
- (void)purgeFile:(NSString *)filePath;
- (void)purgeFiles:(NSArray<NSString *> *)filePaths;
- (void)purgeAllAppInfo;
- (void)purgeAllCrashMeta;
- (void)purgeAllLagMeta;
- (void)purgeAllLogMeta;
- (void)purgeAllHttpMonitor;
- (void)purgeAllNetDiag;
- (void)purgeAllCustom;
- (void)purgeAllPersistence;

@end
