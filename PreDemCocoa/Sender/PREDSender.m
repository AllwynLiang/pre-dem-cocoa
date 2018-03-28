//
//  PREDSender.m
//  Pods
//
//  Created by 王思宇 on 18/09/2017.
//
//

#import "PREDSender.h"
#import "PREDConfigManager.h"
#import "PREDLogger.h"

#define PREDSendInterval    30

@implementation PREDSender {
    PREDPersistence *_persistence;
    PREDNetworkClient *_networkClient;
}

- (instancetype)initWithPersistence:(PREDPersistence *)persistence baseUrl:(NSURL *)baseUrl {
    if (self = [super init]) {
        _persistence = persistence;
        _networkClient = [[PREDNetworkClient alloc] initWithBaseURL:baseUrl];
    }
    return self;
}

- (void)sendAllSavedData {
    PREDLogVerbose(@"trying to send all saved messages");
    [self sendAppInfo:nil];
    [self sendHttpMonitor:nil];
    [self sendNetDiag:nil];
    [self sendCustomEvents:nil];
    [self sendTransactions:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (PREDSendInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sendAllSavedData];
    });
}

- (void)sendAppInfo:(PREDNetworkCompletionBlock)completion {
    NSString *filePath = [_persistence nextArchivedAppInfoPath];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        PREDLogError(@"get stored data %@ error", filePath);
        return;
    }
    __weak typeof(self) wSelf = self;
    [_networkClient postPath:@"app-config" data:data headers:@{@"Content-Type": @"application/json"} completion:^(PREDHTTPOperation *operation, NSData *data, NSError *error) {
        __strong typeof(wSelf) strongSelf = wSelf;
        if (error) {
            PREDLogError(@"get config failed: %@", error);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([dic respondsToSelector:@selector(objectForKey:)]) {
                PREDLogVerbose(@"got config:\n%@", dic);
                [[NSNotificationCenter defaultCenter] postNotificationName:kPREDConfigRefreshedNotification object:self userInfo:@{kPREDConfigRefreshedNotificationConfigKey: dic}];
            } else {
                PREDLogError(@"config received from server has a wrong type: %@", dic);
            }
            [strongSelf->_persistence purgeAllAppInfo];
            if (completion) {
                completion(operation, data, error);
            }
        }
    }];
}

- (void)sendHttpMonitor:(PREDNetworkCompletionBlock)completion {
    NSString *filePath = [_persistence nextArchivedHttpMonitorPath];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        PREDLogError(@"get stored data %@ error", filePath);
        return;
    }
    __weak typeof(self) wSelf = self;
    [_networkClient postPath:@"http-monitors" data:data headers:@{@"Content-Type": @"application/json"} completion:^(PREDHTTPOperation *operation, NSData *data, NSError *error) {
        __strong typeof(wSelf) strongSelf = wSelf;
        if (!error) {
            PREDLogDebug(@"Send http monitor succeeded");
            [strongSelf->_persistence purgeFile:filePath];
            [strongSelf sendHttpMonitor:completion];
        } else {
            PREDLogError(@"upload http monitor fail: %@", error);
        }
        if (completion) {
            completion(operation, data, error);
        }
    }];
}

- (void)sendNetDiag:(PREDNetworkCompletionBlock)completion {
    NSString *filePath = [_persistence nextArchivedNetDiagPath];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
        PREDLogError(@"get stored data %@ error", filePath);
        return;
    }
    __weak typeof(self) wSelf = self;
    [_networkClient postPath:@"net-diags" data:data headers:@{@"Content-Type": @"application/json"} completion:^(PREDHTTPOperation *operation, NSData *data, NSError *error) {
        __strong typeof(wSelf) strongSelf = wSelf;
        if (!error) {
            PREDLogDebug(@"Send net diag succeeded");
            [strongSelf->_persistence purgeFile:filePath];
            [strongSelf sendNetDiag:completion];
        } else {
            PREDLogError(@"send net diag error: %@", error);
        }
        if (completion) {
            completion(operation, data, error);
        }
    }];
}

- (void)sendCustomEvents:(PREDNetworkCompletionBlock)completion {
    NSString *filePath = [_persistence nextArchivedCustomEventsPath];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data.length) {
        PREDLogError(@"get stored data from %@ failed", filePath);
        return;
    }
    __weak typeof(self) wSelf = self;
    [_networkClient postPath:@"custom-events" data:data headers:@{@"Content-Type": @"application/json"} completion:^(PREDHTTPOperation *operation, NSData *data, NSError *error) {
        __strong typeof(wSelf) strongSelf = wSelf;
        if (!error) {
            PREDLogDebug(@"Send custom events succeeded");
            [strongSelf->_persistence purgeFile:filePath];
            [strongSelf sendCustomEvents:completion];
        } else {
            PREDLogError(@"send custom events error: %@", error);
        }
        if (completion) {
            completion(operation, data, error);
        }
    }];
}

- (void)sendTransactions:(PREDNetworkCompletionBlock)completion {
    NSString *filePath = [_persistence nextArchivedTransactionsPath];
    if (!filePath) {
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data.length) {
        PREDLogError(@"get stored data from %@ failed", filePath);
        return;
    }
    __weak typeof(self) wSelf = self;
    [_networkClient postPath:@"transactions" data:data headers:@{@"Content-Type": @"application/json"} completion:^(PREDHTTPOperation *operation, NSData *data, NSError *error) {
        __strong typeof(wSelf) strongSelf = wSelf;
        if (!error) {
            PREDLogDebug(@"Send transactions succeeded");
            [strongSelf->_persistence purgeFile:filePath];
            [strongSelf sendTransactions:completion];
        } else {
            PREDLogError(@"send transactions error: %@", error);
        }
        if (completion) {
            completion(operation, data, error);
        }
    }];
}

@end
