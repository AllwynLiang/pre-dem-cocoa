//
//  PREDLogFormatter.m
//  Pods
//
//  Created by 王思宇 on 05/09/2017.
//
//

#import "PREDLogFormatter.h"

@implementation PREDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    if ([self.delegate respondsToSelector:@selector(logFormatter:willFormatMessage:)]) {
        [self.delegate logFormatter:self willFormatMessage:logMessage];
    }
    if (logMessage.tag) {
        return [NSString stringWithFormat:@"[%@](%@): %@", [self flagString:logMessage.flag], logMessage.tag, logMessage.message];
    } else {
        return [NSString stringWithFormat:@"[%@]: %@", [self flagString:logMessage.flag], logMessage.message];
    }
}

- (NSString *)flagString:(DDLogFlag)flag {
    switch (flag) {
        case DDLogFlagError:
            return @"Error";
        case DDLogFlagWarning:
            return @"Warning";
        case DDLogFlagInfo:
            return @"Info";
        case DDLogFlagDebug:
            return @"Debug";
        case DDLogFlagVerbose:
            return @"Verbose";
        default:
            return @"Unknown";
    }
}

@end
