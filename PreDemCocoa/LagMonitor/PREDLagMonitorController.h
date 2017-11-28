//
//  PREDLagMonitorController.h
//  Pods
//
//  Created by WangSiyu on 06/07/2017.
//  Copyright © 2017 pre-engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PREDPersistence.h"

@interface PREDLagMonitorController : NSObject

@property (nonatomic, assign) BOOL started;

- (instancetype)initWithPersistence:(PREDPersistence *)persistence;

@end
