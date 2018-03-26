//
//  PREDNetDiag.m
//  PreDemCocoa
//
//  Created by WangSiyu on 21/02/2017.
//  Copyright © 2017 pre-engineering. All rights reserved.
//

#import "PREDNetDiag.h"
#import "QNNetDiag.h"
#import "PREDNetDiagResultPrivate.h"

@implementation PREDNetDiag

+ (void)diagnose:(NSString *)host
     persistence:(PREDPersistence *)persistence
        complete:(PREDNetDiagCompleteHandler)complete {
    PREDNetDiagResult *result = [[PREDNetDiagResult alloc] initWithComplete:complete persistence:persistence];
    result.host = host;
    NSString *httpHost;
    if ([host hasPrefix:@"http://"] || [host hasPrefix:@"https://"]) {
        httpHost = host;
        host = [[host componentsSeparatedByString:@"//"] lastObject];
    } else {
        httpHost = [NSString stringWithFormat:@"http://%@", host];
    }
    [QNNPing start:host size:64 output:nil complete:^(QNNPingResult *r) {
        [result gotPingResult:r];
    }];
    [QNNTcpPing start:host output:nil complete:^(QNNTcpPingResult *r) {
        [result gotTcpResult:r];
    }];
    [QNNTraceRoute start:host output:nil complete:^(QNNTraceRouteResult *r) {
        [result gotTrResult:r];
    }];
    [QNNNslookup start:host output:nil complete:^(NSArray *r) {
        [result gotNsLookupResult:r];
    }];
    [QNNHttp start:httpHost output:nil complete:^(QNNHttpResult *r) {
        [result gotHttpResult:r];
    }];
}

@end
